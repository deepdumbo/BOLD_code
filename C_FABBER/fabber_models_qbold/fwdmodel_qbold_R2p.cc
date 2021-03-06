/*   fwdmodel_qbold_R2p.cc - ASE qBOLD curve fitting model


 Matthew Cherukara, IBME

 Copyright (C) 2017 University of Oxford  */

#include "fwdmodel_qbold_R2p.h"

#include "fabber_core/fwdmodel.h"

#include <math.h>
#include <iostream>
#include <vector>
#include <string>
#include <newmatio.h>
#include <stdexcept> 
#include <cmath>
#include <complex>

using namespace std;
using namespace NEWMAT;

// ------------------------------------------------------------------------------------------
// --------         Generic Methods             ---------------------------------------------
// ------------------------------------------------------------------------------------------
FactoryRegistration<FwdModelFactory, R2primeFwdModel>
    R2primeFwdModel::registration("qboldR2p");

FwdModel *R2primeFwdModel::NewInstance() // unchanged
{
    return new R2primeFwdModel();
} // NewInstance

string R2primeFwdModel::GetDescription() const 
{
    return "ASE qBOLD model R2-prime version";
} // GetDescription

string R2primeFwdModel::ModelVersion() const
{
    return "1.7";
} // ModelVersion


// ------------------------------------------------------------------------------------------
// --------         Initialize                  ---------------------------------------------
// ------------------------------------------------------------------------------------------
void R2primeFwdModel::Initialize(ArgsType &args)
{
    infer_OEF = args.ReadBool("inferOEF");
    infer_R2p = args.ReadBool("inferR2p");
    infer_DBV = args.ReadBool("inferDBV");
    infer_R2t = args.ReadBool("inferR2t");
    infer_S0  = args.ReadBool("inferS0");
    infer_Hct = args.ReadBool("inferHct");
    infer_R2e = args.ReadBool("inferR2e");
    infer_dF  = args.ReadBool("inferdF");
    infer_lam = args.ReadBool("inferlam");

    inc_intra = args.ReadBool("include_intra");
    inc_csf = args.ReadBool("include_csf");

    motion_narr = args.ReadBool("motional_narrowing");

    // since we can't do both, OEF will take precidence over R2p
    if (infer_OEF)
    {
        infer_R2p = false;
    }

    if (motion_narr)
    {
        inc_intra = true;
    }

    if (infer_lam)
    {
        inc_csf = true;
    }

    // temporary holders for input values
    string tau_temp;
    string TE_temp; 

    // allow for manual entry of prior precisions
    prec_R2p = convertTo<double>(args.ReadWithDefault("precR2p","1e-2"));
    prec_DBV = convertTo<double>(args.ReadWithDefault("precDBV","1e0"));
    prec_CSF = convertTo<double>(args.ReadWithDefault("precCSF","1e-1"));
    prec_OEF = convertTo<double>(args.ReadWithDefault("precOEF","1e-1"));

    // First read tau values, since these will always be specified

    // this parses through the input args for tau1=X, tau2=X and so on, until it reaches a tau
    // that isn't supplied in the argument, and it adds all these to the ColumnVector taus
    while (true)
    {
        int N = taus.Nrows()+1;
        tau_temp = args.ReadWithDefault("tau"+stringify(N), "stop!");
        if (tau_temp == "stop!") break;

        ColumnVector tmp(1);
        tmp = convertTo<double>(tau_temp);
        taus &= tmp;

    }

    // Then read TE values

    // see if there is a single TE specified
    TE_temp = args.ReadWithDefault("TE","noTE");

    // now loop through the number of tau values, and assign each one a TE
    for (int i = 1; i <= taus.Nrows(); i++)
    {
        // see if there is an input called "TE"
        TE_temp = args.ReadWithDefault("TE","noTE");

        // if there is no "TE", read TE1, TE2, etc.
        if (TE_temp == "noTE")
        {
            TE_temp = args.ReadWithDefault("TE"+stringify(i), "0.082");
        }

        ColumnVector tmp(1);
        tmp = convertTo<double>(TE_temp);
        TEvals &= tmp;

    }

    // read TR and TI
    TR = convertTo<double>(args.ReadWithDefault("TR","3.000"));
    TI = convertTo<double>(args.ReadWithDefault("TI","3.000"));

    // read SR and beta
    SR   = convertTo<double>(args.ReadWithDefault("SR","1.0"));
    beta = convertTo<double>(args.ReadWithDefault("beta","1.0"));

    // add information to the log
    LOG << "Inference using development model" << endl;
    LOG << "Using TR = " << TR << "s, and TI = " << TI << "s" << endl;
    for (int ii = 1; ii <= taus.Nrows(); ii++)
    {
        LOG << "    TE(" << ii << ") = " << TEvals(ii) << "    tau(" << ii << ") = " << taus(ii) << endl;
    }
    if (inc_intra)
    {
        if (motion_narr)
        {
            LOG << "Using two-compartment model with motion narrowing intravascular signal " << endl;
        }
        else
        {
            LOG << "Using two-compartment model with static (powder) intravascular signal " << endl;
        }
    }
    else
    {
        LOG << "Using single-compartment model (ignoring intravascular signal) " << endl;
    }
    if (infer_OEF)
    {
        LOG << "Inferring on OEF " << endl;
    }
    if (infer_R2p)
    {
        LOG << "Inferring on R2p " << endl;
    }
    if (infer_DBV)
    {
        LOG << "Inferring on DBV " << endl;
    }
    if (infer_R2t)
    {
        LOG << "Inferring on R2/T2 of tissue " << endl;
    }
    if (infer_S0)
    {
        LOG << "Inferring on scaling parameter S0 " << endl;
    }
    if (infer_Hct)
    {
        LOG << "Inferring on fractional hematocrit " << endl;
    }
    if (infer_R2e)
    {
        LOG << "Inferring on R2 of CSF " << endl;
    }
    if (infer_dF)
    {
        LOG << "Inferring on CSF frequency shift dF " << endl;
    }
    if (infer_lam)
    {
        LOG << "Inferring on CSF volume fraction lambda " << endl;
    }

    
} // Initialize


// ------------------------------------------------------------------------------------------
// --------         NameParameters              ---------------------------------------------
// ------------------------------------------------------------------------------------------

void R2primeFwdModel::NameParams(vector<string> &names) const
{
    names.clear();

    if (infer_OEF)
    {
        names.push_back("OEF"); // parameter 1 - Oxygen Extraction Fraction
    }
    if (infer_R2p)
    {
        names.push_back("R2p"); // parameter 1 - R2 prime
    }
    if (infer_DBV)
    {
        names.push_back("DBV"); // parameter 2 - DBV
    }
    if (infer_R2t)
    {
        names.push_back("R2t");  // parameter 3 - R2 (of tissue)
    }
    if (infer_S0)
    {
        names.push_back("S0");  // parameter 4 - S0 scaling factor
    }
    if (infer_Hct)
    {
        names.push_back("Hct");  // parameter 4 - S0 scaling factor
    }
    if (infer_R2e)
    {
        names.push_back("R2e");  // parameter 5 - R2 (of CSF)
    }
    if (infer_dF)
    {
        names.push_back("dF");  // parameter 6 - frequency shift of CSF
    }
    if (infer_lam)
    {
        names.push_back("VC");  // parameter 7 - CSF volume fraction
    }
} // NameParams

// ------------------------------------------------------------------------------------------
// --------         HardcodedInitialDists       ---------------------------------------------
// ------------------------------------------------------------------------------------------
void R2primeFwdModel::HardcodedInitialDists(MVNDist &prior, MVNDist &posterior) const
{
    // make sure we have the right number of means specified
    assert(prior.means.Nrows() == NumParams());

    // create diagonal matrix to store precisions
    SymmetricMatrix precisions = IdentityMatrix(NumParams()) * 1e-3;

    if (infer_OEF)
    {
        prior.means(OEF_index()) = 0.4;
        precisions(OEF_index(), OEF_index()) = prec_OEF; // 1e-1
    }
    
    if (infer_R2p)
    {
        prior.means(R2p_index()) = 2.6;
        precisions(R2p_index(), R2p_index()) = prec_R2p;
    }

    if (infer_DBV)
    {
        prior.means(DBV_index()) = 0.036; // 0.036
        precisions(DBV_index(), DBV_index()) = prec_DBV;
    }

    if (infer_R2t)
    {
        prior.means(R2t_index()) = 1/0.087;
        precisions(R2t_index(), R2t_index()) = 1e-2; // 1e0 - more precise
    }

    if (infer_S0)
    {
        prior.means(S0_index()) = 500.0;
        precisions(S0_index(), S0_index()) = 1e-6; // 1e-5 - always imprecise
    }

    if (infer_Hct)
    {
        prior.means(Hct_index()) = 0.40;
        precisions(Hct_index(), Hct_index()) = 1e3; // 1e3 - always very precise
    }

    if (infer_R2e)
    {
        prior.means(R2e_index()) = 0.5;
        precisions(R2e_index(), R2e_index()) = 1e-2; // 1e-2
    }
    
    if (infer_dF)
    {
        prior.means(dF_index()) = 5.0;
        precisions(dF_index(), dF_index()) = 1e-2; // 1e-2
    }

    if (infer_lam)
    {
        prior.means(lam_index()) = 0.05;
        precisions(lam_index(), lam_index()) = prec_CSF; // 1e-1
    }

    prior.SetPrecisions(precisions);

    posterior = prior; // we don't need to change the initial guess (at least, not at this stage)

    
    // Set distributions for initial posteriors
    if (infer_OEF)
    {
        posterior.means(OEF_index()) = 0.4;
        precisions(OEF_index(), OEF_index()) = 1e-1; // 1e1
    }
    
    if (infer_R2p)
    {
        posterior.means(R2p_index()) = 2.6;
        precisions(R2p_index(), R2p_index()) = 1e-3;
    }

    if (infer_DBV)
    {
        posterior.means(DBV_index()) = 0.036;
        precisions(DBV_index(), DBV_index()) = 1e-1; 
    }

    if (infer_R2t)
    {
        posterior.means(R2t_index()) = 1/0.087;
        precisions(R2t_index(), R2t_index()) = 1e0; 
    }

    if (infer_S0)
    {
        posterior.means(S0_index()) = 700.0;
        precisions(S0_index(), S0_index()) = 1e-5;
    }

    if (infer_Hct)
    {
        posterior.means(Hct_index()) = 0.40;
        precisions(Hct_index(), Hct_index()) = 1e3;
    }

    if (infer_R2e)
    {
        posterior.means(R2e_index()) = 0.5;
        precisions(R2e_index(), R2e_index()) = 1e-2; // 1e-2
    }
    
    if (infer_dF)
    {
        posterior.means(dF_index()) = 5.0;
        precisions(dF_index(), dF_index()) = 1e-2; // 1e-2
    }

    if (infer_lam)
    {
        posterior.means(lam_index()) = 0.1;
        precisions(lam_index(), lam_index()) = 1e-1; // 1e1
    } 

    
    posterior.SetPrecisions(precisions);

} // HardcodedInitialDists

// ------------------------------------------------------------------------------------------
// --------         Evaluate                    ---------------------------------------------
// ------------------------------------------------------------------------------------------
void R2primeFwdModel::Evaluate(const ColumnVector &params, ColumnVector &result) const
{
    // Check we have been given the right number of parameters
    assert(params.Nrows() == NumParams());
    result.ReSize(data.Nrows());

    ColumnVector paramcpy = params;

    // calculated parameters
    double St;  // tissue signal
    double Sb;  // blood signal
    double Se;  // extracellular signal
    complex<double> Sec; // complex version of the extracellular signal (may be unnecessary)

    complex<double> i(0,1);

    // derived parameters
    double dw;          // characteristic time (protons in water)
    double R2b;
    double R2bp;
    double tc;
    double lam0;        // apparent lambda (opposite way round from literature!)
    double mt;
    double me;
    double mb;
    double SR2p;        // for arbitary R2' scaling
    double SRb;

    // parameters
    double OEF;
    double R2p;
    double DBV;
    double R2t;
    double S0;
    double Hct;
    double R2e;
    double dF;
    double lam;
    double CBV;


    // assign values to parameters
    if (infer_DBV)
    {
        DBV = (paramcpy(DBV_index()));
        if (DBV < 0.0001)
        {
            DBV = 0.0001;
        }
        else if (DBV > 1.0)
        {
            DBV = 1.0;
        }
        
    }
    else
    {
        DBV = 0.03;
    }
    if (infer_R2t)
    {
        R2t = (paramcpy(R2t_index()));
    }
    else
    {
        R2t = 11.5;
    }
    if (infer_S0)
    {
        S0 = (paramcpy(S0_index()));
    }
    else
    {
        S0 = 100.0;
    }
    if (infer_Hct)
    {
        Hct = (paramcpy(Hct_index()));
    }
    else
    {
        Hct = 0.40;
    }
    if (infer_R2e)
    {
        R2e = (paramcpy(R2e_index()));
    }
    else
    {
        R2e = 1.0;
    }
    if (infer_dF)
    {
        dF = (paramcpy(dF_index()));
    }
    else
    {
        dF = 6.00;
    }
    if (infer_lam)
    {
        lam = (paramcpy(lam_index()));
    }
    else
    {
        lam = 0.0;
    }

    // this one is a little bit different
    if (infer_OEF)
    {
        OEF = (paramcpy(OEF_index()));
        dw = 887.4082*pow(Hct*OEF,beta);
        R2p = dw*DBV*SR;
    }
    else if (infer_R2p)
    {
        R2p = (paramcpy(R2p_index()));
        /*if (DBV < 0.0001)
        {
            DBV = 0.0001;
        }*/
        OEF = pow(R2p/(887.4082*DBV),1/beta)/Hct;
        /*if (OEF < 0.01)
        {
            OEF = 0.01;
        }*/
        dw = 887.4082*pow(Hct*OEF,beta);

        // SRb = 6.263*(1-exp(-3.477*OEF));
        // SRb = 4.7;
        // SR2p = 2.76*OEF*exp(-SRb*TEvals(1));
        // SR2p = 0.96 - (0.38*OEF);
        // SR2p = 0.77 - 2.78*TEvals(1);

        /*
        if (SR2p < 0.01)
        {
            SR2p = 0.01;
        } */ 

        SR2p = SR;
       
        R2p = dw*DBV*SR2p;

    }
    else
    {
        OEF = 0.3;
        R2p = 2.5;
    }

    // calculate tc and threshold it if necessary
    tc = 1.7/dw;
    /*
    if (tc > 0.025)
    {
        tc = 0.025;
    }
    else if (tc < 0.005)
    {
        tc = 0.005;
    } */

    // evaluate blood relaxation rates
    R2b  = ( 4.5 + (16.4*Hct)) + ( ((165.2*Hct) + 55.7)*pow(OEF,2.0) );
    R2bp = (10.2 - ( 1.5*Hct)) + ( ((136.9*Hct) - 13.9)*pow(OEF,2.0) );

    // here are some more constants we will need
    double T1t = 1.20;
    double T1e = 3.87;
    double T1b = 1.58;

    double nt = 0.723;
    double ne = 1.000;
    double nb = 0.775;

    // we can do the magnetization stuff outside the loop, since they are not affected by tau

    // calculate steady state magnetization values, for tissue, blood, and CSF
    // NEW VERSION
    mt = 1.0 - (2.0*exp(-TI/T1t)) + exp(-TR/T1t);
    mb = 1.0 - (2.0*exp(-TI/T1b)) + exp(-TR/T1b);
    me = 1.0 - (2.0*exp(-TI/T1e)) + exp(-TR/T1e);
    

    // OLD VERSION (with no TAU dependence)
    /*
    double TE = TEvals(1);
    mt = exp(-TE*R2t) * ( 1 - ( 1 + (2*exp(TE/(2*T1t))) ) * ( 2 - exp(-(TR-TI)/T1t)) * exp(-TI/T1t) );
    mb = exp(-TE*R2b) * ( 1 - ( 1 + (2*exp(TE/(2*T1b))) ) * ( 2 - exp(-(TR-TI)/T1b)) * exp(-TI/T1b) );
    me = exp(-TE*R2e) * ( 1 - ( 1 + (2*exp(TE/(2*T1e))) ) * ( 2 - exp(-(TR-TI)/T1e)) * exp(-TI/T1e) );
      */                          
    /* OLD OLD VERSION
    mt = exp(-(TE-tau)*R2t) * ( 1 - ( 1 + (2*exp((TE-tau)/(2*T1t))) ) 
                                * ( 2 - exp(-(TR-TI)/T1t)) * exp(-TI/T1t)  );
    mb = exp(-(TE-tau)*R2b) * ( 1 - ( 1 + (2*exp((TE-tau)/(2*T1b))) ) 
                                * ( 2 - exp(-(TR-TI)/T1b)) * exp(-TI/T1b)  );
    me = exp(-(TE-tau)*R2e) * ( 1 - ( 1 + (2*exp((TE-tau)/(2*T1e))) ) 
                                * ( 2 - exp(-(TR-TI)/T1e)) * exp(-TI/T1e)  );
    */

    // calculate tissue compartment weightings
    lam0 = (ne*me*lam) / ( (nt*mt*(1-lam)) + (ne*me*lam) );
    CBV = nb*mb*(1-lam0)*DBV;

    // loop through taus
    result.ReSize(taus.Nrows());

    for (int ii = 1; ii <= taus.Nrows(); ii++)
    {
        double tau = taus(ii);
        double TE = TEvals(ii);

        // calculate tissue signal
        if (tau < -tc)
        {
            St = exp(DBV + (R2p*tau));
        }
        else if (tau > tc)
        {
            St = exp(DBV - (R2p*tau));
        }
        else
        {
            St = exp(-0.3*pow(R2p*tau,2.0)/DBV);
        }

        // add T2 effect to tissue compartment
        St *= exp(-R2t*TE);

        // calculate intravascular signal
        if (motion_narr)
        {
            // parameters
            double td   = 0.0045067;       // (based on rc=2.6 um and D=1.5 um^2 / ms)
            double gm   = 2.67513e8;
            double dChi = (((-0.736 + (0.264*OEF))*Hct) + (0.722*(1-Hct)))*1e-6;
            double G0   = (4/45)*Hct*(1-Hct)*pow((dChi*3.0),2.0);
            double kk   = 0.5*pow(gm,2.0)*G0*pow(td,2.0);

            // motion narrowing model
            Sb = exp(-kk* ( (TE/td) + pow((0.25 + (TE/td)),0.5) + 1.5 - 
                            (2*pow((0.25 + (pow((TE+tau),2.0)/td) ),0.5)) - 
                            (2*pow((0.25 + (pow((TE-tau),2.0)/td) ),0.5)) ) );

            // T2 effect 
            Sb *= exp(-R2b*TE); 

        } // if (motion_narr)
        else if (inc_intra)
        {
            // linear model
            Sb = exp(-R2b*TE)*exp(-R2bp*abs(tau));

        } // if (motion_narr) ... else if (inc_intra)
        else
        {
            Sb = 0.0;

        } // if (motion_narr) ... else if (inc_intra) ... else ...

        // calculate CSF signal
        if (inc_csf)
        {
            Sec = exp(-R2e*TE)*exp(-2.0*i*M_PI*dF*abs(tau));
            Se = abs(Sec);
        }
        else
        {
            Se = 0.0;
        }

        // add up the compartments
        result(ii) = S0*(((1-CBV-lam0)*St) + (CBV*Sb) + (lam0*Se));

    } // for (int i = 1; i <= taus.Nrows(); i++)

    
    // alternative, if values are outside reasonable bounds
    /*
    if ( DBV > 0.5 || Hct > 1.0 || OEF > 1.0 || lam0 > 1.0 )
    {
        for (int ii = 1; ii <= taus.Nrows(); ii++)
        {
            result(ii) = result(ii)*100.0;
        }
    }*/
    

    return;

} // Evaluate

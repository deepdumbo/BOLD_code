/*   fwdmodel_qbold.cc - Implements the ASE qBOLD curve fitting model

 Matthew Cherukara, IBME

 Copyright (C) 2017 University of Oxford  */

#include "fwdmodel_qbold.h"

#include "fabber_core/fwdmodel.h"

#include <math.h>
#include <iostream>
#include <vector>
#include <string>
#include <newmatio.h>
#include <stdexcept> 
#include <cmath>

using namespace std;
using namespace NEWMAT;

// ------------------------------------------------------------------------------------------
// --------         Generic Methods             ---------------------------------------------
// ------------------------------------------------------------------------------------------
FactoryRegistration<FwdModelFactory, QBoldFwdModel>
    QBoldFwdModel::registration("qBOLD");

FwdModel *QBoldFwdModel::NewInstance() // unchanged
{
    return new QBoldFwdModel();
} // NewInstance

string QBoldFwdModel::GetDescription() const 
{
    return "ASE qBOLD model";
} // GetDescription

string QBoldFwdModel::ModelVersion() const
{
    return "1.0";
} // ModelVersion

static OptionSpec OPTIONS[] = {
    { "use-offset", OPT_BOOL, "If True, allow an additional constant offset parameter", OPT_NONREQ, "false" },
    { "" }
};

void QBoldFwdModel::GetOptions(vector<OptionSpec> &opts) const
{
    for (int i = 0; OPTIONS[i].name != ""; i++)
    {
        opts.push_back(OPTIONS[i]);
    }
} // GetOptions

// ------------------------------------------------------------------------------------------
// --------         Initialize                  ---------------------------------------------
// ------------------------------------------------------------------------------------------
void QBoldFwdModel::Initialize(ArgsType &args)
{
    // read through input arguments using &args
    TE = convertTo<double>(args.ReadWithDefault("TE","0.074"));

    // collect tau values
    string tau_temp;

    // this parses through the input args for tau1=X, tau2=X and so on, until it reaches a
    // tau that isn't supplied in the argument, and it adds all these to the ColumnVector
    // called tau_list
    while (true)
    {
        int N = tau_list.Nrows()+1;
        tau_temp = args.ReadWithDefault("tau"+stringify(N), "stop!");
        if (tau_temp == "stop!") break;

        ColumnVector tmp(1);
        tmp = convertTo<double>(tau_temp);
        tau_list &= tmp;
    }

    taus = tau_list; // why is this necessary?
    
} // Initialize


// ------------------------------------------------------------------------------------------
// --------         NameParameters              ---------------------------------------------
// ------------------------------------------------------------------------------------------

void QBoldFwdModel::NameParams(vector<string> &names) const
{
    names.clear();

    names.push_back("OEF"); // parameter 1 - OEF
    names.push_back("DBV"); // parameter 2 - DBV

} // NameParams

// ------------------------------------------------------------------------------------------
// --------         HardcodedInitialDists       ---------------------------------------------
// ------------------------------------------------------------------------------------------
void QBoldFwdModel::HardcodedInitialDists(MVNDist &prior, MVNDist &posterior) const
{
    // make sure we have the right number of means specified
    assert(prior.means.Nrows() == NumParams());

    // create diagonal matrix to store precisions
    SymmetricMatrix precisions = IdentityMatrix(NumParams()) *1e-12;

    prior.means(1) = 0.5;  // set initial guess of OEF to be 0.5
    prior.means(2) = 0.05; // set initial guess of DBV to be 0.05

    precisions(1, 1) = 10; // set both priors to be completely uniformative
    precisions(2, 2) = 10; 

    prior.SetPrecisions(precisions);

    posterior = prior; // we don't need to change the initial guess (at least, not at this stage)
    

} // HardcodedInitialDists

// ------------------------------------------------------------------------------------------
// --------         Evaluate                    ---------------------------------------------
// ------------------------------------------------------------------------------------------
void QBoldFwdModel::Evaluate(const ColumnVector &params, ColumnVector &result) const
{
    // Check we have been given the right number of parameters
    assert(params.Nrows() == NumParams());
    result.ReSize(data.Nrows());

    ColumnVector paramcpy = params;

    // calculated parameters
    double St;  // tissue signal
    double Sb;  // blood signal

    // derived parameters
    double dw;
    double R2b;
    double R2bs;
    double R2tp;

    // parameters
    double OEF;
    double DBV;

    // pull out parameter values
    OEF = paramcpy(1);
    DBV = paramcpy(2); 

    // now evaluate the static dephasing qBOLD model for 2 compartments
    dw = 301.7433*OEF;
    R2tp = DBV*dw;

    R2b  = 10.076 + (111.868*pow(OEF,2.0));
    R2bs = 19.766 + (144.514*pow(OEF,2.0));

    // loop through taus
    result.ReSize(taus.Nrows());

    for (int i = 1; i <= taus.Nrows(); i++)
    {
        double tau = taus(i);

        if (tau < (-1.5/dw))
        {
            St = exp(DBV + (R2tp*tau));
        }
        else if (tau > (1.5/dw))
        {
            St = exp(DBV - (R2tp*tau));
        }
        else
        {
            St = exp(-0.3*DBV*pow(dw*tau,2.0));
        }

        Sb = exp(-R2b*(TE-tau)*exp(-R2bs*abs(tau)));

        // Total signal
        result(i) = ((1-DBV)*St) + (DBV*Sb);

    } // for (int i = 1; i <= taus.Nrows(); i++)

    return;

} // Evaluate

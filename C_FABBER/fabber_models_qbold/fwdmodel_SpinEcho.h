/*   fwdmodel_qbold_R2p.h - The ASE qBOLD curve fitting model, fitting R2-prime and DBV

 Matthew Cherukara, IBME

 Copyright (C) 2017 University of Oxford  */

#ifndef FWDMODEL_SPINECHO_H
#define FWDMODEL_SPINECHO_H

#include "fabber_core/fwdmodel.h"
#include "fabber_core/inference.h"

#include "newmat.h"

#include <string>

using namespace std;

class SpinEchoFwdModel : public FwdModel {
public:
    static FwdModel* NewInstance();

    // virtual function overrides
    virtual void Initialize(ArgsType &args);
    virtual string ModelVersion() const;
    virtual string GetDescription() const;

    virtual void NameParams(vector<string> &names) const;
    virtual int NumParams() const 
    {
        return 2;
    }    
    virtual void HardcodedInitialDists(MVNDist &prior, MVNDist &posterior) const;
    virtual void Evaluate(const NEWMAT::ColumnVector &params, NEWMAT::ColumnVector &result) const;

protected:

    // Scan Parameters
    NEWMAT::ColumnVector TEs;

    // Lookup starting indices of parameters
    int R2_index() const
    {
        return 1;
    }
    int S0_index() const
    {
        return 2;
    }

private:
    static FactoryRegistration<FwdModelFactory, SpinEchoFwdModel> registration;
};

#endif // FWDMODEL_SPINECHO_H
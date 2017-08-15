/*   fwdmodel_qbold_T2.h - The ASE qBOLD curve fitting model, with T2 decay

 Matthew Cherukara, IBME

 Copyright (C) 2017 University of Oxford  */

#ifndef FWDMODEL_QBOLD_T2_H
#define FWDMODEL_QBOLD_T2_H

#include "fabber_core/fwdmodel.h"
#include "fabber_core/inference.h"

#include "newmat.h"

#include <string>

using namespace std;

class T2qBoldFwdModel : public FwdModel {
public:
    static FwdModel* NewInstance();

    // virtual function overrides
    virtual void Initialize(ArgsType &args);
    virtual string ModelVersion() const;
    virtual string GetDescription() const;

    virtual void NameParams(vector<string> &names) const;
    virtual int NumParams() const 
    {
        return (infer_OEF ? 1 : 0) + (infer_DBV ? 1 : 0) + (infer_R2t ? 1 : 0) + (infer_S0 ? 1 : 0);
    }
    virtual void HardcodedInitialDists(MVNDist &prior, MVNDist &posterior) const;
    virtual void Evaluate(const NEWMAT::ColumnVector &params, NEWMAT::ColumnVector &result) const;

protected:

    // Scan Parameters
    NEWMAT::ColumnVector tau_list;
    NEWMAT::ColumnVector taus;
    double TE;

    // Lookup starting indices of parameters
    int OEF_index() const
    {
        return (infer_OEF ? 1 : 0);
    }

    int DBV_index() const
    {
        return OEF_index() + (infer_DBV ? 1 : 0);
    }

    int R2t_index() const
    {
        return DBV_index() + (infer_R2t ? 1 : 0);
    }

    int S0_index() const
    {
        return R2t_index() + (infer_S0 ? 1 : 0);
    }

    // Which parameters will we infer on
    bool infer_OEF;
    bool infer_DBV;
    bool infer_R2t;
    bool infer_S0;

private:
    static FactoryRegistration<FwdModelFactory, T2qBoldFwdModel> registration;
};

#endif // FWDMODEL_QBOLD_T2_H
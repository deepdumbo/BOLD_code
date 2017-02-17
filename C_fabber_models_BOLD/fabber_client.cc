/*  FABBER - Fast ASL and BOLD Bayesian Estimation Routine

    Michael Chappell, FMRIB Image Analysis & IBME QuBIc Groups

    Copyright (C) 2007-2015 University of Oxford  */

/*  CCOPYRIGHT */

#include "fabbercore/fabber_core.h"

// ASL models to be included from library
#include "fwdmodel_asl_multiphase.h"
#include "fwdmodel_asl_grase.h"
#include "fwdmodel_asl_rest.h"
#include "fwdmodel_BOLD_MTC.h"
#include "fwdmodel_BOLD_2_MTC.h"
#include "fwdmodel_BOLD_3_MTC.h"

int main(int argc, char** argv) {

  //add the ASL models from the library - these will autoregister at this point
  // GraseFwdModel::NewInstance();
  // ASLFwdModel::NewInstance();
  // MultiPhaseASLFwdModel::NewInstance();
  BOLDFwdModel::NewInstance();
  BOLD2cFwdModel::NewInstance();
  BOLDR2FwdModel::NewInstance();

  return execute(argc, argv);

}















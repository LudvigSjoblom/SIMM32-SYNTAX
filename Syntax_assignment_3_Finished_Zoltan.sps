* Encoding: UTF-8.

RECODE sex ('female'=0) ('male'=1) INTO Sex_New.
VARIABLE LABELS  Sex_New 'Sex dummy'.
EXECUTE.


RANDOM INTERCEPT MODEL

MIXED pain BY sex_new WITH age STAI_trait pain_cat cortisol_serum mindfulness
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=sex_new age STAI_trait pain_cat cortisol_serum mindfulness | SSTYPE(3)
  /METHOD=REML
  /PRINT=SOLUTION
  /RANDOM=INTERCEPT | SUBJECT(hospital) COVTYPE(VC).



MIXED pain BY sex_new WITH age STAI_trait pain_cat cortisol_serum mindfulness
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=sex age STAI_trait pain_cat cortisol_serum mindfulness | SSTYPE(3)
  /METHOD=REML
  /PRINT=SOLUTION
  /RANDOM=INTERCEPT | SUBJECT(hospital) COVTYPE(VC)
  /SAVE=FIXPRED.


*Dataset 2*

RECODE sex ('female'=0) ('male'=1) INTO Sex_New.
VARIABLE LABELS  Sex_New 'Sex dummy'.
EXECUTE.

COMPUTE Prediction=2.23 + age * -0.02 + STAI_trait * -0.01 + pain_cat * 0.08 + cortisol_serum * 0.53 + 
    mindfulness * -0.23 + sex_new * -0.38.
EXECUTE.


DESCRIPTIVES VARIABLES=pain
  /STATISTICS=MEAN SUM STDDEV MIN MAX.

COMPUTE Residual_Pain=pain - Prediction.
EXECUTE.

COMPUTE RSS=Residual_Pain * Residual_Pain.
EXECUTE.


COMPUTE TSS=(pain - 4.99) * (pain - 4.99).
EXECUTE.


DESCRIPTIVES VARIABLES=TSS RSS
  /STATISTICS=MEAN SUM STDDEV MIN MAX.



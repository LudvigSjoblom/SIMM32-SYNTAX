* Encoding: UTF-8.
* Encoding: .
* Encoding: .
* Encoding: .
Data set 1

RECODE age (1 thru 50=1) (ELSE=0) INTO Age_New.
EXECUTE.

USE ALL.
FILTER BY Age_New.
EXECUTE.

RECODE sex ('female'=1) ('male'=0) INTO Sex_New.
EXECUTE.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA selection 
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT pain
  /METHOD=ENTER age STAI_trait pain_cat cortisol_serum mindfulness weight Sex_New.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA 
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT pain
  /METHOD=BACKWARD STAI_trait pain_cat cortisol_serum weight Sex_New age mindfulness.



REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA selection 
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT pain
  /METHOD=ENTER age STAI_trait pain_cat cortisol_serum mindfulness Sex_New.


Home sample data 2

RECODE sex ('female'=1) ('male'=0) INTO Sex_New.
EXECUTE.


COMPUTE pred_theory=4.761 - 0.079 * age - 0.326 * sex_new + 0.017 * STAI_trait + 
    0.057 * pain_cat - 0.282 * mindfulness + 0.392 * cortisol_serum.
EXECUTE.



COMPUTE Pred_backwards=4.606 + (Age * -0.075) + (pain_cat * 0.066) + (cortisol_serum * 0.411) + 
    (mindfulness * -0.290)  + (Sex_New * 0.309).
EXECUTE.

COMPUTE Residual_Theory=pain - pred_theory.
EXECUTE.


COMPUTE Residual_Backward=pain - Pred_backwards.
EXECUTE.

COMPUTE Risduals_Theory_SQ=Residual_Theory * Residual_Theory.
EXECUTE.

COMPUTE Residual_Backward_SQ=Residual_Backward * Residual_Backward.
EXECUTE.


DESCRIPTIVES VARIABLES=Risduals_Theory_SQ Residual_Backward_SQ
  /STATISTICS=MEAN SUM STDDEV MIN MAX.



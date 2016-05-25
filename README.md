This repository contains code and data for:

Jern, A., Chang, K. K., & Kemp, C. (2014). Belief polarization is not always irrational. *Psychological Review, 121*(2), 206-224.

# Models

All of these files require installation of the [Bayes Net Toolbox](https://code.google.com/p/bnt/) for Matlab (created by Kevin Murphy).

## Lord, Ross, & Lepper (1979) model predictions

* `lrl_model1.m`: This script generates the model predictions shown in Figure 4.a.ii and the first column of Figure 5b.
* `lrl_model2.m`: This script generates the model predictions shown in Figure 4.b.ii and the second column of Figure 5b.
* `adjust_p.m`: This function applies the logit transformation.

## Batson (1975) model predictions

* `batson_model.m`: This script generates the model predictions shown in Figure 4.c.ii.

## How common is normative belief divergence?

The following three scripts were used to generate the results in Table 2.

* `divergencefrequency1.m`
* `divergencefrequency2.m`
* `divergencefrequency3.m`

## Model predictions for the experiment

* `diagnosis_model.m`: This script generates the qualitative model predictions for the experiment. Specifically, this script verifies that the Bayes net in Figure 7 can produce either convergence or divergence, depending on the pair of test results.

# Data

* `results_noforcedchoice.xlsx`
* `results_forcedchoice.xlsx`

These Excel files contain the participants' numerical judgments (from -100 to +100) before and after observing the test result. They also contain written explanations that participants provided for their judgments (why they changed or why they didn't). Each file contains three spreadsheets, each with data from one of the three conditions.

The first file contains data from participants that were not asked the forced choice question. The second file contains data from participants that were asked the forced choice question.
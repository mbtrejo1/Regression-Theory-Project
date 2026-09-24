---
  
  title: "Flipper Length and Body Mass in Female Adelie Penguins"
subtitle: "A Simple Linear Regression Analysis"
author: "Your Name"
date: today
date-format: long
abstract: "This analysis examines the relationship between flipper length and body mass among female Adelie penguins. A simple linear regression model is used to determine whether flipper length is associated with body mass. The fitted model indicates whether penguins with longer flippers tend to have greater body mass."
format: pdf
number-sections: true
---------------------
  
  ```{r}
#| include: false
#| warning: false
#| message: false

library(tidyverse)
library(palmerpenguins)
```

# Introduction

The main question of this analysis is whether flipper length is associated with body mass among female Adelie penguins.

This relationship is useful to study because physical characteristics of animals are often related to one another. Understanding the relationship between flipper length and body mass may help describe patterns in penguin morphology.

We expect that female Adelie penguins with longer flippers will, on average, have greater body mass.

@sec-data introduces the data used in this analysis. @sec-methods describes the statistical model. @sec-results presents the results of the regression analysis, and @sec-discussion discusses the findings and limitations.

# Data {#sec-data}

```{r}
#| label: fig-adelie-scatter
#| echo: false
#| warning: false
#| message: false
#| fig-cap: "Scatter plot of flipper length in millimeters and body mass in grams for female Adelie penguins, with a fitted simple linear regression line."

data(penguins)

adelie <- penguins |>
  filter(
    species == "Adelie",
    sex == "female"
  ) |>
  drop_na(flipper_length_mm, body_mass_g)

ggplot(
  adelie,
  aes(
    x = flipper_length_mm,
    y = body_mass_g
  )
) +
  geom_point() +
  geom_smooth(
    method = "lm",
    se = FALSE
  ) +
  theme_minimal() +
  labs(
    x = "Flipper length (mm)",
    y = "Body mass (grams)",
    title = "Flipper length and body mass\nfor female Adelie penguins"
  )
```

The `palmerpenguins` package provides measurements of penguins observed in the Palmer Archipelago near Palmer Station, Antarctica. Each row represents an individual penguin and includes variables such as species, sex, flipper length, bill measurements, and body mass.

This analysis focuses on the `r nrow(adelie)` female Adelie penguins with non-missing measurements of flipper length and body mass.

@fig-adelie-scatter shows a positive association between flipper length and body mass. In general, female Adelie penguins with longer flippers appear to have greater body mass.

# Methods {#sec-methods}

I fit the simple linear regression model

$$
  Y_i = \beta_0 + \beta_1 X_i + \varepsilon_i,
$$
  
  where

* $Y_i$ is the body mass, in grams, of penguin $i$,
* $X_i$ is the flipper length, in millimeters, of penguin $i$,
* $\beta_0$ is the intercept,
* $\beta_1$ is the slope, and
* $\varepsilon_i$ is the random error term.

In this model, $\beta_1$ represents the expected change in mean body mass associated with a one-millimeter increase in flipper length.

I test

$$
  H_0:\beta_1=0
$$
  
  against the two-sided alternative

$$
  H_A:\beta_1\neq0.
$$
  
  For the usual regression inference to be valid, we assume that the mean relationship between flipper length and body mass is linear, the errors are independent, the errors have approximately constant variance, and the errors are approximately normally distributed.

The analysis was conducted using the R programming language.

# Results {#sec-results}

```{r}
#| label: adelie-lm
#| echo: false
#| warning: false
#| message: false

lm_fit <- lm(
  body_mass_g ~ flipper_length_mm,
  data = adelie
)

lm_summary <- summary(lm_fit)

b0 <- coef(lm_fit)[1]
b1 <- coef(lm_fit)[2]

slope_se <- lm_summary$coefficients[2, 2]
slope_t <- lm_summary$coefficients[2, 3]
slope_p <- lm_summary$coefficients[2, 4]
```

The estimated regression equation is

$$
  \widehat{Y}
=
  `r round(b0, 2)`
+
  `r round(b1, 2)`X.
$$
  
  The estimated slope is $b_1=$ `r round(b1, 3)`. Therefore, for each additional millimeter of flipper length, the model predicts an average increase of approximately `r round(b1, 2)` grams in body mass.

The estimated intercept is $b_0=$ `r round(b0, 2)` grams. This is the predicted body mass when flipper length is 0 mm. Since a flipper length of 0 mm is far outside the observed data, the intercept does not have a meaningful biological interpretation in this study.

For the test of

$$
  H_0:\beta_1=0,
$$
  
  the test statistic is

$$
  t=`r round(slope_t, 3)`,
$$
  
  with a p-value of `r format.pval(slope_p, digits = 3)`.

```{r}
#| label: fig-adelie-residual
#| echo: false
#| warning: false
#| message: false
#| fig-cap: "Residuals versus fitted values for the simple linear regression model predicting body mass from flipper length."

plot_dat <- data.frame(
  residual = resid(lm_fit),
  fitted = fitted(lm_fit)
)

ggplot(
  plot_dat,
  aes(
    x = fitted,
    y = residual
  )
) +
  geom_point() +
  geom_hline(
    yintercept = 0,
    linetype = "dashed"
  ) +
  theme_minimal() +
  labs(
    x = "Fitted body mass (grams)",
    y = "Residual (observed - fitted)",
    title = "Residuals vs. fitted values"
  )
```

@fig-adelie-residual can be used to evaluate the linearity and constant-variance assumptions. Ideally, the residuals should be randomly scattered around zero without a strong curved pattern or a clear increase or decrease in their spread.

# Discussion {#sec-discussion}

The fitted regression model indicates a positive relationship between flipper length and body mass among female Adelie penguins. Female Adelie penguins with longer flippers tend, on average, to have greater body mass.

The slope estimate suggests that a one-millimeter increase in flipper length is associated with an estimated increase of approximately `r round(b1, 2)` grams in expected body mass.

The p-value for the slope test is `r format.pval(slope_p, digits = 3)`. This provides evidence concerning whether the population slope differs from zero.

However, this is an observational dataset, so the regression does not establish that increasing flipper length causes an increase in body mass. Other biological characteristics may influence both measurements. In addition, the conclusions apply specifically to female Adelie penguins represented in these data and should not automatically be generalized to other penguin species or populations.

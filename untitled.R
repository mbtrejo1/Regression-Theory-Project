library(dplyr)
#this removes Age= -1 point in dataset
suicide_dataset <- suicide_dataset |>
  filter(Age >= 0)
deaths_per_age <- suicide_dataset |>
  group_by(Age) |>
  summarise(deaths = n()) |>
  arrange(Age)

plot(deaths_per_age$Age,
     deaths_per_age$deaths,
     xlab = "Age",
     ylab = "Number of Deaths",
     main = "Suicide Deaths by Age in Santa Clara County",
     pch = 19)

model <- lm(deaths ~ Age, data = deaths_per_age)

abline(model)

summary(model)

plot(deaths_per_age$Age,
     residuals(model),
     xlab = "Age",
     ylab = "Residuals",
     main = "Residuals vs Age",
     pch = 19)

abline(h = 0)

qqnorm(residuals(model))
qqline(residuals(model))
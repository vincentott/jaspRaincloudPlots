
library(ggplot2)
library(ggrain)
library(palmerpenguins)

simplePenguins <- penguins[complete.cases(penguins), ]
# simplePenguins <- subset(simplePenguins, year < 2009)
# simplePenguins <- subset(simplePenguins, species != "Chinstrap")
simplePenguins$year <- as.factor(simplePenguins$year)

# Only variable
ggplot(data = simplePenguins, aes(y = bill_length_mm, x = 1, fill = NULL, color = NULL)) +
  geom_rain(cov = NULL, alpha = .5) + theme_classic()

# # Only variable, colorAnyway
# ggplot(data = simplePenguins, aes(y = bill_length_mm, x = 1, fill = NULL, color = NULL)) +
#   geom_rain(alpha = .5, cov = NULL, fill = "green", color = NA) + theme_classic()

# Axis
ggplot(data = simplePenguins, aes(y = bill_length_mm, x = island, fill = NULL, color = NULL)) +
  geom_rain(alpha = .5, cov = NULL,) + theme_classic()

# Axis, colorAnyway
ggplot(data = simplePenguins, aes(y = bill_length_mm, x = island, fill = island, color = island)) +
  geom_rain(alpha = .5, cov = NULL) + theme_classic()

# Fill
ggplot(data = simplePenguins, aes(y = bill_length_mm, x = 1, fill = island, color = island)) +
  geom_rain(alpha = .5, cov = NULL) + theme_classic()

# Axis, Fill
ggplot(data = simplePenguins, aes(y = bill_length_mm, x = island, fill = species, color = species)) +
  geom_rain(alpha = .5, cov = NULL) + theme_classic()

# ---

# covariate
ggplot(data = simplePenguins, aes(y = bill_length_mm, x = 1, fill = NULL, color = NULL)) +
  geom_rain(alpha = .5, cov = "flipper_length_mm") + theme_classic()

# covariate + axis
ggplot(data = simplePenguins, aes(y = bill_length_mm, x = island, fill = NULL, color = NULL)) +
  geom_rain(alpha = .5, cov = "flipper_length_mm") + theme_classic()

# # covariate + axis, coloredAnyway is probably like only variable colorAnyway not possible? see above?
#
#

# 6 covariate + axis + fill
ggplot(data = simplePenguins, aes(y = bill_length_mm, x = island, fill = species, color = NULL)) +
  geom_rain(alpha = .5, cov = "flipper_length_mm") + theme_classic()

# switch to penguins
ggplot(data = palmerpenguins::penguins, aes(y = bill_length_mm, x = island, fill = species, color = NULL)) +
  geom_rain(alpha = .5, cov = "flipper_length_mm") + theme_classic()


# ---

ggplot(data = palmerpenguins::penguins, aes(y = bill_length_mm, x = island, fill = species, color = species)) +
  geom_rain(alpha = .5, cov = NULL) + theme_classic()

ggplot(data = palmerpenguins::penguins, aes(y = bill_length_mm, x = island, fill = species, color = NULL)) +
  geom_rain(alpha = .5, cov = "flipper_length_mm") + theme_classic()

ggplot(data = palmerpenguins::penguins, aes(y = bill_length_mm, x = island, fill = species, color = NULL)) +
  geom_rain(alpha = .5, cov = "flipper_length_mm", violin.args = list(color = "blue")) + theme_classic()







library(ggplot2)
library(ggrain)
library(palmerpenguins)

simplePenguins <- penguins[complete.cases(penguins), ]
# simplePenguins <- subset(simplePenguins, year < 2009)
# simplePenguins <- subset(simplePenguins, species != "Chinstrap")
simplePenguins$year <- as.factor(simplePenguins$year)

ggplot(
  data = simplePenguins,
  aes(
    y = bill_length_mm,  # Dependent variable
    x = species, #simplePenguins$year,
    fill = species, #simplePenguins$species
    color = species
  )
) + geom_rain(
  rain.side = NULL,
  alpha = .5,
) + theme_classic()

# ggplot(iris.long[iris.long$time %in% c('t1', 't2'),], aes(time, Sepal.Width, fill = Species)) +
#   geom_rain(alpha = .5) +
#   theme_classic() +
#   scale_fill_manual(values=c("dodgerblue", "darkorange")) +
#   guides(fill = 'none', color = 'none')


library(ggplot2)
library(ggrain)

simplePenguins <- penguins[complete.cases(penguins), ]
simplePenguins <- subset(simplePenguins, year < 2009)
simplePenguins$bill_depth_mm <- as.factor(simplePenguins$bill_depth_mm)

ggplot(
  simplePenguins,
  aes(
    y = bill_length_mm,  # Dependent variable
    x = species,
    fill = NULL
  )
) + geom_rain(
  rain.side = NULL,
  alpha = .5,
  cov = "bill_depth_mm"
) + theme_classic()

# ggplot(iris.long[iris.long$time %in% c('t1', 't2'),], aes(time, Sepal.Width, fill = Species)) +
#   geom_rain(alpha = .5) +
#   theme_classic() +
#   scale_fill_manual(values=c("dodgerblue", "darkorange")) +
#   guides(fill = 'none', color = 'none')

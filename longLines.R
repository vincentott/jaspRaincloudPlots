
library(ggplot2)
library(ggrain)

# Larks & Owls - JASP dataset for Generalized Linear Mixed Models
larksOwls <- read.csv("jaspLarksOwls.csv")
larksOwls <- subset(larksOwls, Chronotype != "Intermediate")
larksOwls$TimeOfDay <- factor(larksOwls$TimeOfDay, levels = c("Morning", "Evening"))  # re-order for better understanding
larksOwls$Chronotype <- factor(larksOwls$Chronotype, levels = c("Morning", "Evening"))


# Axis only ----
longPlot <- ggplot(data = larksOwls, aes(y = MWCount, x = TimeOfDay, fill = TimeOfDay, color = TimeOfDay)) +
  geom_rain(alpha = .5, cov = NULL, rain.side = "f1x1",
  ) + theme_classic()
longPlot
# Axis only + lines ----
longPlot <- ggplot(data = larksOwls, aes(y = MWCount, x = TimeOfDay, fill = TimeOfDay, color = TimeOfDay)) +
  geom_rain(alpha = .5, cov = NULL, id.long.var = "Subject", rain.side = "r",
            line.args = list(color = "black", alpha = 0.25)
  ) + theme_classic()
longPlot

# Two factors ----
longPlot <- ggplot(data = larksOwls, aes(y = MWCount, x = TimeOfDay, fill = Chronotype, color = Chronotype)) +
  geom_rain(alpha = .5, cov = NULL, rain.side = "r") + theme_classic()
longPlot
# Two factors + lines ----
longPlot <- ggplot(data = larksOwls, aes(y = MWCount, x = TimeOfDay, fill = Chronotype, color = Chronotype)) +
  geom_rain(alpha = .5, cov = NULL, id.long.var = "Subject", rain.side = "f2x2") + theme_classic()
longPlot



# # # Means ----
# Means: two factors
longPlot <- ggplot(data = larksOwls, aes(y = MWCount, x = TimeOfDay, fill = TimeOfDay, color = TimeOfDay)) +
  geom_rain(alpha = .5, cov = NULL, rain.side = "f1x1") + theme_classic() +
  stat_summary(
    fun = mean, geom = "line",  aes(group = TimeOfDay, color = TimeOfDay),
    position=position_nudge(x = c(0.1, -0.1, 0.1, -0.1), y = 0)
  ) +
  stat_summary(
    fun = mean, geom = "point", aes(group = TimeOfDay, color = TimeOfDay),
    position=position_nudge(x = c(0.1, -0.1, 0.1, -0.1), y = 0)
  )
longPlot


# Means: two factors
longPlot <- ggplot(data = larksOwls, aes(y = MWCount, x = TimeOfDay, fill = Chronotype, color = Chronotype)) +
  geom_rain(alpha = .5, cov = NULL, rain.side = "f2x2") + theme_classic() +
  stat_summary(
    fun = mean, geom = "line",  aes(group = Chronotype, color = Chronotype),
    position=position_nudge(x = c(0.1, -0.1, 0.1, -0.1), y = 0)
  ) +
  stat_summary(
    fun = mean, geom = "point", aes(group = Chronotype, color = Chronotype),
    position=position_nudge(x = c(0.1, -0.1, 0.1, -0.1), y = 0)
  )
longPlot
# For order in position_nudge vector
# TimeOfDay: Morning; Chronotype: Morning
# TimeOfDay: Evening; Chronotype: Morning
# TimeOfDay: Morning; Chronotype: Evening
# TimeOfDay: Evening; Chronotype: Evening


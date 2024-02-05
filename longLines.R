
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



# ChatGPT ----
# Assuming df is your dataframe with factors Factor1 and Factor2
df <- data.frame(
  Factor1 = factor(c("Morning", "Evening", "Morning", "Evening")),
  Factor2 = factor(c("Morning", "Morning", "Evening", "Evening")),
  EX = c(10, 15, 20, 25)
)

# Create a combined factor using interaction
combined_factor <- interaction(df$Factor1, df$Factor2, drop = FALSE)

# Count the unique combinations
num_combinations <- length(levels(combined_factor))

# Print the result
print(num_combinations)


# My attempt ----

smallLarksOwls <- larksOwls[ , c("TimeOfDay", "Chronotype")]
levels(smallLarksOwls$TimeOfDay)
levels(smallLarksOwls$Chronotype)

# -> this works, now we check out the two combinations of penguins



# GPT ----

# Example dataframe with two factors
df <- data.frame(
  Factor1 = factor(c("A", "A", "B", "B")),
  Factor2 = factor(c("X", "Y", "X", "Z"))
)

# Levels for each factor
levels_Factor1 <- levels(df$Factor1)
levels_Factor2 <- levels(df$Factor2)

# Generate all possible combinations
all_combinations <- expand.grid(Factor1 = levels_Factor1, Factor2 = levels_Factor2)

# Find common combinations
common_combinations <- merge(all_combinations, df, by = c("Factor1", "Factor2"))

# Print result
print(common_combinations)

# Reproduce for penguins
library(palmerpenguins)
data(package = "palmerpenguins")

levels(penguins$island)
levels(penguins$species)

allCombs <- expand.grid(factorAxis = levels(penguins$island), factorFill = levels(penguins$species))
presentCombs <- merge(allCombs, penguins, by = c("factorAxis", "factorFill"))
presentCombs



library(palmerpenguins)

# Subset with only factorAxis & factorFill
df <- penguins[c("island", "species")]
df$factorAxis <- df$island
df$factorFill <- as.factor(rep("none", nrow(df)))
df <- df[c("factorAxis", "factorFill")]

# Calculate present factor combinations
allCombs <- expand.grid(factorAxis = levels(df$factorAxis), factorFill = levels(df$factorFill))
presentCombs <- merge(allCombs, df, by = c("factorAxis", "factorFill"))
presentCombs <- unique(presentCombs)

# Print result
print(presentCombs)
print(nrow(presentCombs))



for (i in 1:5) print(i)


myVector <- c(1:5)
myVector[2] * -1
myVector

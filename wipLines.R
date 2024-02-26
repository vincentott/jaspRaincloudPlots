

# meanLines with two factors ----

# Load required libraries
library(ggplot2)

# Sample data generation (replace this with your actual data)
set.seed(123)
data <- expand.grid(
  Condition = factor(rep(c("Experimental", "Control"), each = 3)),
  Measurement = factor(rep(1:3, 2))
)
data$Value <- rnorm(6, mean = rep(c(5, 7), each = 3))

# Removing the combination of "Control" and measurement point 3
data <- data[!(data$Condition == "Control" & data$Measurement == 3), ]

# Plotting with stat_summary()
ggplot(data, aes(x = Measurement, y = Value, color = Condition)) +
  stat_summary(fun.data = mean_cl_normal, geom = "point", size = 3) +
  stat_summary(fun.y = mean, geom = "line", size = 1, aes(group = Condition), color = "black") +  # Add line connecting means
  labs(x = "Measurement Point", y = "Mean Value", color = "Condition") +
  ggtitle("Means for Each Factor Combination") +
  theme_minimal()



# Whiskers fix -----------

library(ggplot2)
library(palmerpenguins)

myPlot <- ggplot(
  data = na.omit(penguins),
  aes(
    y = bill_length_mm,
    x = island,
    fill = species,
    color = species
    )
  ) +
  geom_boxplot(alpha = .5, width = 1)
ggplot_build(myPlot)$data[[1]]  #ymin & ymax are ends of whiskers
myPlot
lowerEnds <- ggplot_build(myPlot)$data[[1]]$ymin
upperEnds <- ggplot_build(myPlot)$data[[1]]$ymax

lowerWhiskers <- stat_summary(
  fun.y = median, geom = "errorbar",
  width = 1, linetype = "solid",
  aes(ymin = ..y.. - (..y.. - lowerEnds), ymax = ..y.. - (..y.. - lowerEnds))
)
upperWhiskers <- stat_summary(
  fun.y = median, geom = "errorbar",
  width = 1, linetype = "solid",
  aes(ymin = ..y.. + abs(..y.. - upperEnds), ymax = ..y.. + abs(..y.. - upperEnds))
)
myPlot + lowerWhiskers + upperWhiskers

# the above should do the trick! --------




myPlot + stat_summary(
  fun.y = median, geom = "errorbar",
  width = 1, linetype = "solid",
  aes(ymin = ..y.., ymax = ..y..)
)
# https://stackoverflow.com/questions/50882335/add-group-mean-line-to-barplot-with-ggplot2

#myPlot + geom_hline(yintercept = )






# StackOverflow: https://stackoverflow.com/questions/27585776/error-bars-for-barplot-only-in-one-direction
df <- data.frame(trt = factor(c(1, 1, 2, 2)), resp = c(1, 5, 3, 4),
                 group = factor(c(1, 2, 1, 2)), se = c(0.1, 0.3, 0.3, 0.2))
df2 <- df[c(1,3), ]

limits <- aes(ymax = resp + se, ymin = resp - se)
dodge <- position_dodge(width = 0.9)

p <- ggplot(df, aes(fill = group, y = resp, x = trt))
p + geom_bar(position = dodge, stat = "identity") +
  geom_errorbar(limits, position = dodge, width = 0.25) +
  geom_linerange(aes(ymin = resp, ymax = resp + se*5))




# https://stackoverflow.com/questions/50882335/add-group-mean-line-to-barplot-with-ggplot2
library(tidyverse)

df = data.frame(
  x = 1:10,
  y = runif(10),
  class = sample(c("a","b"),10, replace=T) %>% factor()
) %>%
  mutate(x = factor(x, levels=x[order(class, -y)]))

ggplot(df, aes(x, y, fill=class)) +
  geom_col() +
  stat_summary(fun.y = mean, geom = "errorbar",
               aes(ymax = ..y.., ymin = ..y.., group = class),
               width = 1, linetype = "solid")




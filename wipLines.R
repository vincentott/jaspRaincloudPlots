

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

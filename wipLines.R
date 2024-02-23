

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


# Whiskers ----

set.seed(42)
df <- data.frame(
  cond = factor(rep(c("A"), each = 500)),
  value = c(
    rnorm(500, mean = 1, sd = 0.2),
    rnorm(500, mean = 1.5, sd = 0.1)
  )
)

ggplot(df, aes(x = cond, y = value)) + geom_boxplot(outlier.shape = NA, fatten = NULL, color = "white", coef = 0)

plot <- ggplot(df, aes(1, x = cond, fill = cond, y = value)) +
  stat_boxplot(geom = "errorbar", width = 0.15) +
  geom_boxplot(
    outlier.shape = NA, fatten = NULL, color = "white", fill = "white", coef = 0, width = 0.01,
  )
plot + geom_rain(alpha = 0.5, point.args = list(alpha = 0)) + theme_classic() +
  scale_fill_brewer(palette = 'Dark2')





# Create sample data
set.seed(123)
data <- data.frame(
  category = rep(LETTERS[1:3], each = 50),
  value = rnorm(150)
)

# Plot with different fill and color for geom_boxplot
ggplot(data, aes(x = category, y = value)) +
  geom_boxplot(fill = "skyblue", color = "blue") +  # Custom fill and color for boxplot
  geom_point() +  # Example of another geom
  geom_line(stat = "summary", fun = "median", aes(group = 1), color = "red") +  # Another example geom
  theme_minimal()  # Optional theme








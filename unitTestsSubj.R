
# JASP Dataset: Larks and Owls ----
larksOwls <- read.csv("jaspLarksOwls.csv")
larksOwls <- subset(larksOwls, Chronotype != "Intermediate")
larksOwls$TimeOfDay <- factor(larksOwls$TimeOfDay, levels = c("Morning", "Evening"))  # Re-order for comprehension
larksOwls$Chronotype <- factor(larksOwls$Chronotype, levels = c("Morning", "Evening"))



# 2x2 ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "MWCount"
options$factorAxis <- "TimeOfDay"
options$factorFill <- "Chronotype"
options$paletteFill <- "colorblind"
options$subject <- "Subject"
options$customSides <- "LLRR"
results <- jaspTools::runAnalysis("raincloudPlots", larksOwls, options)



# irisLong ----
# from the ggrain vignette: https://www.njudd.com/raincloud-ggrain/

set.seed(42)  # The magic number
iris_subset <- iris[iris$Species %in% c('versicolor', 'virginica'),]

iris.long <- cbind(
  rbind(iris_subset, iris_subset, iris_subset),
  data.frame(
    time = c(rep("t1", dim(iris_subset)[1]), rep("t2", dim(iris_subset)[1]), rep("t3", dim(iris_subset)[1])),
    id = c(rep(1:dim(iris_subset)[1]), rep(1:dim(iris_subset)[1]), rep(1:dim(iris_subset)[1]))
  )
)

# adding .5 and some noise to the versicolor species in t2
iris.long$Sepal.Width[iris.long$Species == 'versicolor' & iris.long$time == "t2"] <-
  iris.long$Sepal.Width[iris.long$Species == 'versicolor' & iris.long$time == "t2"] +
  .5 +
  rnorm(length(iris.long$Sepal.Width[iris.long$Species == 'versicolor' & iris.long$time == "t2"]), sd = .2)

# adding .8 and some noise to the versicolor species in t3
iris.long$Sepal.Width[iris.long$Species == 'versicolor' & iris.long$time == "t3"] <-
  iris.long$Sepal.Width[iris.long$Species == 'versicolor' & iris.long$time == "t3"] +
  .8 +
  rnorm(length(iris.long$Sepal.Width[iris.long$Species == 'versicolor' & iris.long$time == "t3"]), sd = .2)

# now we subtract -.2 and some noise to the virginica species
iris.long$Sepal.Width[iris.long$Species == 'virginica' & iris.long$time == "t2"] <-
  iris.long$Sepal.Width[iris.long$Species == 'virginica' & iris.long$time == "t2"] -
  .2 +
  rnorm(length(iris.long$Sepal.Width[iris.long$Species == 'virginica' & iris.long$time == "t2"]), sd = .2)

# now we subtract -.4 and some noise to the virginica species
iris.long$Sepal.Width[iris.long$Species == 'virginica' & iris.long$time == "t3"] <-
  iris.long$Sepal.Width[iris.long$Species == 'virginica' & iris.long$time == "t3"] -
  .4 +
  rnorm(length(iris.long$Sepal.Width[iris.long$Species == 'virginica' & iris.long$time == "t3"]), sd = .2)

iris.long$Sepal.Width <- round(iris.long$Sepal.Width, 1) # rounding Sepal.Width so t2 data is on the same resolution
iris.long$time <- factor(iris.long$time, levels = c('t1', 't2', 't3'))

irisLong <- iris.long



# Three time points and covariate ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "Sepal.Width"
options$factorAxis <- "time"
options$factorFill <- "Species"
options$paletteFill <- "ggplot2"
options$subject <- "id"
options$customSides <- "LLLRRR"
results <- jaspTools::runAnalysis("raincloudPlots", irisLong, options)



# Three time points and covariate and yJitter ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "Sepal.Width"
options$factorAxis <- "time"
options$factorFill <- "Species"
options$paletteFill <- "ggplot2"
options$subject <- "id"
options$customSides <- "LLLRRR"
options$yJitter <- TRUE
results <- jaspTools::runAnalysis("raincloudPlots", irisLong, options)


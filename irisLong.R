
# irisLong from the ggrain vignette

set.seed(42) # the magic number

iris_subset <- iris[iris$Species %in% c('versicolor', 'virginica'),]

iris.long <- cbind(rbind(iris_subset, iris_subset, iris_subset),
                   data.frame(time = c(rep("t1", dim(iris_subset)[1]), rep("t2", dim(iris_subset)[1]), rep("t3", dim(iris_subset)[1])),
                              id = c(rep(1:dim(iris_subset)[1]), rep(1:dim(iris_subset)[1]), rep(1:dim(iris_subset)[1]))))

# adding .5 and some noise to the versicolor species in t2
iris.long$Sepal.Width[iris.long$Species == 'versicolor' & iris.long$time == "t2"] <- iris.long$Sepal.Width[iris.long$Species == 'versicolor' & iris.long$time == "t2"] + .5 + rnorm(length(iris.long$Sepal.Width[iris.long$Species == 'versicolor' & iris.long$time == "t2"]), sd = .2)
# adding .8 and some noise to the versicolor species in t3
iris.long$Sepal.Width[iris.long$Species == 'versicolor' & iris.long$time == "t3"] <- iris.long$Sepal.Width[iris.long$Species == 'versicolor' & iris.long$time == "t3"] + .8 + rnorm(length(iris.long$Sepal.Width[iris.long$Species == 'versicolor' & iris.long$time == "t3"]), sd = .2)

# now we subtract -.2 and some noise to the virginica species
iris.long$Sepal.Width[iris.long$Species == 'virginica' & iris.long$time == "t2"] <- iris.long$Sepal.Width[iris.long$Species == 'virginica' & iris.long$time == "t2"] - .2 + rnorm(length(iris.long$Sepal.Width[iris.long$Species == 'virginica' & iris.long$time == "t2"]), sd = .2)

# now we subtract -.4 and some noise to the virginica species
iris.long$Sepal.Width[iris.long$Species == 'virginica' & iris.long$time == "t3"] <- iris.long$Sepal.Width[iris.long$Species == 'virginica' & iris.long$time == "t3"] - .4 + rnorm(length(iris.long$Sepal.Width[iris.long$Species == 'virginica' & iris.long$time == "t3"]), sd = .2)

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
options$customSides <- TRUE
options$sidesInput <- "LLLRRR"
# debugonce(jaspRaincloudPlots:::.rainReadData)
results <- jaspTools::runAnalysis("raincloudPlots", irisLong, options)


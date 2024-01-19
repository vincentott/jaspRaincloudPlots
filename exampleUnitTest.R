
# No Factor ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "Sepal.Width"
options$paletteFill <- "colorblind"
options$horizontal <- FALSE
results <- jaspTools::runAnalysis("raincloudPlots", "iris.csv", options)

# Factor ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "Sepal.Width"
options$factor <- "Species"
options$paletteFill <- "colorblind"
results <- jaspTools::runAnalysis("raincloudPlots", "iris.csv", options)

# Factor and Covariate ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "Sepal.Width"
options$factor <- "Species"
options$paletteFill <- "colorblind"
options$horizontal <- FALSE
options$covariate <- "Sepal.Length"
results <- jaspTools::runAnalysis("raincloudPlots", "iris.csv", options)

# Storage ----
# debugonce(jaspRaincloudPlots:::.rainReadData)
# results <- jaspTools::runAnalysis("raincloudPlots", "debug.csv", options)
# results[["state"]][["figures"]][[1]][["obj"]]

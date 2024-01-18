
# No Split ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "Sepal.Width"
options$colorPalette <- "colorblind"
options$simplePlots <- TRUE
options$horizontal <- FALSE
results <- jaspTools::runAnalysis("raincloudPlots", "iris.csv", options)

# Split ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "Sepal.Width"
options$splitBy <- "Species"
options$colorPalette <- "colorblind"
options$simplePlots <- TRUE
options$horizontal <- FALSE
results <- jaspTools::runAnalysis("raincloudPlots", "iris.csv", options)

# Split and Covariate ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "Sepal.Width"
options$splitBy <- "Species"
options$colorPalette <- "colorblind"
options$simplePlots <- TRUE
options$horizontal <- FALSE
options$covariate <- "Sepal.Length"
results <- jaspTools::runAnalysis("raincloudPlots", "iris.csv", options)

# Storage ----
# debugonce(jaspRaincloudPlots:::.rainReadData)
# results <- jaspTools::runAnalysis("raincloudPlots", "debug.csv", options)
# results[["state"]][["figures"]][[1]][["obj"]]

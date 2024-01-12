
options <- jaspTools::analysisOptions("raincloudPlots")
options$myCheckbox <- TRUE
# options$variables <- "contNormal"
results <- jaspTools::runAnalysis("raincloudPlots", "debug.csv", options)

results[["state"]][["figures"]][[1]][["obj"]]

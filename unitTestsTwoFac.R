
# No Factors + color ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$colorPalette <- "colorblind"
options$colorAnyway <- TRUE
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# No Factors NO color ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# primaryFactor + color ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$primaryFactor <- "island"
options$colorPalette <- "sportsTeamsNBA"
options$colorAnyway <- TRUE
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# primaryFactor NO color ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$primaryFactor <- "island"
options$colorPalette <- "colorblind"
options$colorAnyway <- FALSE
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# secondaryFactor + horizontal ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$secondaryFactor <- "species"
options$colorPalette <- "ggplot2"
options$horizontal <- TRUE
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# Two factors ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$primaryFactor <- "island"
options$secondaryFactor <- "species"
options$colorPalette <- "viridis"
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# Two factors + Continuous covariate ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$primaryFactor <- "island"
options$secondaryFactor <- "species"
options$covariate <- "bill_depth_mm"
options$colorPalette <- "grandBudapest"
options$covariatePalette <- "viridis"
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# Two factors + Discrete covariate ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$primaryFactor <- "island"
options$secondaryFactor <- "species"
options$covariate <- "sex"
options$colorPalette <- "grandBudapest"
options$covariatePalette <- "viridis"
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# Jitter is reproducible ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "flipper_length_mm"
options$primaryFactor <- "species"
options$jitter <- TRUE
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# Custom orientation ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$primaryFactor <- "species"
options$secondaryFactor <- "sex"
options$colorPalette <- "ggplot2"
options$customSides <- "LRLRLR"
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# Invalid input: Custom orientation ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$primaryFactor <- "species"
options$secondaryFactor <- "sex"
options$colorPalette <- "ggplot2"
options$customSides <- "LRLRL"
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# Means ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$primaryFactor <- "island"
options$secondaryFactor <- "species"
options$colorPalette <- "grandBudapest"
options$means <- TRUE
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# Means + Lines NO color ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$primaryFactor <- "island"
options$colorAnyway <- FALSE
options$means <- TRUE
options$meanLines <- TRUE
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# customAxisLimits ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$colorAnyway <- FALSE
options$customAxisLimits <- TRUE
options$lowerAxisLimit <- -10
options$upperAxisLimit <- 65
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)


# Warning customAxisLimits ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$colorAnyway <- FALSE
options$customAxisLimits <- TRUE
options$lowerAxisLimit <- 0
options$upperAxisLimit <- 50
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)



# Storage ----
# debugonce(jaspRaincloudPlots:::.rainReadData)
# results <- jaspTools::runAnalysis("raincloudPlots", "debug.csv", options)
# results[["state"]][["figures"]][[1]][["obj"]]

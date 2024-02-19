
# No Factors + color ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$paletteFill <- "colorblind"
options$colorAnyway <- TRUE
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# No Factors NO color ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)


# factorAxis + color ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$factorAxis <- "island"
options$paletteFill <- "sportsTeamsNBA"
options$colorAnyway <- TRUE
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# factorAxis NO color ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$factorAxis <- "island"
options$paletteFill <- "colorblind"
options$colorAnyway <- FALSE
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# factorFill + horizontal ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$factorFill <- "species"
options$paletteFill <- "ggplot2"
options$horizontal <- TRUE
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# Two factors ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$factorAxis <- "island"
options$factorFill <- "species"
options$paletteFill <- "viridis"
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# Two factors + Continuous covariate ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$factorAxis <- "island"
options$factorFill <- "species"
options$covariate <- "bill_depth_mm"
options$paletteFill <- "grandBudapest"
options$palettePoints <- "viridis"
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)


# Two factors + Discrete covariate ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$factorAxis <- "island"
options$factorFill <- "species"
options$covariate <- "sex"
options$paletteFill <- "grandBudapest"
options$palettePoints <- "viridis"
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)


# yJitter is reproducible ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "flipper_length_mm"
options$factorAxis <- "species"
options$yJitter <- TRUE
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)


# Custom orientation ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$factorAxis <- "species"
options$factorFill <- "sex"
options$paletteFill <- "ggplot2"
options$customSides <- "LRLRLR"
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)


# Invalid input: Custom orientation ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$factorAxis <- "species"
options$factorFill <- "sex"
options$paletteFill <- "ggplot2"
options$customSides <- "LRLRL"
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)



# Storage ----
# debugonce(jaspRaincloudPlots:::.rainReadData)
# results <- jaspTools::runAnalysis("raincloudPlots", "debug.csv", options)
# results[["state"]][["figures"]][[1]][["obj"]]

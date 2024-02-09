
# No Factors + color ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$paletteFill <- "colorblind"
options$colorAnyway <- TRUE
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

# Two factors + covariate ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$factorAxis <- "island"
options$factorFill <- "species"
options$covariate <- "bill_depth_mm"
options$paletteFill <- "grandBudapest"
options$palettePoints <- "colorblind"
# debugonce(jaspRaincloudPlots:::.rainOutlineColor)
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# Custom Sides ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "body_mass_g"
options$factorAxis <- "species"
# options$factorFill <- "sex"  # THIS HERE DOES NOT WORK
options$paletteFill <- "ggplot2"
# options$customSides <- TRUE
# options$sidesInput <- "LRLRLR"
# debugonce(jaspRaincloudPlots:::.rainFillPlot)
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)


# Storage ----
# debugonce(jaspRaincloudPlots:::.rainReadData)
# results <- jaspTools::runAnalysis("raincloudPlots", "debug.csv", options)
# results[["state"]][["figures"]][[1]][["obj"]]

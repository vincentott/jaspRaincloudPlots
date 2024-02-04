
library(palmerpenguins)
data(package = "palmerpenguins")


# No Factors + color ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$paletteFill <- "colorblind"
options$colorAnyway <- TRUE
# debugonce(jaspRaincloudPlots:::.rainFillPlot)
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# factorAxis + color ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$factorAxis <- "island"
options$paletteFill <- "sportsTeamsNBA"
options$colorAnyway <- TRUE
results <- jaspTools::runAnalysis("raincloudPlots", penguins, options)

# factorAxis NO color ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$factorAxis <- "island"
options$paletteFill <- "colorblind"
options$colorAnyway <- FALSE
results <- jaspTools::runAnalysis("raincloudPlots", penguins, options)

# factorFill + horizontal ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$factorFill <- "species"
options$paletteFill <- "ggplot2"
options$colorAnyway <- FALSE  # colorAnyway must be disabled in this case; done in .qml file
options$horizontal <- TRUE
results <- jaspTools::runAnalysis("raincloudPlots", penguins, options)

# Two factors ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$factorAxis <- "island"
options$factorFill <- "species"
options$paletteFill <- "viridis"
options$colorAnyway <- FALSE  # colorAnyway must be disabled in this case; done in .qml file
# debugonce(jaspRaincloudPlots:::.rainFillPlot)
results <- jaspTools::runAnalysis("raincloudPlots", penguins, options)

# Two factors + covariate ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$factorAxis <- "island"
options$factorFill <- "species"
options$covariate <- "bill_depth_mm"
options$paletteFill <- "grandBudapest"
options$palettePoints <- "viridis"
options$colorAnyway <- FALSE  # colorAnyway must be disabled in this case; done in .qml file
results <- jaspTools::runAnalysis("raincloudPlots", penguins, options)

# Custom Sides ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$factorAxis <- "species"
options$paletteFill <- "colorblind"
options$colorAnyway <- TRUE
options$customSides <- TRUE
options$sidesInput <- "LRR"
# debugonce(jaspRaincloudPlots:::.rainReadData)
results <- jaspTools::runAnalysis("raincloudPlots", penguins, options)



# Storage ----
# debugonce(jaspRaincloudPlots:::.rainReadData)
# results <- jaspTools::runAnalysis("raincloudPlots", "debug.csv", options)
# results[["state"]][["figures"]][[1]][["obj"]]

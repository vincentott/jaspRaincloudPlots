
# No Factors + color ----
options <- jaspTools::analysisOptions("defaultsUnitTests.jasp")
options$dependentVariables <- "bill_length_mm"
options$table <- TRUE
# debugonce(jaspRaincloudPlots:::.rainFillTable)
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# No Factors NO color ----
options <- jaspTools::analysisOptions("defaultsUnitTests.jasp")
options$dependentVariables <- "bill_length_mm"
options$colorAnyway <- FALSE
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# primaryFactor + color ----
options <- jaspTools::analysisOptions("defaultsUnitTests.jasp")
options$dependentVariables <- "bill_length_mm"
options$primaryFactor <- "island"
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# primaryFactor NO color ----
options <- jaspTools::analysisOptions("defaultsUnitTests.jasp")
options$dependentVariables <- "bill_length_mm"
options$primaryFactor <- "island"
options$colorAnyway <- FALSE
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# secondaryFactor + horizontal + colorPalette ----
options <- jaspTools::analysisOptions("defaultsUnitTests.jasp")
options$dependentVariables <- "bill_length_mm"
options$secondaryFactor <- "species"
options$colorPalette <- "ggplot2"
options$colorAnyway <- FALSE  # otherwise overwrites colorPalette
options$horizontal <- TRUE
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# Two factors version 1 with black boxOutline ----
options <- jaspTools::analysisOptions("defaultsUnitTests.jasp")
options$dependentVariables <- "bill_length_mm"
options$primaryFactor <- "island"
options$secondaryFactor <- "species"
options$colorAnyway <- FALSE
options$boxOutline <- "black"
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# Two factors version 2 ----
options <- jaspTools::analysisOptions("defaultsUnitTests.jasp")
options$dependentVariables <- "bill_length_mm"
options$primaryFactor <- "species"
options$secondaryFactor <- "island"
options$colorAnyway <- FALSE
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# Two factors + Continuous covariate ----
options <- jaspTools::analysisOptions("defaultsUnitTests.jasp")
options$dependentVariables <- "bill_length_mm"
options$primaryFactor <- "island"
options$secondaryFactor <- "species"
options$colorAnyway <- FALSE
options$covariate <- "bill_depth_mm"
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# Two factors + Discrete covariate ----
options <- jaspTools::analysisOptions("defaultsUnitTests.jasp")
options$dependentVariables <- "bill_length_mm"
options$primaryFactor <- "island"
options$secondaryFactor <- "species"
options$colorAnyway <- FALSE
options$covariate <- "sex"
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# Two factors + Discrete Covariate + Remove violin and box ----
options <- jaspTools::analysisOptions("defaultsUnitTests.jasp")
options$dependentVariables <- "bill_length_mm"
options$primaryFactor <- "island"
options$secondaryFactor <- "species"
options$colorAnyway <- FALSE
options$covariate <- "sex"
options$vioOpacity <- 0
options$vioOutline <- "none"
options$boxOpacity <- 0
options$boxOutline <- "none"
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# Jitter is reproducible ----
options <- jaspTools::analysisOptions("defaultsUnitTests.jasp")
options$dependentVariables <- "flipper_length_mm"
options$primaryFactor <- "species"
options$jitter <- TRUE
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# Custom orientation ----
options <- jaspTools::analysisOptions("defaultsUnitTests.jasp")
options$dependentVariables <- "bill_length_mm"
options$primaryFactor <- "species"
options$secondaryFactor <- "sex"
options$colorPalette <- "ggplot2"
options$colorAnyway <- FALSE
options$customSides <- "LRLRLR"
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# Invalid input: Custom orientation ----
options <- jaspTools::analysisOptions("defaultsUnitTests.jasp")
options$dependentVariables <- "bill_length_mm"
options$primaryFactor <- "species"
options$secondaryFactor <- "sex"
options$colorAnyway <- FALSE
options$customSides <- "LRLRL"
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# Means ----
options <- jaspTools::analysisOptions("defaultsUnitTests.jasp")
options$dependentVariables <- "bill_length_mm"
options$primaryFactor <- "year"
options$secondaryFactor <- "sex"
options$colorAnyway <- FALSE
options$colorPalette <- "ggplot2"
options$vioOpacity <- 0
options$vioOutline <- "none"
options$boxOpacity <- 0
options$boxOutline <- "none"
options$pointOpacity <- 0
options$mean <- TRUE
options$meanPosition <- "onAxisTicks"
options$meanLines <- TRUE
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# Means, only secondaryFactor ----
options <- jaspTools::analysisOptions("defaultsUnitTests.jasp")
options$dependentVariables <- "bill_length_mm"
options$primaryFactor <- "sex"
options$secondaryFactor <- "year"
options$colorAnyway <- FALSE
options$colorPalette <- "sportsTeamsNBA"
options$mean <- TRUE
options$meanLines <- TRUE
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# Means + Lines NO color ----
options <- jaspTools::analysisOptions("defaultsUnitTests.jasp")
options$dependentVariables <- "bill_length_mm"
options$primaryFactor <- "island"
options$colorAnyway <- FALSE
options$colorPalette <- "grandBudapest"
options$mean <- TRUE
options$meanLines <- TRUE
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# customAxisLimits ----
options <- jaspTools::analysisOptions("defaultsUnitTests.jasp")
options$dependentVariables <- "bill_length_mm"
options$colorAnyway <- FALSE
options$customAxisLimits <- TRUE
options$lowerAxisLimit <- -10
options$upperAxisLimit <- 65
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)

# Warning customAxisLimits ----
options <- jaspTools::analysisOptions("defaultsUnitTests.jasp")
options$dependentVariables <- "bill_length_mm"
options$colorAnyway <- FALSE
options$customAxisLimits <- TRUE
options$lowerAxisLimit <- 0
options$upperAxisLimit <- 50
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)


# # Table ----
options <- jaspTools::analysisOptions("defaultsUnitTests.jasp")
options$dependentVariables <- "bill_length_mm"
options$primaryFactor <- "sex"
options$secondaryFactor <- "year"
options$colorAnyway <- FALSE
options$colorPalette <- "sportsTeamsNBA"
options$mean <- TRUE
options$table <- TRUE
debugonce(jaspRaincloudPlots:::.rainFillTable)
results <- jaspTools::runAnalysis("raincloudPlots", palmerpenguins::penguins, options)




# Storage ----
# debugonce(jaspRaincloudPlots:::.rainReadData)
# results <- jaspTools::runAnalysis("raincloudPlots", "debug.csv", options)
# results[["state"]][["figures"]][[1]][["obj"]]

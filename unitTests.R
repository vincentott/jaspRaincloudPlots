#
# Copyright (C) 2013-2024 University of Amsterdam
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#



# 1: Primary factor without color; with table ----
options <- jaspTools::analysisOptions("rainDefaultOptionsUnitTest.jasp")
options$dependentVariables <- "bill_length_mm"
options$primaryFactor <- "island"
options$colorAnyway <- FALSE
options$table <- TRUE
options$vioOutlineWidth <- 1.5
options$boxOutlineWidth <- 1.5
options$pointNudge <- 0.19
options$pointSpread <- 0.1
options$pointSize <- 3
results <- jaspTools::runAnalysis("raincloudPlots", "palmerPenguins.csv", options)



# 2: Both factors; horizontal; custom axis limits ----
options <- jaspTools::analysisOptions("rainDefaultOptionsUnitTest.jasp")
options$dependentVariables <- "body_mass_g"
options$primaryFactor <- "species"
options$secondaryFactor <- "sex"
options$colorPalette <- "colorblind"
options$colorAnyway <- FALSE  # Otherwise overwrites colorPalette
options$horizontal <- TRUE
options$customAxisLimits <- TRUE
options$lowerAxisLimit <- 0
options$upperAxisLimit <- 6500
options$vioNudge <- 0.15
options$boxWidth <- 0.25
options$boxPadding <- 0.25
options$pointNudge <- 0.275
options$pointSpread <- 0.1
results <- jaspTools::runAnalysis("raincloudPlots", "palmerPenguins.csv", options)



# 3: Both factors; means; meanLines; confidence interval; table ----
options <- jaspTools::analysisOptions("rainDefaultOptionsUnitTest.jasp")
options$dependentVariables <- "bill_length_mm"
options$primaryFactor <- "species"
options$secondaryFactor <- "island"
options$colorPalette <- "ggplot2"
options$colorAnyway <- FALSE  # Otherwise overwrites colorPalette
options$table <- TRUE
options$tableBoxStatistics <- FALSE
options$vioNudge <- 0.20
options$boxOpacity <- 0
options$boxOutline <- "none"
options$pointNudge <- 0.25
options$pointOpacity <- 0.25
options$mean <- TRUE
options$meanSize <- 4.5
options$boxWidth <- 0.275  # Mirror of meanDistance
options$meanLines <- TRUE
options$meanInterval <- TRUE
options$meanIntervalOption <- "ci"
options$meanCiAssumption <- TRUE
options$meanCiWidth <- 0.99
options$meanCiMethod <- "bootstrap"
options$meanCiBootstrapSamples <- 1001
options$setSeed <- TRUE
options$seed <- 42
results <- jaspTools::runAnalysis("raincloudPlots", "palmerPenguins.csv", options)



# 4: Primary factor; continuous covariate ----
options <- jaspTools::analysisOptions("rainDefaultOptionsUnitTest.jasp")
options$dependentVariables <- "flipper_length_mm"
options$primaryFactor <- "species"
options$covariate <- "bill_depth_mm"
options$colorPalette <- "grandBudapest"
options$colorAnyway <- TRUE
options$covariatePalette <- "viridis"
options$vioOpacity <- 0.75
options$vioOutline <- "black"
options$boxOpacity <- 0.75
options$boxOutline <- "black"
options$pointOpacity <- 0.66
options$pointNudge <- 0.175
options$pointSize <- 1.5
results <- jaspTools::runAnalysis("raincloudPlots", "palmerPenguins.csv", options)



# 5: Secondary factor; discrete covariate; means ----
options <- jaspTools::analysisOptions("rainDefaultOptionsUnitTest.jasp")
options$dependentVariables <- "body_mass_g"
options$secondaryFactor <- "species"
options$covariate <- "sex"
options$colorPalette <- "colorblind"
options$colorAnyway <- FALSE  # Otherwise overwrites colorPalette
options$covariatePalette <- "colorblind3"
options$vioNudge <- 0.15
options$vioHeight <- 0.6
options$boxWidth <- 0.25
options$boxPadding <- 0.3
options$pointNudge <- 0.3
options$pointSpread <- 0.15
options$mean <- TRUE
df <- read.csv("palmerPenguins.csv")
df$sex <- as.factor(df$sex)
results <- jaspTools::runAnalysis("raincloudPlots", df, options)



# 6: ID over time ----
options <- jaspTools::analysisOptions("rainDefaultOptionsUnitTest.jasp")
options$dependentVariables <- "Sepal.Width"
options$primaryFactor <- "time"
options$secondaryFactor <- "Species"
options$observationId <- "id"
options$colorPalette <- "sportsTeamsNBA"
options$colorAnyway <- FALSE  # Otherwise overwrites colorPalette
options$vioNudge <- 0.30
options$vioHeight <- 0.40
options$boxNudge <- 0.18
options$boxWidth <- 0.2
options$boxPadding <- 0.3
options$jitter <- TRUE
options$observationIdLineOpacity <- 0.10
options$observationIdLineWidth <- 0.75
options$widthPlot <- 750
options$heightPlot <- 500
options$showCaption <- FALSE
options$numberOfClouds <- 6
options$customSides <- TRUE
options$customizationTable[[1]]$values <- c(rep("L", 3), rep("R", 3))
results <- jaspTools::runAnalysis("raincloudPlots", "irisFertilizer.csv", options)



# 7: Custom mean intervals ----
options <- jaspTools::analysisOptions("rainDefaultOptionsUnitTest.jasp")
options$dependentVariables <- "Sepal.Width"
options$primaryFactor <- "time"
options$secondaryFactor <- "Species"
options$colorPalette <- "colorblind"
options$colorAnyway <- FALSE
options$vioOpacity <- 0
options$vioOutline <- "none"
options$boxOpacity <- 0
options$boxOutline <- "none"
options$boxOutlineWidth <- 1.5  # Mirror of meanIntervalOutlineWidth
options$pointNudge <- 0
options$pointOpacity <- 0.25
options$mean <- TRUE
options$meanPosition <- "onAxis"
options$meanSize <- 7.5
options$meanLines <- TRUE
options$meanLinesOpacity <- 0.25
options$meanLinesWidth <- 2
options$numberOfClouds <- 6
options$meanIntervalCustom <- TRUE
options$customizationTable[[2]]$values <- c(2.60, 2.90, 3.00, 2.53, 3.33, 2.44)
options$customizationTable[[3]]$values <- c(2.85, 3.07, 3.45, 2.91, 3.86, 2.66)
results <- jaspTools::runAnalysis("raincloudPlots", "irisFertilizer.csv", options)



# 8: Flanking clouds and vioSmoothing ----
options <- jaspTools::analysisOptions("rainDefaultOptionsUnitTest.jasp")
options$dependentVariables <- "Sepal.Width"
options$primaryFactor <- "time"
options$secondaryFactor <- "Species"
options$observationId <- "id"
options$colorAnyway <- FALSE  # Otherwise overwrites colorPalette
options$vioNudge <- 0.225
options$vioHeight <- 0.6
options$vioSmoothing <- 0.33
options$vioOpacity <- 0.33
options$boxNudge <- 0.15
options$boxOpacity <- 0.25
options$pointOpacity <- 0.75
options$jitter <- TRUE
options$observationIdLineOpacity <- 0.15
options$numberOfClouds <- 4
options$customSides <- TRUE
options$customizationTable[[1]]$values <- c("L", "L", "R", "R")
df <- read.csv("irisFertilizer.csv")
df <- subset(df, time != "t2")  # Remove for 2x2 flanking design
results <- jaspTools::runAnalysis("raincloudPlots", df, options)



# Storage ----
# debugonce(jaspRaincloudPlots:::.rainReadData)
# results <- jaspTools::runAnalysis("raincloudPlots", "debug.csv", options)
# results[["state"]][["figures"]][[1]][["obj"]]

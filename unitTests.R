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



context("Raincloud Plots")



# 1: Primary factor without color; with table ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$boxNudge <- 0
options$boxOpacity <- 0.5
options$boxOutlineWidth <- 1.5
options$boxPadding <- 0.1
options$boxWidth <- 0.1
options$colorPalette <- "colorblind"
options$covariatePalette <- "viridis"
options$dependentVariables <- "bill_length_mm"
options$heightPlot <- 550
options$meanLines <- FALSE
options$pointNudge <- 0.19
options$pointOpacity <- 0.5
options$pointSize <- 3
options$pointSpread <- 0.1
options$primaryFactor <- "island"
options$showBox <- TRUE
options$table <- TRUE
options$vioNudge <- 0.09
options$vioOpacity <- 0.5
options$vioOutlineWidth <- 1.5
options$widthPlot <- 675
results <- jaspTools::runAnalysis("raincloudPlots", "palmerPenguins.csv", options)

test_that("plot with primary factor and no color matches", {
  plotName <- results[["results"]][["containerRaincloudPlots"]][["collection"]][["containerRaincloudPlots_bill_length_mm"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "rainPrimaryColorless")
})
test_that("table results match for a plot with primary factor", {
  table <- results[["results"]][["containerTables"]][["collection"]][["containerTables_bill_length_mm"]][["data"]]
  jaspTools::expect_equal_tables(table,
                                 list(42, 45.8, 167, "Biscoe", 48.7, 55.9, 34.5, 39.15, 44.65, 124,
                                      "Dream", 49.85, 58, 32.1, 36.65, 38.9, 51, "Torgersen", 41.1,
                                      46, 33.5))
})



# 2: Both factors; horizontal; custom axis limits ----
# options <- jaspTools::analysisOptions("rainDefaultOptionsUnitTest.jasp")
# options$dependentVariables <- "body_mass_g"
# options$primaryFactor <- "species"
# options$secondaryFactor <- "sex"
# options$colorPalette <- "colorblind"
# options$colorAnyway <- FALSE  # Otherwise overwrites colorPalette
# options$horizontal <- TRUE
# options$customAxisLimits <- TRUE
# options$lowerAxisLimit <- 0
# options$upperAxisLimit <- 6500
# options$vioNudge <- 0.15
# options$boxWidth <- 0.25
# options$boxPadding <- 0.25
# options$pointNudge <- 0.275
# options$pointSpread <- 0.1
# results <- jaspTools::runAnalysis("raincloudPlots", "palmerPenguins.csv", options, makeTests = TRUE)
# options <- analysisOptions("raincloudPlots")
# options$boxNudge <- 0
# options$boxOpacity <- 0.5
# options$boxPadding <- 0.25
# options$boxWidth <- 0.25
# options$colorPalette <- "colorblind"
# options$covariatePalette <- "viridis"
# options$customAxisLimits <- TRUE
# options$dependentVariables <- "body_mass_g"
# options$heightPlot <- 550
# options$horizontal <- TRUE
# options$meanLines <- FALSE
# options$pointNudge <- 0.275
# options$pointOpacity <- 0.5
# options$pointSpread <- 0.1
# options$primaryFactor <- "species"
# options$secondaryFactor <- "sex"
# options$showBox <- TRUE
# options$upperAxisLimit <- 6500
# options$vioNudge <- 0.15
# options$vioOpacity <- 0.5
# options$widthPlot <- 675
# results <- runAnalysis("raincloudPlots", "palmerPenguins.csv", options)
test_that("horizontal plot with both factors and custom axis limits matches", {
  options <- jaspTools::analysisOptions("raincloudPlots")
  options$.meta <- list(covariate = list(shouldEncode = TRUE), customizationTable = list(
    shouldEncode = TRUE), dependentVariables = list(shouldEncode = TRUE),
    observationId = list(shouldEncode = TRUE), primaryFactor = list(
      shouldEncode = TRUE), secondaryFactor = list(shouldEncode = TRUE))
  options$boxNudge <- 0
  options$boxOpacity <- 0.5
  options$boxPadding <- 0.25
  options$boxWidth <- 0.25
  options$colorPalette <- "colorblind"
  options$covariatePalette <- "viridis"
  options$customAxisLimits <- TRUE
  options$customizationTable <- list(list(levels = "species", name = "data 1", values = "R"),
                                     list(levels = "species", name = "data 2", values = 0), list(
                                       levels = "species", name = "data 3", values = 0))
  options$dependentVariables <- "body_mass_g"
  options$heightPlot <- 550
  options$horizontal <- TRUE
  options$meanLines <- FALSE
  options$pointNudge <- 0.275
  options$pointOpacity <- 0.5
  options$pointSpread <- 0.1
  options$primaryFactor <- "species"
  options$secondaryFactor <- "sex"
  options$showBox <- TRUE
  options$upperAxisLimit <- 6500
  options$vioNudge <- 0.15
  options$vioOpacity <- 0.5
  options$widthPlot <- 675
  set.seed(1)
  results <- jaspTools::runAnalysis("raincloudPlots", "palmerPenguins.csv", options)
  plotName <- results[["results"]][["containerRaincloudPlots"]][["collection"]][["containerRaincloudPlots_body_mass_g"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "rainHorizontalBothFactorsCustomAxisLimits")
})



# 3: Both factors; means; meanLines; confidence interval; table ----
# options <- jaspTools::analysisOptions("rainDefaultOptionsUnitTest.jasp")
# options$dependentVariables <- "bill_length_mm"
# options$primaryFactor <- "species"
# options$secondaryFactor <- "island"
# options$colorPalette <- "ggplot2"
# options$colorAnyway <- FALSE  # Otherwise overwrites colorPalette
# options$table <- TRUE
# options$tableBoxStatistics <- FALSE
# options$vioNudge <- 0.20
# options$boxOpacity <- 0
# options$boxOutline <- "none"
# options$pointNudge <- 0.25
# options$pointOpacity <- 0.25
# options$mean <- TRUE
# options$meanSize <- 4.5
# options$boxWidth <- 0.275  # Mirror of meanDistance
# options$meanLines <- TRUE
# options$meanInterval <- TRUE
# options$meanIntervalOption <- "ci"
# options$meanCiAssumption <- TRUE
# options$meanCiWidth <- 0.99
# options$meanCiMethod <- "bootstrap"
# options$meanCiBootstrapSamples <- 1001
# options$setSeed <- TRUE
# options$seed <- 42
# results <- jaspTools::runAnalysis("raincloudPlots", "palmerPenguins.csv", options)
options <- jaspTools::analysisOptions("raincloudPlots")
options$.meta <- list(covariate = list(shouldEncode = TRUE), customizationTable = list(
  shouldEncode = TRUE), dependentVariables = list(shouldEncode = TRUE),
  observationId = list(shouldEncode = TRUE), primaryFactor = list(
    shouldEncode = TRUE), secondaryFactor = list(shouldEncode = TRUE))
options$boxNudge <- 0
options$boxOutline <- "none"
options$boxPadding <- 0.1
options$boxWidth <- 0.275
options$colorPalette <- "ggplot2"
options$covariatePalette <- "viridis"
options$customizationTable <- list(list(levels = "species", name = "data 1", values = "R"),
                                   list(levels = "species", name = "data 2", values = 0), list(
                                     levels = "species", name = "data 3", values = 0))
options$dependentVariables <- "bill_length_mm"
options$heightPlot <- 550
options$mean <- TRUE
options$meanCiAssumption <- TRUE
options$meanCiBootstrapSamples <- 1001
options$meanCiMethod <- "bootstrap"
options$meanCiWidth <- 0.99
options$meanInterval <- TRUE
options$meanIntervalOption <- "ci"
options$meanSize <- 4.5
options$pointNudge <- 0.25
options$pointOpacity <- 0.25
options$primaryFactor <- "species"
options$secondaryFactor <- "island"
options$seed <- 42
options$setSeed <- TRUE
options$showBox <- TRUE
options$table <- TRUE
options$tableBoxStatistics <- FALSE
options$vioNudge <- 0.2
options$vioOpacity <- 0.5
options$widthPlot <- 675
set.seed(1)
results <- jaspTools::runAnalysis("raincloudPlots", "palmerPenguins.csv", options)

test_that("plot with both factors, no box, means, meanLines, and, bootstrapped ci matches", {
  plotName <- results[["results"]][["containerRaincloudPlots"]][["collection"]][["containerRaincloudPlots_bill_length_mm"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "rainBothFactorsBoxlessMeansMeanLinesBootstrappedCi")
})

test_that("table results match for a plot with both factors, no box, means, meanLines, and bootstrapped ci", {
  table <- results[["results"]][["containerTables"]][["collection"]][["containerTables_bill_length_mm"]][["data"]]
  jaspTools::expect_equal_tables(table,
                                 list(37.9772727272727, 38.975, 44, "Adelie", "Biscoe", 39.9204545454545,
                                      37.7125, 38.5017857142857, 56, "", "Dream", 39.3267857142857,
                                      37.9117647058824, 38.9509803921569, 51, "", "Torgersen", 40.021568627451,
                                      47.8, 48.8338235294118, 68, "Chinstrap", "Dream", 49.8808823529412,
                                      46.8463414634146, 47.5048780487805, 123, "Gentoo", "Biscoe",
                                      48.2170731707317))
})



# 4: Primary factor; continuous covariate ----
# options <- jaspTools::analysisOptions("rainDefaultOptionsUnitTest.jasp")
# options$dependentVariables <- "flipper_length_mm"
# options$primaryFactor <- "species"
# options$covariate <- "bill_depth_mm"
# options$colorPalette <- "grandBudapest"
# options$colorAnyway <- TRUE
# options$covariatePalette <- "viridis"
# options$vioOpacity <- 0.75
# options$vioOutline <- "black"
# options$boxOpacity <- 0.75
# options$boxOutline <- "black"
# options$pointOpacity <- 0.66
# options$pointNudge <- 0.175
# options$pointSize <- 1.5
# results <- jaspTools::runAnalysis("raincloudPlots", "palmerPenguins.csv", options)

test_that("plot with primary factor and continuous covariate matches", {
  options <- jaspTools::analysisOptions("raincloudPlots")
  options$.meta <- list(covariate = list(shouldEncode = TRUE), customizationTable = list(
    shouldEncode = TRUE), dependentVariables = list(shouldEncode = TRUE),
    observationId = list(shouldEncode = TRUE), primaryFactor = list(
      shouldEncode = TRUE), secondaryFactor = list(shouldEncode = TRUE))
  options$boxNudge <- 0
  options$boxOpacity <- 0.75
  options$boxOutline <- "black"
  options$boxPadding <- 0.1
  options$boxWidth <- 0.1
  options$colorAnyway <- TRUE
  options$colorPalette <- "grandBudapest"
  options$covariate <- "bill_depth_mm"
  options$covariatePalette <- "viridis"
  options$customizationTable <- list(list(levels = "species", name = "data 1", values = "R"),
                                     list(levels = "species", name = "data 2", values = 0), list(
                                       levels = "species", name = "data 3", values = 0))
  options$dependentVariables <- "flipper_length_mm"
  options$heightPlot <- 550
  options$meanLines <- FALSE
  options$pointNudge <- 0.175
  options$pointOpacity <- 0.66
  options$pointSize <- 1.5
  options$primaryFactor <- "species"
  options$showBox <- TRUE
  options$vioNudge <- 0.09
  options$vioOpacity <- 0.75
  options$vioOutline <- "black"
  options$widthPlot <- 675
  set.seed(1)
  results <- jaspTools::runAnalysis("raincloudPlots", "palmerPenguins.csv", options)
  plotName <- results[["results"]][["containerRaincloudPlots"]][["collection"]][["containerRaincloudPlots_flipper_length_mm"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "rainPrimaryCovariateContinuous")
})



# 5: Secondary factor; discrete covariate; means ----
# options <- jaspTools::analysisOptions("rainDefaultOptionsUnitTest.jasp")
# options$dependentVariables <- "body_mass_g"
# options$secondaryFactor <- "species"
# options$covariate <- "sex"
# options$colorPalette <- "colorblind"
# options$colorAnyway <- FALSE  # Otherwise overwrites colorPalette
# options$covariatePalette <- "colorblind3"
# options$vioNudge <- 0.15
# options$vioHeight <- 0.6
# options$boxWidth <- 0.25
# options$boxPadding <- 0.3
# options$pointNudge <- 0.3
# options$pointSpread <- 0.15
# options$mean <- TRUE
# df <- read.csv("palmerPenguins.csv")
# df$sex <- as.factor(df$sex)
# results <- jaspTools::runAnalysis("raincloudPlots", df, options)

test_that("plot with secondary factor, discrete covariate, and means matches", {
  options <- jaspTools::analysisOptions("raincloudPlots")
  options$.meta <- list(covariate = list(shouldEncode = TRUE), customizationTable = list(
    shouldEncode = TRUE), dependentVariables = list(shouldEncode = TRUE),
    observationId = list(shouldEncode = TRUE), primaryFactor = list(
      shouldEncode = TRUE), secondaryFactor = list(shouldEncode = TRUE))
  options$boxNudge <- 0
  options$boxOpacity <- 0.5
  options$boxPadding <- 0.3
  options$boxWidth <- 0.25
  options$colorPalette <- "colorblind"
  options$covariate <- "sex"
  options$covariatePalette <- "colorblind3"
  options$customizationTable <- list(list(levels = "species", name = "data 1", values = "R"),
                                     list(levels = "species", name = "data 2", values = 0), list(
                                       levels = "species", name = "data 3", values = 0))
  options$dependentVariables <- "body_mass_g"
  options$heightPlot <- 550
  options$mean <- TRUE
  options$meanLines <- FALSE
  options$pointNudge <- 0.3
  options$pointOpacity <- 0.5
  options$pointSpread <- 0.15
  options$secondaryFactor <- "species"
  options$showBox <- TRUE
  options$vioHeight <- 0.6
  options$vioNudge <- 0.15
  options$vioOpacity <- 0.5
  options$widthPlot <- 675
  set.seed(1)
  df <- read.csv("palmerPenguins.csv")
  df$sex <- as.factor(df$sex)
  results <- jaspTools::runAnalysis("raincloudPlots", df, options)
  plotName <- results[["results"]][["containerRaincloudPlots"]][["collection"]][["containerRaincloudPlots_body_mass_g"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "rainSecondaryCovariateDiscreteMean")
})



# 6: ID over time ----
# options <- jaspTools::analysisOptions("rainDefaultOptionsUnitTest.jasp")
# options$dependentVariables <- "Sepal.Width"
# options$primaryFactor <- "time"
# options$secondaryFactor <- "Species"
# options$observationId <- "id"
# options$colorPalette <- "sportsTeamsNBA"
# options$colorAnyway <- FALSE  # Otherwise overwrites colorPalette
# options$vioNudge <- 0.30
# options$vioHeight <- 0.40
# options$boxNudge <- 0.18
# options$boxWidth <- 0.2
# options$boxPadding <- 0.3
# options$jitter <- TRUE
# options$observationIdLineOpacity <- 0.10
# options$observationIdLineWidth <- 0.75
# options$widthPlot <- 750
# options$heightPlot <- 500
# options$showCaption <- FALSE
# options$numberOfClouds <- 6
# options$customSides <- TRUE
# options$customizationTable[[1]]$values <- c(rep("L", 3), rep("R", 3))
# results <- jaspTools::runAnalysis("raincloudPlots", "irisFertilizer.csv", options)

test_that("plot for ID over time matches", {
  options <- jaspTools::analysisOptions("raincloudPlots")
  options$.meta <- list(covariate = list(shouldEncode = TRUE), customizationTable = list(
    shouldEncode = TRUE), dependentVariables = list(shouldEncode = TRUE),
    observationId = list(shouldEncode = TRUE), primaryFactor = list(
      shouldEncode = TRUE), secondaryFactor = list(shouldEncode = TRUE))
  options$boxNudge <- 0.18
  options$boxOpacity <- 0.5
  options$boxPadding <- 0.3
  options$colorPalette <- "sportsTeamsNBA"
  options$covariatePalette <- "viridis"
  options$customSides <- TRUE
  options$customizationTable <- list(list(levels = "species", name = "data 1", values = c("L",
                                                                                          "L", "L", "R", "R", "R")), list(levels = "species", name = "data 2",
                                                                                                                          values = 0), list(levels = "species", name = "data 3", values = 0))
  options$dependentVariables <- "Sepal.Width"
  options$heightPlot <- 500
  options$jitter <- TRUE
  options$meanLines <- FALSE
  options$numberOfClouds <- 6
  options$observationId <- "id"
  options$observationIdLineOpacity <- 0.1
  options$observationIdLineWidth <- 0.75
  options$pointNudge <- 0.15
  options$pointOpacity <- 0.5
  options$primaryFactor <- "time"
  options$secondaryFactor <- "Species"
  options$showBox <- TRUE
  options$showCaption <- FALSE
  options$vioHeight <- 0.4
  options$vioNudge <- 0.3
  options$vioOpacity <- 0.5
  options$widthPlot <- 750
  set.seed(1)
  results <- jaspTools::runAnalysis("raincloudPlots", "irisFertilizer.csv", options)
  plotName <- results[["results"]][["containerRaincloudPlots"]][["collection"]][["containerRaincloudPlots_Sepal"]][["Width"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "rainIdOverTime")
})



# 7: Custom mean intervals ----
# options <- jaspTools::analysisOptions("rainDefaultOptionsUnitTest.jasp")
# options$dependentVariables <- "Sepal.Width"
# options$primaryFactor <- "time"
# options$secondaryFactor <- "Species"
# options$colorPalette <- "colorblind"
# options$colorAnyway <- FALSE
# options$vioOpacity <- 0
# options$vioOutline <- "none"
# options$boxOpacity <- 0
# options$boxOutline <- "none"
# options$boxOutlineWidth <- 1.5  # Mirror of meanIntervalOutlineWidth
# options$pointNudge <- 0
# options$pointOpacity <- 0.25
# options$mean <- TRUE
# options$meanPosition <- "onAxis"
# options$meanSize <- 7.5
# options$meanLines <- TRUE
# options$meanLinesOpacity <- 0.25
# options$meanLinesWidth <- 2
# options$numberOfClouds <- 6
# options$meanIntervalCustom <- TRUE
# options$customizationTable[[2]]$values <- c(2.60, 2.90, 3.00, 2.53, 3.33, 2.44)
# options$customizationTable[[3]]$values <- c(2.85, 3.07, 3.45, 2.91, 3.86, 2.66)
# results <- jaspTools::runAnalysis("raincloudPlots", "irisFertilizer.csv", options)

test_that("plot with custom mean interval matches", {
  options <- jaspTools::analysisOptions("raincloudPlots")
  options$.meta <- list(covariate = list(shouldEncode = TRUE), customizationTable = list(
    shouldEncode = TRUE), dependentVariables = list(shouldEncode = TRUE),
    observationId = list(shouldEncode = TRUE), primaryFactor = list(
      shouldEncode = TRUE), secondaryFactor = list(shouldEncode = TRUE))
  options$boxNudge <- 0
  options$boxOutline <- "none"
  options$boxOutlineWidth <- 1.5
  options$boxPadding <- 0.1
  options$boxWidth <- 0.1
  options$colorPalette <- "colorblind"
  options$covariatePalette <- "viridis"
  options$customizationTable <- list(list(levels = "species", name = "data 1", values = "R"),
                                     list(levels = "species", name = "data 2", values = c(2.6,
                                                                                          2.9, 3, 2.53, 3.33, 2.44)), list(levels = "species", name = "data 3",
                                                                                                                           values = c(2.85, 3.07, 3.45, 2.91, 3.86, 2.66)))
  options$dependentVariables <- "Sepal.Width"
  options$heightPlot <- 550
  options$mean <- TRUE
  options$meanIntervalCustom <- TRUE
  options$meanLinesOpacity <- 0.25
  options$meanLinesWidth <- 2
  options$meanPosition <- "onAxis"
  options$meanSize <- 7.5
  options$numberOfClouds <- 6
  options$pointOpacity <- 0.25
  options$primaryFactor <- "time"
  options$secondaryFactor <- "Species"
  options$showBox <- TRUE
  options$vioNudge <- 0.09
  options$vioOutline <- "none"
  options$widthPlot <- 675
  set.seed(1)
  results <- jaspTools::runAnalysis("raincloudPlots", "irisFertilizer.csv", options)
  plotName <- results[["results"]][["containerRaincloudPlots"]][["collection"]][["containerRaincloudPlots_Sepal"]][["Width"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "rainCustomMeanInterval")
})



# 8: Flanking clouds and vioSmoothing ----
# options <- jaspTools::analysisOptions("rainDefaultOptionsUnitTest.jasp")
# options$dependentVariables <- "Sepal.Width"
# options$primaryFactor <- "time"
# options$secondaryFactor <- "Species"
# options$observationId <- "id"
# options$colorAnyway <- FALSE  # Otherwise overwrites colorPalette
# options$vioNudge <- 0.225
# options$vioHeight <- 0.6
# options$vioSmoothing <- 0.33
# options$vioOpacity <- 0.33
# options$boxNudge <- 0.15
# options$boxOpacity <- 0.25
# options$pointOpacity <- 0.75
# options$jitter <- TRUE
# options$observationIdLineOpacity <- 0.15
# options$numberOfClouds <- 4
# options$customSides <- TRUE
# options$customizationTable[[1]]$values <- c("L", "L", "R", "R")
# df <- read.csv("irisFertilizer.csv")
# df <- subset(df, time != "t2")  # Remove for 2x2 flanking design
# results <- jaspTools::runAnalysis("raincloudPlots", df, options, makeTests = TRUE)

test_that("Sepal.Width plot matches", {
  options <- jaspTools::analysisOptions("raincloudPlots")
  options$.meta <- list(covariate = list(shouldEncode = TRUE), customizationTable = list(
    shouldEncode = TRUE), dependentVariables = list(shouldEncode = TRUE),
    observationId = list(shouldEncode = TRUE), primaryFactor = list(
      shouldEncode = TRUE), secondaryFactor = list(shouldEncode = TRUE))
  options$boxOpacity <- 0.25
  options$boxPadding <- 0.1
  options$boxWidth <- 0.1
  options$colorPalette <- "colorblind"
  options$covariatePalette <- "viridis"
  options$customSides <- TRUE
  options$customizationTable <- list(list(levels = "species", name = "data 1", values = c("L",
                                                                                          "L", "R", "R")), list(levels = "species", name = "data 2", values = 0),
                                     list(levels = "species", name = "data 3", values = 0))
  options$dependentVariables <- "Sepal.Width"
  options$heightPlot <- 550
  options$jitter <- TRUE
  options$meanLines <- FALSE
  options$numberOfClouds <- 4
  options$observationId <- "id"
  options$observationIdLineOpacity <- 0.15
  options$pointNudge <- 0.15
  options$pointOpacity <- 0.75
  options$primaryFactor <- "time"
  options$secondaryFactor <- "Species"
  options$showBox <- TRUE
  options$vioHeight <- 0.6
  options$vioNudge <- 0.225
  options$vioOpacity <- 0.33
  options$vioSmoothing <- 0.33
  options$widthPlot <- 675
  set.seed(1)
  df <- read.csv("irisFertilizer.csv")
  df <- subset(df, time != "t2")  # Remove for 2x2 flanking design
  results <- jaspTools::runAnalysis("raincloudPlots", df, options)
  plotName <- results[["results"]][["containerRaincloudPlots"]][["collection"]][["containerRaincloudPlots_Sepal"]][["Width"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "sepal-width")
})

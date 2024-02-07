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



# Main function: raincloudPlots() ----
raincloudPlots <- function(jaspResults, dataset, options) {
  ready   <- (length(options$variables) > 0)
  dataset <- .rainReadData(dataset, options)
  .rainCreatePlots(jaspResults, dataset, options, ready)
}  # End raincloudPlots()



# .rainReadData() ----
.rainReadData <- function(dataset, options) {

  if(!is.null(dataset)) {
    output <- dataset
  } else {

    # Step 1: Read in all variables that are given by JASP
    # When there is no input, nothing is read in
    readFactorAxis <- if (options$factorAxis == "") c() else options$factorAxis
    readFactorFill <- if (options$factorFill == "") c() else options$factorFill
    readCovariate  <- if (options$covariate  == "") c() else options$covariate
    readSubject    <- if (options$subject    == "") c() else options$subject

    datasetInProgress <- .readDataSetToEnd(
      columns = c(options$variables, readFactorAxis, readFactorFill, readCovariate, readSubject)
    )

    # Step 2: Create columns with consistent names; if no input then assign default
    datasetInProgress$factorAxis <- .rainCreateColumn(datasetInProgress,  options$factorAxis )
    datasetInProgress$factorFill <- .rainCreateColumn(datasetInProgress,  options$factorFill )
    datasetInProgress$covariate  <- .rainCreateColumn(datasetInProgress,  options$covariate  )
    datasetInProgress$subject    <- .rainCreateColumn(datasetInProgress,  options$subject    )

    output <- datasetInProgress
  }

  return(output)
} # End .rainReadData()



# .rainCreateColumn() ----
.rainCreateColumn <- function(inputDataset, inputOption) {
  output <- if (inputOption == "") {
    as.factor(rep("Total", nrow(inputDataset)))
  } else {
    inputDataset[[inputOption]]
  }
  return(output)
}  # End .rainCreateColumn()



# .rainCreatePlots() ----
# Creates a container with a plot for each options$variables - if none then placeholder
.rainCreatePlots <- function(jaspResults, dataset, options, ready) {

  # Create container in jaspResults
  if (is.null(jaspResults[["containerSimplePlots"]])) {
    jaspResults[["containerSimplePlots"]] <- createJaspContainer(title = gettext("Simple Plots"))
    jaspResults[["containerSimplePlots"]]$dependOn(
      c(
        "factorAxis", "factorFill", "covariate", "subject",

        "paletteFill",
        "colorAnyway",
        "vioOpacity", "vioOutline",
        "boxOpacity", "boxOutline",
        "pointOpacity", "palettePoints",
        "lineOpacity",

        "customSides", "sidesInput",
        "vioNudge",   "vioWidth",   "vioSmoothing",
        "boxNudge",   "boxWidth",   "boxDodge",
        "pointNudge", "pointWidth",

        "horizontal"

      )
    )
  }  # End create container

  # Access through container object
  container <- jaspResults[["containerSimplePlots"]]

  # Placeholder plot, if no variables
  if (!ready) {
    container[["placeholder"]] <- createJaspPlot(title = "", dependencies = c("variables"))
    return()
  }

  # Plot for each variable
  for (variable in options$variables) {

    # If plot for variable already exists, we can skip recalculating plot
    if (!is.null(container$variable)) next

    plotWidth    <- if (options$factorFill != "" || options$covariate != "" || options$colorAnyway) 675 else 450
    variablePlot <- createJaspPlot(title = variable, width = plotWidth, height = 450)
    variablePlot$dependOn(optionContainsValue = list(variables = variable))  # Depends on respective variable

    .rainFillPlot(dataset, options, variable, variablePlot)

    container[[variable]] <- variablePlot
  }  # End for loop

}  # End .rainCreatePlots()



# .rainFillPlot() ----
# Fills each inputPlot from .rainCreatePlots() with ggplot + palettes + geom_rain() + theme
.rainFillPlot <- function(dataset, options, inputVariable, inputPlot) {

  # Ggplot() with aes()
  aesX     <- dataset$factorAxis
  aesFill  <- if(options$factorFill != "") dataset$factorFill else if (options$colorAnyway) aesX else NULL
  aesColor <- if(options$covariate  != "") dataset$covariate  else if (options$colorAnyway) aesX else aesFill
  plotInProgress <- ggplot2::ggplot(
    data = dataset, ggplot2::aes(y = .data[[inputVariable]], x = aesX, fill = aesFill, color = aesColor)
  )

  # Palettes
  palettes       <- .rainSetPalettes(dataset, options)
  plotInProgress <- plotInProgress + palettes$fill + palettes$color

  # Workhorse function, uses ggrain::geom_rain()
  plotInProgress <- plotInProgress + .rainGeomRain(dataset, options, plotInProgress)

  # Theme
  setUpTheme   <- jaspGraphs::themeJaspRaw(legend.position = "right")
  xTitle       <- if (options$factorAxis == "") "Total" else options$factorAxis
  axisTitles   <- ggplot2::labs(x = xTitle, y = inputVariable)
  yBreaks      <- jaspGraphs::getPrettyAxisBreaks(dataset[[inputVariable]])
  yLimits      <- range(c(yBreaks, dataset[[inputVariable]]))
  yAxis        <- ggplot2::scale_y_continuous(breaks = yBreaks, limits = yLimits)
  inwardTicks  <- ggplot2::theme(axis.ticks.length = ggplot2::unit(-0.25, "cm"))

  plotInProgress <- plotInProgress + jaspGraphs::geom_rangeframe() + setUpTheme + axisTitles + yAxis + inwardTicks

  # Horizontal
  coordFlip <- if (options$horizontal) ggplot2::coord_flip() else NULL
  # Depending on horizontal: If no factor, blank text and ticks for one axis
  noFactorBlankAxis <- if (options$factorAxis == "") {
    if (!options$horizontal) {
      ggplot2::theme(axis.text.x = ggplot2::element_blank(), axis.ticks.x = ggplot2::element_blank())
    } else {
      ggplot2::theme(axis.text.y = ggplot2::element_blank(), axis.ticks.y = ggplot2::element_blank())
    }
  } else {
    NULL
  }
  plotInProgress <- plotInProgress + coordFlip + noFactorBlankAxis

  # Assign to inputPlot
  inputPlot[["plotObject"]] <- plotInProgress
}  # End .rainFillPlot()



# .rainSetPalettes() ----
.rainSetPalettes <- function(dataset, options) {

  paletteFill <- if (options$factorFill != "" || options$colorAnyway) {
    jaspGraphs::scale_JASPfill_discrete(options$paletteFill, name = options$factorFill)
  } else {
    NULL
  }

  paletteColor <- if (options$covariate != "") {
    if (is.factor(dataset$covariate)) {
      jaspGraphs::scale_JASPcolor_discrete(options$palettePoints, name = options$covariate)
    } else {
      jaspGraphs::scale_JASPcolor_continuous(options$palettePoints, name = options$covariate)
    }
  } else {
    if (options$factorFill != "" || options$colorAnyway) {
      jaspGraphs::scale_JASPcolor_discrete(options$paletteFill, name = options$factorFill)
    } else {
      NULL
    }
  }

  return(list(fill = paletteFill, color = paletteColor))
}  # End .rainSetPalettes()



# .rainGeomRain() ----
# Call of ggrain:geom_rain() with prior set up of all input arguments
.rainGeomRain <- function(dataset, options, plotInProgress) {

  # Info about factor combinations in the dataset & their colors
  infoFactorCombinations <- .rainInfoFactorCombinations(dataset, plotInProgress)

  # Opacity and outline color of violins & boxes
  vioArgs        <- list(alpha = options$vioOpacity, adjust = options$vioSmoothing)
  vioOutlineColor   <- .rainOutlineColor(options, options$vioOutline, infoFactorCombinations)
  perCloud512    <- rep(512, infoFactorCombinations$numberOfClouds)  # Each violin consists of 512 points by default
  vioArgs$color  <- rep(vioOutlineColor, perCloud512)

  boxArgs        <- list(outlier.shape = NA, alpha = options$boxOpacity)
  boxArgs$color  <- .rainOutlineColor(options, options$boxOutline, infoFactorCombinations)

  pointArgs      <- list(alpha = options$pointOpacity)

  lineArgs       <- list(alpha = options$lineOpacity)
  if (options$factorFill   == "") lineArgs$color <- "black"

  # Violin positioning
  vioSides <- .rainSetVioSides(options, dataset, infoFactorCombinations)  # Either all "r" or according to custom input
  vioNudgeForEachCloud <- .rainNudgeForEachCloud(options$vioNudge, vioSides)  # Based on default/custom orientation
  vioPosVec <- c()
  for (i in vioNudgeForEachCloud) {
    vioPosVec <- c(vioPosVec, rep(i, 512))  # Each violin consists of 512 points by default
  }
  vioArgsPos <- list(
    width = options$vioWidth, position = ggplot2::position_nudge(x = vioPosVec), side = vioSides
  )

  # Box positioning
  boxPosVec  <- .rainNudgeForEachCloud(options$boxNudge, vioSides)
  boxArgsPos <- list(
    width = options$boxWidth, position = ggpp::position_dodgenudge(x = boxPosVec, width = options$boxDodge)
  )

  # Point positioning
  negativePointNudge     <- options$pointNudge * -1  # This way all nudges in the GUI are positive by default
  pointArgsPos   <- list(
    position = ggpp::position_jitternudge(
      nudge.from = "jittered",
      width      = options$pointWidth,  # xJitter
      x          = negativePointNudge,  # Nudge
      height     = 0.0,                 # yJitter, particularly interesting for likert data
      seed       = 1.0                  # Reproducible jitter
    )
  )

  # Cov and id
  covArg         <- if (options$covariate == "")                              NULL else "covariate"  # Must be string
  idArg          <- if (options$subject   == "" || options$factorAxis == "")  NULL else "subject"
                    # FactorAxis condition necessary because if user added Axis input, then adds Subject input,
                    # and then removes the Axis input again, JASP/GUI/qml will not remove Subject input

  # Call geom_rain()
  output <- ggrain::geom_rain(
    violin.args = vioArgs, boxplot.args = boxArgs, point.args = pointArgs, line.args = lineArgs,

    rain.side = NULL,  # Necessary for neat positioning
    violin.args.pos = vioArgsPos, boxplot.args.pos = boxArgsPos, point.args.pos  = pointArgsPos,
                                                                 line.args.pos   = pointArgsPos,  # Dependent on points
    cov         = covArg,
    id.long.var = idArg,
    likert      = FALSE  # TRUE won´t work because of ggpp:position_jitternudge() in pointArgsPos
  )                      # instead use height argument in ggpp:position_jitternudge()

  return(output)
}  # End .rainGeomRain()



# .rainInfoFactorCombinations() ----
# Calculates info to determine colors & geom orientation
.rainInfoFactorCombinations <- function(inputDataset, inputPlot) {
  onlyFactors    <- inputDataset[c("factorAxis", "factorFill")]
  # Extract used Fill colors from plot
  # https://stackoverflow.com/questions/11774262/how-to-extract-the-fill-colours-from-a-ggplot-object
  onlyFactors$color <- ggplot2::ggplot_build(inputPlot)$data[[1]]["fill"]$fill

  # In the following possibleCombis <- expand.grid() factorFill first because
  # then structure will match order in which ggplot accesses the clouds:
  # for each level of Axis, we get the levels of Fill (as opposed to: for each level of Fill the levels of Axis)
  possibleCombis <- expand.grid(
    factorFill = levels(onlyFactors$factorFill), factorAxis = levels(onlyFactors$factorAxis)
  )

  possibleCombis$rowId <- 1:nrow(possibleCombis)  # Id is necessary as merge will scramble order of possibleCombis
  observedCombis <- merge(possibleCombis, onlyFactors)
  uniqueCombis   <- unique(observedCombis)

  uniqueCombis <- uniqueCombis[order(uniqueCombis$rowId), ] # Re-order rows according to possibleCombis

  numberOfClouds <- nrow(uniqueCombis)
  return(
    list(numberOfClouds = numberOfClouds, colors = uniqueCombis$color)
  )
}  # End .rainInfoFactorCombinations()



# .rainOutlineColor() ----
# Sets the Outline color of violins and boxes
.rainOutlineColor <- function(options, inputOutline, infoFactorCombinations) {

  output <- NULL

  if (inputOutline == "black") {
    output <- rep("black", infoFactorCombinations$numberOfClouds)
  } else if (inputOutline == "none") {
    output <- rep(NA, infoFactorCombinations$numberOfClouds)
  } else if (inputOutline == "likePalette") {
    if (options$factorFill != "" || options$colorAnyway) {
      output <- infoFactorCombinations$colors
    } else {
      output <- rep("black", infoFactorCombinations$numberOfClouds)
    }
  } else {
    print("error with Outline")
  }

  return(output)
}  # End .rainOutlineColor()



# .rainSetVioSides() ----
# Either default all right orientation or as sidesInput from user in GUI
# Output is as long as there are rainclouds in the plot
# because each cloud needs own side specified in point.args.pos argument of ggrain:geom_rain()
# see also .rainNudgeForEachCloud()
.rainSetVioSides <- function(options, dataset, infoFactorCombinations) {

  defaultSides  <- rep("r", infoFactorCombinations$numberOfClouds)

  if (!options$customSides) {
    outputSides <- defaultSides

  } else if (!grepl("^[LR]+$", options$sidesInput)) {  # May only contain 'L' or 'R'
    outputSides <- defaultSides

  # Number of customSides must match number of axis ticks
  } else if ( length(strsplit(options$sidesInput, "")[[1]]) != infoFactorCombinations$numberOfClouds) {
    outputSides <- defaultSides

  } else {
      outputSides <- strsplit(tolower(options$sidesInput), "")[[1]]
    }

  return(outputSides)
}  # End .rainSetVioSides()



# .rainNudgeForEachCloud() ----
# Depending on default/custom orientation
# For example, if there are two clouds and options$sidesInput is "LL"
# then vioNudge should be c(options$vioNudge * -1, options$vioNudge * -1)
# because options$vioNudge is inverted (* -1) as violins are flipped to left (instead of default right).
.rainNudgeForEachCloud <- function(inputNudge, vioSides) {
  nudgeVector <- rep(inputNudge, length(vioSides))
  for (i in 1:length(vioSides)) if (vioSides[i] == "l") nudgeVector[i] <- nudgeVector[i] * -1
  return(nudgeVector)
}  # End .rainNudgeForEachCloud()



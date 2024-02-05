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
    datasetInProgress$factorAxis <- .rainCreateColumn(   options$factorAxis,   datasetInProgress)
    datasetInProgress$factorFill <- .rainCreateColumn(   options$factorFill,   datasetInProgress)
    datasetInProgress$covariate  <- .rainCreateColumn(   options$covariate,    datasetInProgress)
    datasetInProgress$subject    <- .rainCreateColumn(   options$subject,      datasetInProgress)

    output <- datasetInProgress
  }

  return(output)
} # End .rainReadData()



# .rainCreateColumn() ----
.rainCreateColumn <- function(inputOption, inputDataset) {
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
        "vioOpacity", "vioEdges",
        "boxOpacity", "boxEdges",
        "pointOpacity", "palettePoints",

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

    plotWidth <- if (options$factorFill != "" || options$covariate != "" || options$colorAnyway) 675 else 450
    variablePlot <- createJaspPlot(title = variable, width = plotWidth, height = 450)
    variablePlot$dependOn(optionContainsValue = list(variables = variable))  # Depends on respective variable

    .rainFillPlot(variablePlot, dataset, options, variable, jaspResults)  # REMOVE jaspResults AGAIN ONCE CLOUD COUNT WORKS!!!!!!!!!!!!!!!!!

    container[[variable]] <- variablePlot
  }  # End for loop

}  # End .rainCreatePlots()



# .rainFillPlot() ----
# Fills each inputPlot from .rainCreatePlots() with ggplot + palettes + geom_rain() + theme
.rainFillPlot <- function(inputPlot, dataset, options, inputVariable, jaspResults) {

  # Ggplot() with aes()
  aesX     <- dataset$factorAxis
  aesFill  <- if(options$factorFill != "") dataset$factorFill else if (options$colorAnyway) aesX else NULL
  aesColor <- if(options$covariate  != "") dataset$covariate  else if (options$colorAnyway) aesX else aesFill
  plot <- ggplot2::ggplot(
    data = dataset, ggplot2::aes(y = dataset[[inputVariable]], x = aesX, fill = aesFill, color = aesColor)
  )

  # Palettes
  palettes <- .rainSetPalettes(options, dataset)
  plot <- plot + palettes$fill + palettes$color

  # Info about factor combinations in the dataset
  infoFactorCombinations <- .rainInfoFactorCombinations(dataset)
  # # # # # Delete this later - and also delete jaspResults as input argument from .rainFillPlot()
  countText <- createJaspHtml(text = gettextf("There are %s clouds in the sky.", infoFactorCombinations$numberOfClouds))
  countText$dependOn(c("variables", "factorAxis", "factorFill", "colorAnyway"))
  jaspResults[["countText"]] <- countText
  # # # # #

  # Workhorse function, uses ggrain::geom_rain()
  plot <- plot + .rainGeomRain(options, dataset, infoFactorCombinations)

  # Theme
  setUpTheme   <- jaspGraphs::themeJaspRaw(legend.position = "right")

  xTitle       <- if (options$factorAxis == "") "Total" else options$factorAxis
  axisTitles   <- ggplot2::labs(x = xTitle, y = inputVariable)

  yBreaks      <- jaspGraphs::getPrettyAxisBreaks(dataset[[inputVariable]])
  yLimits      <- range(c(yBreaks, dataset[[inputVariable]]))
  yAxis        <- ggplot2::scale_y_continuous(breaks = yBreaks, limits = yLimits)

  inwardTicks  <- ggplot2::theme(axis.ticks.length = ggplot2::unit(-0.25, "cm"))

  plot <- plot + jaspGraphs::geom_rangeframe() + setUpTheme + axisTitles + yAxis + inwardTicks

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
  plot <- plot + coordFlip + noFactorBlankAxis

  # Assign to inputPlot
  inputPlot[["plotObject"]] <- plot

}  # End .rainFillPlot()



# .rainSetPalettes() ----
.rainSetPalettes <- function(options, dataset) {

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



# .rainInfoFactorCombinations() ----
# Calculates info that is then used to determine geom orientation & color in .rainGeomRain()
.rainInfoFactorCombinations <- function(inputDataset) {
  onlyFactors    <- inputDataset[c("factorAxis", "factorFill")]
  possibleCombis <- expand.grid(factorAxis = levels(onlyFactors$factorAxis), factorFill = levels(onlyFactors$factorFill))
  observedCombis <- merge(possibleCombis, onlyFactors, by = c("factorAxis", "factorFill"))
  uniqueCombis   <- unique(observedCombis)
  numberOfClouds <- nrow(uniqueCombis)
  return(
    list(numberOfClouds = numberOfClouds, uniqueCombis = uniqueCombis, observedCombis = observedCombis)
  )
}  # End .rainInfoFactorCombinations()



# .rainGeomRain() ----
# Call of ggrain:geom_rain() with prior set up of all input arguments
.rainGeomRain <- function(options, dataset, infoFactorCombinations) {

  # Opacity and outline color of violins & boxes
  vioArgs        <- list(alpha = options$vioOpacity, adjust = options$vioSmoothing)
  vioArgs$color  <- .rainEdgeColor(options$vioEdges)

  boxArgs        <- list(outlier.shape = NA, alpha = options$boxOpacity)
  boxArgs$color  <- .rainEdgeColor(options$boxEdges)

  pointArgs      <- list(alpha = options$pointOpacity)

  lineArgs       <- list(alpha = .33)
  if (options$factorFill   == "") lineArgs$color <- "black"

  vioSides <- .rainSetVioSides(options, dataset, infoFactorCombinations)  # Either all R or according to custom input

  # Violin position
  vioNudge  <- .rainNudgeForEachCloud(options$vioNudge, vioSides)  # Nudging based on default/custom orientation
  vioPosVec <- c()
  for (i in vioNudge) vioPosVec <- c(vioPosVec, rep(i, 512))  # Each density curve consists of 512 points by default
  vioArgsPos <- list(width = options$vioWidth, position = ggplot2::position_nudge(x = vioPosVec), side = vioSides)

  # Box position
  boxPosVec <- .rainNudgeForEachCloud(options$boxNudge,   vioSides)
  boxArgsPos <- list(
    width = options$boxWidth, position = ggpp::position_dodgenudge(x = boxPosVec, width = options$boxDodge)
  )

  # Point position
  pointNudge     <- options$pointNudge * -1  # Because of this, all nudges in the GUI can be positive by default
                                             # Otherwise pointNudge would be displayed as -0.14 which did not look as tidy
  pointNudge     <- .rainNudgeForEachCloud(pointNudge, vioSides)
  pointsPerCloud <- .rainPointsPerCloud(infoFactorCombinations)
  pointPosVec    <- c()
  for (i in 1:length(pointNudge)) {
    pointPosVec <- c(pointPosVec, rep(pointNudge[i], pointsPerCloud[i]))
  }
  pointArgsPos <- list(
    position = ggpp::position_jitternudge(
      nudge.from = "jittered",
      width      = options$pointWidth,  # xJitter
      x          = pointPosVec,         # Nudge
      height     = 0.0,                 # yJitter, particularly interesting for likert data
      seed       = 1.0                  # Reproducible jitter
    )
  )

  # Cov and id
  covArg         <- if (options$covariate == "")                              NULL else "covariate"  # Must be string
  idArg          <- if (options$subject   == "" || options$factorAxis == "")  NULL else "subject"
                                                   # FactorAxis condition necessary because if user added Axis input
                                                   # then adds Subject input
                                                   # and then removes the Axis input again
                                                   # JASP/GUI/qml will not remove Subject input

  # Call geom_rain()
  output <- ggrain::geom_rain(

    violin.args = vioArgs, boxplot.args = boxArgs, point.args = pointArgs, line.args = lineArgs,

    rain.side = NULL,  # Necessary for neat positioning
    violin.args.pos = vioArgsPos, boxplot.args.pos = boxArgsPos,
    point.args.pos  = pointArgsPos, line.args.pos = pointArgsPos,  # Lines depend fully on points, so same positioning

    cov         = covArg,
    id.long.var = idArg,

    likert      = FALSE  # TRUE does not work because of ggpp:position_jitternudge() in pointPos
                         # use jitternudge height argument instead
  )

  return(output)
}  # End .rainGeomRain()



# .rainSetVioSides() ----
# Either default all right orientation or as sidesInput from user in GUI
# Output is as long as there are rainclouds in the plot
# because each needs own side specified in point.args.pos argument of ggrain:geom_rain() - see also .rainNudgeForEachCloud()
.rainSetVioSides <- function(options, dataset, infoFactorCombinations) {

  defaultSides  <- rep("r", infoFactorCombinations$numberOfClouds)  # Default

  if (!options$customSides) {
    outputSides <- defaultSides

  } else if (!grepl("^[LR]+$", options$sidesInput)) {  # May only contain 'L' or 'R'
    outputSides <- defaultSides

  # Number of customSides must match number of axis ticks
  } else if ( length(strsplit(options$sidesInput, "")[[1]]) != nlevels(dataset$factorAxis)) {
    outputSides <- defaultSides

  } else {

      outputSides   <- c()
      sidesVector   <- strsplit(tolower(options$sidesInput), "")[[1]]  # Lowercase and stringsplit sidesInput
      axisVector    <- infoFactorCombinations$uniqueCombis$factorAxis
      previousLevel <- axisVector[1]
      sidesIndex    <- 1

      for (level in axisVector) {
        if (level == previousLevel) {
          outputSides <- c(outputSides, sidesVector[sidesIndex])
        } else {
          sidesIndex    <- sidesIndex + 1
          outputSides   <- c(outputSides, sidesVector[sidesIndex])
          previousLevel <- level
        }
      }
    }

  return(outputSides)
}  # End .rainSetVioSides()



# .rainNudgeForEachCloud() ----
# depending on default/custom orientation
# For example, if there are two clouds and options$sidesInput is "LL" then vioNudge should be rep(options$vioNudge * -1, 2)
.rainNudgeForEachCloud <- function(nudgeInput, vioSides) {
  nudgeVector <- rep(nudgeInput, length(vioSides))
  for (i in 1:length(vioSides)) if (vioSides[i] == "l") nudgeVector[i] <- nudgeVector[i] * -1
  return(nudgeVector)
}  # End .rainNudgeForEachCloud()



# .rainPointsPerCloud() ----
.rainPointsPerCloud <- function(infoFactorCombinations) {

  output <- c()

  combinationsVector <- paste0(
    infoFactorCombinations$uniqueCombis$factorAxis, infoFactorCombinations$uniqueCombis$factorFill
  )

  observationsVector <- paste0(
    infoFactorCombinations$observedCombis$factorAxis, infoFactorCombinations$observedCombis$factorFill
  )

  for (combination in combinationsVector) {
    output <- c(output, sum(observationsVector == combination))
  }

  return(output)
}  # End .rainPointsPerCloud()



# .rainEdgeColor() ----
# Sets the edges of violins and boxes
.rainEdgeColor <- function(input) {
  if      (input == "black") return("black")
  else if (input == "none")  return(NA)
  else                       print("error with edges")
}  # End .rainEdgeColor()



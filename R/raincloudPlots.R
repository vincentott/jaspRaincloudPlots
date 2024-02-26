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
    columnsVector <- c(options$variables)
    if (options$primaryFactor   != "") columnsVector <- c(columnsVector, options$primaryFactor)
    if (options$secondaryFactor != "") columnsVector <- c(columnsVector, options$secondaryFactor)
    if (options$covariate       != "") columnsVector <- c(columnsVector, options$covariate)
    if (options$subject         != "") columnsVector <- c(columnsVector, options$subject)
    datasetInProgress <- .readDataSetToEnd(columns = columnsVector)

    # Step 2: Create columns with consistent names; if no input then assign default
    datasetInProgress$primaryFactor   <- .rainCreateColumn(datasetInProgress,  options$primaryFactor)
    datasetInProgress$secondaryFactor <- .rainCreateColumn(datasetInProgress,  options$secondaryFactor)
    datasetInProgress$covariate       <- .rainCreateColumn(datasetInProgress,  options$covariate)
    datasetInProgress$subject         <- .rainCreateColumn(datasetInProgress,  options$subject)

    output <- datasetInProgress
  }

  return(output)
} # End .rainReadData()



# .rainCreateColumn() ----
.rainCreateColumn <- function(inputDataset, inputOption) {
  output <- if (inputOption != "") {
    inputDataset[[inputOption]]
  } else {
      as.factor(rep("none", nrow(inputDataset)))
  }
  return(output)
}  # End .rainCreateColumn()



# .rainCreatePlots() ----
# Creates a container with a plot for each options$variables - if none then placeholder
.rainCreatePlots <- function(jaspResults, dataset, options, ready) {

  # Create container in jaspResults
  if (is.null(jaspResults[["containerRainPlots"]])) {
    jaspResults[["containerRainPlots"]] <- createJaspContainer(title = gettext("Raincloud Plots"))
    jaspResults[["containerRainPlots"]]$dependOn(
      c(
        "primaryFactor", "secondaryFactor", "covariate", "subject",  # VariablesForm

        "colorPalette", "colorAnyway",  # General Settings
        "covariatePalette",
        "horizontal",

        "vioNudge",     "boxNudge",   "pointNudge",  # Cloud Elements
        "vioHeight",    "boxWidth",   "pointSpread",
        "vioSmoothing", "boxPadding", "pointSize",
        "vioOpacity",   "boxOpacity", "pointOpacity",
        "vioOutline",   "boxOutline", "jitter",
        "lineOpacity",

        "customAxisLimits", "lowerAxisLimit", "upperAxisLimit",

        "showCaption",  # Axes, Legend, Caption, Plot size
        "widthPlot", "heightPlot",

        "customSides",  # Advanced
        "means", "meanLines"

      )
    )
  }  # End create container

  # Access through container object
  container <- jaspResults[["containerRainPlots"]]

  # Placeholder plot, if no variables
  if (!ready) {
    container[["placeholder"]] <- createJaspPlot(title = "", dependencies = c("variables"))
    return()
  }

  # Plot for each variable
  for (variable in options$variables) {

    # If plot for variable already exists, we can skip recalculating plot
    if (!is.null(container$variable)) next

    variablePlot <- createJaspPlot(title = variable, width = options$widthPlot, height = options$heightPlot)
    variablePlot$dependOn(optionContainsValue = list(variables = variable))  # Depends on respective variable

    .rainFillPlot(dataset, options, variable, variablePlot)

    container[[variable]] <- variablePlot
  }  # End for loop

}  # End .rainCreatePlots()



# .rainFillPlot() ----
# Fills each inputPlot from .rainCreatePlots() with ggplot + palettes + geom_rain() + theme
.rainFillPlot <- function(dataset, options, inputVariable, inputPlot) {

  # Omit NAs row-wise
  exclusiveDataset   <- na.omit(dataset)
  numberOfExclusions <- nrow(dataset) - nrow(exclusiveDataset)
  dataset            <- exclusiveDataset
  sampleSize         <- nrow(dataset)

  # Ggplot() with aes()
  aesX     <- dataset$primaryFactor
  aesFill  <- if(options$secondaryFactor != "") dataset$secondaryFactor else if (options$colorAnyway) aesX else NULL
  aesColor <- if(options$covariate       != "") dataset$covariate       else if (options$colorAnyway) aesX else aesFill
  aesArg <- ggplot2::aes(y = .data[[inputVariable]], x = aesX, fill = aesFill, color = aesColor)
  plotInProgress <- ggplot2::ggplot(data = dataset, mapping = aesArg)

  # Palettes
  palettes       <- .rainSetPalettes(dataset, options)
  plotInProgress <- plotInProgress + palettes$fill + palettes$color

  # Preparation
  infoFactorCombinations <- .rainInfoFactorCombinations(dataset, plotInProgress)  # Also has color info

  getVioSides   <- .rainSetVioSides(options, dataset, infoFactorCombinations)  # Default "r" or like to custom input
  vioSides      <- getVioSides$sides
  errorVioSides <- getVioSides$error

  boxPosVec   <- .rainNudgeForEachCloud(options$boxNudge, vioSides)
  boxPosition <- ggpp::position_dodge2nudge(  # boxPosition for whiskers, .rainGeomRain
    x        = boxPosVec,
    width    = 0,
    padding  = options$boxPadding,
    preserve = "single"  # All boxes same width and different amounts of boxes are centered around middle
  )

  # boxWhiskers + boxHideWhiskerMiddle
  boxWhiskers <- ggplot2::stat_boxplot(
    geom = "errorbar", position = boxPosition, width = options$boxWidth, show.legend = FALSE,
    color = .rainOutlineColor(options, options$boxOutline, infoFactorCombinations)
  )
  boxHideWhiskerMiddle <- ggplot2::geom_boxplot(
    position = boxPosition, width = options$boxWidth,
    coef = 0, outlier.shape = NA, fatten = NULL, show.legend = FALSE,
    fill = "white"
  )
  if (options$boxOutline != "none") plotInProgress <- plotInProgress + boxWhiskers + boxHideWhiskerMiddle

  # .rainGeomRain() - workhorse function, uses ggrain::geom_rain()
  plotInProgress <- plotInProgress + .rainGeomRain(
    dataset, options, infoFactorCombinations, aesArg, vioSides, boxPosition, plotInProgress
  )

  # Means and Lines
  means <- if (options$means) {
    ggplot2::stat_summary(
      fun         = mean,
      geom        = "point",
      mapping     = ggplot2::aes(x = aesX, fill = aesFill),  # No color argument, covariate will interfere with it
      color       = .rainOutlineColor(options, "palette", infoFactorCombinations),  # Instead like Outlines
      position    = boxPosition,
      shape       = 18,
      size        = 6,
      alpha       = 1,
      show.legend = FALSE
    )
  } else {
    NULL
  }
  meanLines <- if (options$secondaryFactor == "" && options$means && options$meanLines) {  # Needs options$means as qml wont uncheck options$meanLines
    ggplot2::stat_summary(                                # if options$means is unchecked again
      fun      = mean,
      geom     = "line",
      mapping  = ggplot2::aes(group = 1),
      color    = "black",
      position = boxPosition,
      alpha    = 0.5
    )
  } else {
    NULL
  }
  plotInProgress <- plotInProgress + means + meanLines


  # Horizontal plot?
  if (options$horizontal) plotInProgress <- plotInProgress + ggplot2::coord_flip()

  # Theme setup
  plotInProgress <- plotInProgress + jaspGraphs::geom_rangeframe() + jaspGraphs::themeJaspRaw(legend.position = "right")

  # Axes
  if (!options$customAxisLimits) {
    yBreaks <- jaspGraphs::getPrettyAxisBreaks(dataset[[inputVariable]])
    yLimits <- range(c(yBreaks, dataset[[inputVariable]]))
    warningAxisLimits <- FALSE
  } else {
    yBreaks <- jaspGraphs::getPrettyAxisBreaks(c(options$lowerAxisLimit, options$upperAxisLimit))
    yLimits <- range(yBreaks)
    warningAxisLimits <- if (
      min(yBreaks) > min(dataset[[inputVariable]]) || max(yBreaks) < max(dataset[[inputVariable]])
    ) {
      TRUE
    } else {
      FALSE
    }
  }
  yAxis   <- ggplot2::scale_y_continuous(breaks = yBreaks, limits = yLimits)

  inwardTicks <- ggplot2::theme(axis.ticks.length = ggplot2::unit(-0.25, "cm"))

  xTitle     <- if (options$primaryFactor == "") "Total" else options$primaryFactor
  axisTitles <- ggplot2::labs(x = xTitle, y = inputVariable)

  noFactorBlankAxis <- if (options$primaryFactor == "") {
    if (!options$horizontal) {
      ggplot2::theme(axis.text.x = ggplot2::element_blank(), axis.ticks.x = ggplot2::element_blank())
    } else {
      ggplot2::theme(axis.text.y = ggplot2::element_blank(), axis.ticks.y = ggplot2::element_blank())
    }
  } else {
    NULL
  }

  plotInProgress <- plotInProgress + yAxis + inwardTicks + axisTitles + noFactorBlankAxis


  # Legend
  guideFill <- if (options$primaryFactor == ""  && options$secondaryFactor == "") {
    "none"  # If there is just a single cloud and colorAnyway, we do not need a legend
  } else {
    ggplot2::guide_legend(
      order = 1, reverse = options$horizontal, override.aes = list(alpha = 0.5, color = NA)  # NA removes points in boxes
    )
  }
  guideColor <- if (options$covariate == "") {
    NULL
  } else {
    if (is.factor(dataset$covariate)) {
      ggplot2::guide_legend(override.aes = list(size = 6.5))
    } else {
      ggplot2::guide_colourbar()
    }
  }
  guide <- ggplot2::guides(fill = guideFill, color = guideColor)
  plotInProgress <- plotInProgress + guide


  # Caption
  if (options$showCaption) {
    caption         <- .rainCaption(options, sampleSize, numberOfExclusions, warningAxisLimits, errorVioSides)
    addCaption      <- ggplot2::labs(caption = caption)
    captionPosition <- ggplot2::theme(plot.caption = ggtext::element_markdown(hjust = 0))  # Bottom left position
    plotInProgress  <- plotInProgress + addCaption + captionPosition
  }

  # Assign to inputPlot
  inputPlot[["plotObject"]] <- plotInProgress
}  # End .rainFillPlot()



# .rainSetPalettes() ----
.rainSetPalettes <- function(dataset, options) {

  fillTitle <- if (options$secondaryFactor == "") options$primaryFactor else options$secondaryFactor
  paletteFill <- if (options$secondaryFactor != "" || options$colorAnyway) {
    jaspGraphs::scale_JASPfill_discrete(options$colorPalette, name = fillTitle)
  } else {
    NULL
  }

  paletteColor <- if (options$covariate != "") {
    if (is.factor(dataset$covariate)) {
      jaspGraphs::scale_JASPcolor_discrete(  options$covariatePalette, name = options$covariate)
    } else {
      jaspGraphs::scale_JASPcolor_continuous(options$covariatePalette, name = options$covariate)
    }
  } else {
    if (options$secondaryFactor != "" || options$colorAnyway) {
      jaspGraphs::scale_JASPcolor_discrete(  options$colorPalette,     name = options$secondaryFactor)
    } else {
      NULL
    }
  }

  return(list(fill = paletteFill, color = paletteColor))
}  # End .rainSetPalettes()



# .rainInfoFactorCombinations() ----
# Calculates info to determine colors & geom orientation
.rainInfoFactorCombinations <- function(inputDataset, inputPlot) {
  onlyFactors    <- inputDataset[c("primaryFactor", "secondaryFactor")]
  # Extract used Fill colors from plot
  # https://stackoverflow.com/questions/11774262/how-to-extract-the-fill-colours-from-a-ggplot-object
  onlyFactors$color <- tryCatch(
    {
      ggplot2::ggplot_build(inputPlot)$data[[1]]["fill"]$fill  # Requires secondaryFactor or colorAnyway
    },
    error = function(e) {                                      # Thus error handling, but not used further
      return("black")
    },
    warning = function(w) {
      return("black")
    }
  )

  # In the following possibleCombis <- expand.grid() secondaryFactor first because
  # then structure will match order in which ggplot accesses the clouds:
  # for each level of primaryFactor, we get the levels of secondaryFactor
  # (as opposed to: for each level of secondaryFactor, the levels of primaryFactor)
  possibleCombis <- expand.grid(
    secondaryFactor = levels(onlyFactors$secondaryFactor), primaryFactor = levels(onlyFactors$primaryFactor)
  )

  possibleCombis$rowId <- 1:nrow(possibleCombis)  # Id is necessary as merge will scramble order of possibleCombis

  observedCombis <- merge(possibleCombis, onlyFactors)
  uniqueCombis   <- unique(observedCombis)

  uniqueCombis <- uniqueCombis[order(uniqueCombis$rowId), ] # Re-order rows according to id in possibleCombis

  numberOfClouds <- nrow(uniqueCombis)
  return(
    list(numberOfClouds = numberOfClouds, colors = uniqueCombis$color)
  )
}  # End .rainInfoFactorCombinations()



# .rainGeomRain() ----
# Call of ggrain:geom_rain() with prior set up of all input arguments
.rainGeomRain <- function(dataset, options, infoFactorCombinations, aesArg, vioSides, boxPosition, plotInProgress) {

  # Arguments for the cloud elements: Violin, Box, Point, Subject lines
  showVioGuide    <- if (options$secondaryFactor == "") TRUE else FALSE
  vioArgs         <- list(alpha = options$vioOpacity, adjust = options$vioSmoothing)
  vioOutlineColor <- .rainOutlineColor(options, options$vioOutline, infoFactorCombinations)
  perCloud512     <- rep(512, infoFactorCombinations$numberOfClouds)  # Each violin consists of 512 points by default
  vioArgs$color   <- rep(vioOutlineColor, perCloud512)

  boxArgs       <- list(outlier.shape = NA, alpha = options$boxOpacity, show_guide = FALSE)
  boxArgs$color <- .rainOutlineColor(options, options$boxOutline, infoFactorCombinations)

  showPointGuide <- if (options$covariate == "") FALSE else TRUE
  pointArgs      <- list(alpha = options$pointOpacity, show_guide = showPointGuide, size = options$pointSize)

  lineArgs <- list(alpha = options$lineOpacity, show_guide = FALSE)
  if (options$secondaryFactor   == "") lineArgs$color <- "black"

  # Violin positioning
  vioNudgeForEachCloud <- .rainNudgeForEachCloud(options$vioNudge, vioSides)  # Based on default/custom orientation
  vioPosVec <- c()
  for (i in vioNudgeForEachCloud) {
    vioPosVec <- c(vioPosVec, rep(i, 512))  # Each violin consists of 512 points by default
  }
  vioArgsPos <- list(
    width = options$vioHeight, position = ggplot2::position_nudge(x = vioPosVec), side = vioSides
  )

  # Box positioning
  boxPosVec  <- .rainNudgeForEachCloud(options$boxNudge, vioSides)
  boxArgsPos <- list(
    width = options$boxWidth,
    position = boxPosition
  )

  # Point positioning
  negativePointNudge <- if (options$customSides == "") {
    options$pointNudge * -1  # This way all nudges in the GUI are positive by default
  } else {
    0                        # CustomSides fixes points to Axis ticks (see HelpButton in .qml)
  }
  jitter <- if (!options$jitter) 0 else NULL
  pointArgsPos   <- list(
    position = ggpp::position_jitternudge(
      nudge.from = "jittered",
      width      = options$pointSpread, # xJitter
      x          = negativePointNudge,  # Nudge
      height     = jitter,              # Jitter, particularly interesting for likert data
      seed       = 1                    # Reproducible jitter
    )
  )

  # Cov and id
  covArg <- if (options$covariate == "")                                 NULL else "covariate"  # Must be string
  idArg  <- if (options$subject   == "" || options$primaryFactor == "")  NULL else "subject"
            # primaryFactor condition necessary because if user input primaryFactor, then adds Subject input,
            # and then removes primaryFactor again, JASP/GUI/qml will not remove Subject input

  # Call geom_rain()
  output <- ggrain::geom_rain(

    mapping = aesArg,

    violin.args = vioArgs, boxplot.args = boxArgs, point.args = pointArgs, line.args = lineArgs,

    rain.side        = NULL,  # Necessary for neat positioning
    violin.args.pos  = vioArgsPos,
    boxplot.args.pos = boxArgsPos,
    point.args.pos   = pointArgsPos,
    line.args.pos    = pointArgsPos,  # Dependent on points

    cov         = covArg,
    id.long.var = idArg,
    likert      = FALSE  # TRUE won´t work because of ggpp:position_jitternudge() in pointArgsPos
                         # instead use height argument in ggpp:position_jitternudge()
  )  # End geom_rain()

  return(output)
}  # End .rainGeomRain()



# .rainOutlineColor() ----
# Sets the Outline color of violins and boxes
.rainOutlineColor <- function(options, inputOutline, infoFactorCombinations) {

  output <- NULL

  if (inputOutline == "black") {
    output <- rep("black", infoFactorCombinations$numberOfClouds)
  } else if (inputOutline == "none") {
    output <- rep(NA, infoFactorCombinations$numberOfClouds)
  } else if (inputOutline == "palette") {
    if (options$secondaryFactor != "" || options$colorAnyway) {
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
# Either default all right orientation or as customSides from user in GUI
# Output is as long as there are rainclouds in the plot
# because each cloud needs own side specified in point.args.pos argument of ggrain:geom_rain()
# see also .rainNudgeForEachCloud()
.rainSetVioSides <- function(options, dataset, infoFactorCombinations) {

  defaultSides  <- rep("r", infoFactorCombinations$numberOfClouds)

  if (options$customSides == "") {
    outputSides <- defaultSides
    error       <- FALSE

  } else if (!grepl("^[LR]+$", options$customSides)) {  # Must only contain 'L' or 'R'
    outputSides <- defaultSides
    error       <- TRUE

  # Number of customSides must match number of axis ticks
  } else if (length(strsplit(options$customSides, "")[[1]]) != infoFactorCombinations$numberOfClouds) {
    outputSides <- defaultSides
    error       <- TRUE

  } else {
    outputSides <- strsplit(tolower(options$customSides), "")[[1]]
    error       <- FALSE
  }

  return(list(sides = outputSides, error = error))
}  # End .rainSetVioSides()



# .rainNudgeForEachCloud() ----
# Depending on default/custom orientation
# For example, if there are two clouds and options$customSides is "LL"
# then vioNudge should be c(options$vioNudge * -1, options$vioNudge * -1)
# because options$vioNudge is inverted (* -1) as violins are flipped to left (instead of default right).
.rainNudgeForEachCloud <- function(inputNudge, vioSides) {
  nudgeVector <- rep(inputNudge, length(vioSides))
  for (i in 1:length(vioSides)) if (vioSides[i] == "l") nudgeVector[i] <- nudgeVector[i] * -1
  return(nudgeVector)
}  # End .rainNudgeForEachCloud()



# .rainCaption() ----
# CSS formatting is brought to life by ggtext::element_markdown(), see .rainFillPlot()
.rainCaption <- function(options, sampleSize, numberOfExclusions, warningAxisLimits, errorVioSides) {

  sampleSize <- gettextf("<i>N</i> = %s", sampleSize)

  exclusions <- if (numberOfExclusions > 0) {
    gettextf("Not shown are %s observations due to missing data.", numberOfExclusions)
  } else {
    NULL
  }

  jitter <- if (options$jitter) {
    gettextf("Points are slightly jittered from their true values.")
  } else {
    NULL
  }

  warningAxisLimits <- if (warningAxisLimits) {
    gettextf("<span style = 'color: darkorange'> Warning! Some data is not shown<br>because it lies outside of the interval set by the custom axis limits.</span>")
  } else {
    NULL
  }

  errorVioSides <- if (errorVioSides) {
    gettextf("<span style = 'color: darkorange'> Invalid input: Custom orientation. Reverted to default all 'R'. Point Nudge set to 0.</span>")
  } else {
    NULL
  }

  output <- paste0(sampleSize, "\n\n", exclusions, "\n\n", jitter, "\n\n", warningAxisLimits, "\n\n", errorVioSides)
  return(output)
}

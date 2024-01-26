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

  ready <- (length(options$variables) > 0)
  dataset <- .rainReadData(dataset, options)
  .rainCreatePlots(jaspResults, dataset, options, ready)

}  # End raincloudPlots()



# .rainReadData() ----
.rainReadData <- function(dataset, options) {

  output = NULL

  if(!is.null(dataset)) {
    output <- dataset
  } else {

    factorAxis <- if (options$factorAxis == "") c() else options$factorAxis
    factorFill <- if (options$factorFill == "") c() else options$factorFill
    covariate  <- if (options$covariate == "")  c() else options$covariate

    output <- .readDataSetToEnd(
      columns.as.numeric = options$variables,
      columns.as.factor = c(factorAxis, factorFill),
      columns = covariate
      )
  }

  return(output)
} # End .rainReadData()



# .rainCreatePlots() ----
.rainCreatePlots <- function(jaspResults, dataset, options, ready) {

  # Create container in jaspResults
  if (is.null(jaspResults[["containerSimplePlots"]])) {
    jaspResults[["containerSimplePlots"]] <- createJaspContainer(title = gettext("Simple Plots"))
    jaspResults[["containerSimplePlots"]]$dependOn(
      c(
        "factorAxis", "factorFill", "covariate",

        "paletteFill",
        "colorAnyway",
        "vioOpacity",
        "boxOpacity",
        "pointOpacity", "palettePoints",

        "customLimits", "lowerLimit", "customBreaks", "upperLimit",

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

    .rainFillPlot(variablePlot, dataset, options, variable)

    container[[variable]] <- variablePlot
  }  # End for loop

}  # End .rainCreatePlots()



# .rainFillPlot() ----
.rainFillPlot <- function(inputPlot, dataset, options, inputVariable) {

  # Transform to data.frame() - required for ggplot
  variableVector  <- dataset[[inputVariable]]
  axisVector      <- if (options$factorAxis == "") rep("Total", length(variableVector)) else dataset[[options$factorAxis]]
  fillVector      <- if (options$factorFill == "") rep(NA,      length(variableVector)) else dataset[[options$factorFill]]
  covariateVector <- if (options$covariate == "")  rep(NA,      length(variableVector)) else dataset[[options$covariate]]
  df <- data.frame(variableVector, axisVector, fillVector, covariateVector)

  # Ggplot with aes()
  aesX <- axisVector
  aesFill  <- if(options$factorFill != "") fillVector      else if (options$colorAnyway) aesX else NULL
  aesColor <- if(options$covariate != "")  covariateVector else if (options$colorAnyway) aesX else aesFill

  plot <- ggplot2::ggplot(data = df, ggplot2::aes(y = variableVector, x = aesX, fill = aesFill, color = aesColor))

  # Geom_rain()
  vioOpacity   <- options$vioOpacity
  boxOpacity   <- options$boxOpacity
  pointOpacity <- options$pointOpacity
  geomRainCov  <- if (options$covariate == "") NULL else "covariateVector"  # Cov argument in geom_rain() must be string

  # # # The following was an attempt at editing the vio & box edges - it is on hold for now
  vioArgs <- list(alpha = vioOpacity, color = "black")
  # if (options$vioEdges == "" || options$vioEdges == "as palette") {
  #   NULL
  # } else if (options$vioEdges == "black") {
  #   vioArgs$color <- "black"
  # } else if (options$vioEdges == "none") {
  #   vioArgs$color <- NA
  # } else {
  #   print("Something went wrong with the violin plot edges.")
  # }
  boxArgs <- list(outlier.shape = NA, alpha = boxOpacity, color = "black")
  # if (options$boxEdges == "" || options$boxEdges == "as palette") {
  #   NULL
  # } else if (options$boxEdges == "black") {
  #   boxArgs$color <- "black"
  # } else if (options$boxEdges == "none") {
  #   boxArgs$color <- NA
  # } else {
  #   print("Something went wrong with the boxplot edges.")
  # }

  plot <- plot + ggrain::geom_rain(

    violin.args = vioArgs,
    boxplot.args = boxArgs,
    point.args = list(alpha = pointOpacity),

    # Positioning
    rain.side = "r",  # Necessary to specify for neat positioning to work, even though it is the default
    violin.args.pos = list(width = 0.7, position = ggplot2::position_nudge(x = 0.075)),
    boxplot.args.pos = list(width = 0.075, position = ggpp::position_dodgenudge(x = 0, width = 0.15)),
    point.args.pos = list(
      position = ggpp::position_jitternudge(
        nudge.from = "jittered",
        x = -0.14,  # Nudge
        width = .065,  # xJitter
        height = 0,  # yJitter, particularly interesting for likert data
        seed = 1  # Reproducible jitter
      )
    ),

    cov = geomRainCov,

    likert = FALSE  # TRUE does not work because of ggpp:position_jitternudge() - instead jitternudge height argument

  )  # End geom_rain()

  # Colors
  paletteFill <- if (options$factorFill != "") {
    if (is.factor(fillVector)) {
      jaspGraphs::scale_JASPfill_discrete(options$paletteFill, name = options$factorFill)
    } else {
      jaspGraphs::scale_JASPfill_continuous(options$paletteFill, name = options$factorFill)
    }
  } else if (options$colorAnyway) {
    jaspGraphs::scale_JASPfill_discrete(options$paletteFill, name = options$factorFill)
  } else {
    NULL
  }
  paletteColor <- if (options$covariate != "") {
    if (is.factor(covariateVector)) {
      jaspGraphs::scale_JASPcolor_discrete(options$palettePoints, name = options$covariate)
    } else {
      jaspGraphs::scale_JASPcolor_continuous(options$palettePoints, name = options$covariate)
    }
  } else {
    if (options$factorFill != "") {
      if (is.factor(fillVector)) {
        jaspGraphs::scale_JASPcolor_discrete(options$paletteFill, name = options$factorFill)
      } else {
        jaspGraphs::scale_JASPcolor_continuous(options$paletteFill, name = options$factorFill)
      }
    } else if (options$colorAnyway) {
      jaspGraphs::scale_JASPcolor_discrete(options$paletteFill, name = options$factorFill)
    } else {
      NULL
    }
  }  # End paletteColor
  plot <- plot + paletteFill + paletteColor

  # Theme
  setUpTheme <- jaspGraphs::themeJaspRaw(legend.position = "right")

  xTitle <- if (options$factorAxis == "") "Total" else options$factorAxis
  axisTitles <- ggplot2::labs(x = xTitle, y = inputVariable)

  yAxis <- if (options$customLimits == FALSE) {
    yBreaks <- jaspGraphs::getPrettyAxisBreaks(variableVector)
    yLimits <- range(c(yBreaks, variableVector))
    ggplot2::scale_y_continuous(breaks = yBreaks, limits = yLimits)
  } else {
    yLimits <- c(options$lowerLimit, options$upperLimit)
    ggplot2::scale_y_continuous(limits = yLimits, n.breaks = options$customBreaks)
  }

  inwardTicks <- ggplot2::theme(axis.ticks.length = ggplot2::unit(-0.25, "cm"))

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



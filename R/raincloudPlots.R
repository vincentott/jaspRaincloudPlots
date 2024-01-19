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


# Main function: raincloudPlouts() ----
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

    factor <- if (options$factor == "") c() else options$factor
    covariate <- if (options$covariate == "") c() else options$covariate

    output <- .readDataSetToEnd(
      columns.as.numeric = c(options$variables, covariate),
      columns.as.factor = factor,
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
      c("factor", "covariate", "horizontal", "paletteFill", "palettePoints")
    )
  }

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

    plotWidth <- if (options$covariate == "") 450 else 675
    variablePlot <- createJaspPlot(title = variable, width = plotWidth, height = 450)
    variablePlot$dependOn(optionContainsValue = list(variables = variable))  # Depends on respective variable

    .rainFillPlot(variablePlot, dataset, options, variable)

    container[[variable]] <- variablePlot
  }  # End for loop

}  # End .rainCreatePlots()


# .rainFillPlot() ----
.rainFillPlot <- function(inputPlot, dataset, options, inputVariable) {

  # Transform to data.frame() - required for ggplot
  variableVector <- dataset[[inputVariable]]
  group <- .rainSplit(dataset, options, variableVector)
  covariateVector <- if (options$covariate == "") {
    rep(NA, length(variableVector))
  } else {
    dataset[[options$covariate]]
  }
  df <- data.frame(variableVector, group, covariateVector)

  # Arguments geom_rain()
  argAlpha <- .5
  argCov <- if (options$covariate == "") NULL else argCov <- "covariateVector"  # argCov in geom_rain() must be string
  # Likert argument does not work because of ggpp:position_jitternudge()

  # Basic ggplot
  plot <- ggplot2::ggplot(df, ggplot2::aes(x = group, y = variableVector, fill = group, color = group))

  # Geom_rain()
  plot <- plot + ggrain::geom_rain(

    cov = argCov,

    # Black contours for box and violin
    # Alpha set for each anew as .args arguments discard defaults, see ggrain vignette
    boxplot.args = list(color = "black", outlier.shape = NA, alpha = argAlpha),
    violin.args = list(color = "black", alpha = argAlpha),
    point.args = list(alpha = argAlpha),

    # Positioning
    rain.side = "r",  # Necessary to specify for neat positioning to work, even though it is the default
    point.args.pos = list(
      position = ggpp::position_jitternudge(
        nudge.from = "original.y",
        x = -0.14,  # Nudge
        width = .065,  # Jitter
        seed = 1  # Reproducible jitter
      )
    ),
    boxplot.args.pos = list(width = 0.0625, position = ggplot2::position_nudge(x = 0)),
    violin.args.pos = list(width = 0.7, position = ggplot2::position_nudge(x = 0.07)),

  )  # End geom_rain()

  # Theme
  legendPosition <- if (options$covariate == "") "none" else "right"
  plot <- plot + jaspGraphs::geom_rangeframe() + jaspGraphs::themeJaspRaw(legend.position = legendPosition)

  covLegend <- if (options$covariate != "") ggplot2::guides(color = "colorbar", fill = "none") else NULL

  xTitle <- if (options$factor == "") "Total" else options$factor
  axisTitles <- ggplot2::labs(x = xTitle, y = inputVariable)

  yBreaks <- jaspGraphs::getPrettyAxisBreaks(variableVector)
  yLimits <- range(c(yBreaks, variableVector))
  yPretty <- ggplot2::scale_y_continuous(breaks = yBreaks, limits = yLimits)

  inwardTicks <- ggplot2::theme(axis.ticks.length = ggplot2::unit(-0.25, "cm"))

  plot <- plot + covLegend + axisTitles + yPretty + inwardTicks

  # Colors
  paletteFill <- options$paletteFill
  fillScale <- jaspGraphs::scale_JASPfill_discrete(paletteFill)
  colorScale <- if (options$covariate == "") {
    jaspGraphs::scale_JASPcolor_discrete(paletteFill)
  } else {
    # jaspGraphs::scale_JASPcolor_continuous(options$palettePoints)
    ggplot2::scale_color_viridis_c(option =  "H", name = options$covariate)#   Name sets legend title
  }
  plot <- plot + fillScale + colorScale

  # Horizontal
  coordFlip <- if (options$horizontal) ggplot2::coord_flip() else NULL
  # Depending on horizontal: If no factor, blank text and ticks for one axis
  noFactorBlankAxis <- if (options$factor == "") {
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


# .rainSplit() ----
# Splits observations into groups depending on factor option
# if no factor option, all same group
.rainSplit <- function(dataset, options, variableVector) {

  if (options$factor == "") {
    group <- factor(rep("Total", length(variableVector)))
  } else {
    group <- as.factor(dataset[[options$factor]])
  }

  return(group)
}  # End .rainSplit()

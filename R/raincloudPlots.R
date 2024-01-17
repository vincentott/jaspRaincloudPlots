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
  .rainSimplePlots(jaspResults, dataset, options, ready)

}  # End raincloudPlots()


# .rainReadData() ----
.rainReadData <- function(dataset, options) {

  output = NULL

  if(!is.null(dataset)) {
    output = dataset
  } else {

    numericVariables = options[["variables"]]
    splitVariable = options[["splitBy"]]
    if (splitVariable == "") splitVariable = c()
    output <- .readDataSetToEnd(columns.as.numeric = numericVariables, columns.as.factor = splitVariable)

  }

  return(output)
} # End .rainReadData()


# .rainSimplePlots() ----
.rainSimplePlots <- function(jaspResults, dataset, options, ready) {

  if(!options[["simplePlots"]]) return()

  # Create container in jaspResults
  if (is.null(jaspResults[["containerSimplePlots"]])) {
    jaspResults[["containerSimplePlots"]] <- createJaspContainer(title = gettext("Simple Plots"))
    jaspResults[["containerSimplePlots"]]$dependOn(c("simplePlots", "splitBy", "horizontal", "yJitter", "colorPalette"))
  }

  # Access through container object
  container <- jaspResults[["containerSimplePlots"]]

  # Placeholder plot, if no variables
  if (!ready) {
    container[["placeholder"]] <- createJaspPlot(title = "", dependencies = c("variables"))
    return()
  }

  # Plot for each variable
  for (variable in options[["variables"]]) {

    # If plot for variable already exists, we can skip recalculating plot
    if (!is.null(container[[variable]])) next

    variablePlot <- createJaspPlot(title = variable, width = 320, height = 320)
    variablePlot$dependOn(optionContainsValue = list(variables = variable))  # Depends on respective variable

    .rainFillPlot(variablePlot, dataset, options, variable)

    container[[variable]] <- variablePlot
  }  # End for loop

}  # End .rainMakePlot()


# .rainFillPlot() ----
.rainFillPlot <- function(inputPlot, dataset, options, inputVariable) {

  # Transform to data.frame() - required for ggplot
  variableVector <- dataset[[inputVariable]]
  group <- .rainSplit(dataset, options, variableVector)
  df <- data.frame(variableVector, group)

  # Basic plot
  filledPlot <- ggplot2::ggplot(
    df,
    ggplot2::aes(
      x = group,
      y = variableVector,
      fill = group,
      color = group
    )
  )

  # Coloring
  colorPalette <- options[["colorPalette"]]
  filledPlot = filledPlot + ggplot2::theme_classic() +
    jaspGraphs::scale_JASPfill_discrete(colorPalette) +
    jaspGraphs::scale_JASPcolor_discrete(colorPalette)

  # Geom_rain()
  filledPlot = filledPlot + ggrain::geom_rain(

    # Black contours
    # Alpha set for each anew as .args argument discards defaults, see ggrain vignette
    boxplot.args = list(color = "black", outlier.shape = NA, alpha = .5),
    violin.args = list(color = "black", alpha = .5),
    point.args = list(alpha = .5),

    # Neat positioning
    rain.side = "r",  # Necessary to specify for neat positioning to work, even though it is the default
    boxplot.args.pos = list(width = 0.0625, position = ggplot2::position_nudge(x = 0.13)),
    violin.args.pos = list(width = 0.7, position = ggplot2::position_nudge(x = 0.2)),

    likert = options[["yJitter"]]

  )

  # Axes
  if (options[["horizontal"]]) filledPlot = filledPlot + ggplot2::coord_flip()

  filledPlot = filledPlot + ggplot2::theme(legend.position = "none")

  if (options[["splitBy"]] == "") {

    filledPlot = filledPlot + ggplot2::xlab("Total")
    if (!options[["horizontal"]]) {
      filledPlot = filledPlot + ggplot2::theme(axis.text.x = ggplot2::element_blank()) +
                                ggplot2::theme(axis.ticks.x = ggplot2::element_blank())
    } else {
      filledPlot = filledPlot + ggplot2::theme(axis.text.y = ggplot2::element_blank()) +
                                ggplot2::theme(axis.ticks.y = ggplot2::element_blank())
    }

  } else {
    filledPlot = filledPlot + ggplot2::xlab(options[["splitBy"]])
  }

  filledPlot = filledPlot + ggplot2::ylab(inputVariable) +
    ggplot2::theme(axis.ticks.length = ggplot2::unit(-0.15, "cm"))  # Inward ticks

  # Assign to input
  inputPlot[["plotObject"]] <- filledPlot
}  # End .rainFillPlot()


# .rainSplit() ----
# Splits observations into groups depending on splitBy option
# if no splitBy option, all same group
.rainSplit <- function(dataset, options, variable_vector) {

  if (options[["splitBy"]] == "") {
    group <- factor(rep("Total", length(variable_vector)))
  } else {
    group <- as.factor(dataset[[options$splitBy]])
  }

  return(group)
}  # End .rainSplit()

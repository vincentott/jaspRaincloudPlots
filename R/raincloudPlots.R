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
    jaspResults[["containerSimplePlots"]]$dependOn(c("simplePlots", "splitBy", "horizontal", "flipped"))
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
  }

}  # End .rainMakePlot()


# .rainFillPlot() ----
.rainFillPlot <- function(inputPlot, dataset, options, inputVariable) {

  # Transform to data.frame() - required for ggplot
  variableVector <- dataset[[inputVariable]]
  group <- .rainSplit(dataset, options, variableVector)
  df <- data.frame(variableVector, group)

  # Arguments aes()
  # x = group

  # Arguments geom_rain()
  if (!options[["flipped"]]) side <- "r" else side <- "l"

  # Basic plot
  filling <- ggplot2::ggplot(
    df,
    ggplot2::aes(
      x = group,
      y = variableVector,
      fill = group,
      color = group
    )
  )

  # Geom_rain()
  filling = filling + ggrain::geom_rain(
    alpha = .50,
    rain.side = side
    # # Neat positioning
    # boxplot.args.pos = list(width = .075, position = ggplot2::position_nudge(x = 0)),
    # violin.args.pos = list(width = .70, position = ggplot2::position_nudge(x = 0.05))
  )

  ### Aesthetic settings
  filling = filling + ggplot2::theme_classic() +
    ggplot2::scale_fill_brewer(palette = "Dark2") +
    ggplot2::scale_color_brewer(palette = "Dark2")

  if (options[["horizontal"]]) filling = filling + ggplot2::coord_flip()

  filling = filling + ggplot2::ylab(inputVariable)

  # # X and y axis
  # if (options[["splitBy"]] == "") {
  #   filling = filling + ggplot2::xlab("Total") +
  #     ggplot2::theme(axis.text.x = ggplot2::element_blank(), axis.ticks.x = ggplot2::element_blank())
  # } else {
  #   filling = filling + ggplot2::xlab(options[["splitBy"]])
  # }

  # Assign to input
  inputPlot[["plotObject"]] <- filling
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

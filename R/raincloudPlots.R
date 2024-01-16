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

  # Macroscopic object in jaspResults
  if (is.null(jaspResults[["containerSimplePlots"]])) {
    jaspResults[["containerSimplePlots"]] <- createJaspContainer(title = gettext("Simple Plots"))
    jaspResults[["containerSimplePlots"]]$dependOn(c("simplePlots", "variables", "splitBy"))
  }

  # Microscopic object used subsequently
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

    variablePlot <- createJaspPlot(title = variable)
    variablePlot$dependOn(optionContainsValue = list(variables = variable))  # Depends on respective variable

    .rainFillPlot(variablePlot, dataset, options, variable)

    container[[variable]] <- variablePlot

  }

}  # End .rainMakePlot()


# .rainFillPlot() ----
.rainFillPlot <- function(input_plot, dataset, options, input_variable) {

  # Transform to data.frame() format - required for ggplot
  variable_vector <- dataset[[input_variable]]
  group <- .rainSplit(dataset, options, variable_vector)
  df <- data.frame(variable_vector)

  # Arguments for aes()
  # x = group

  # Arguments for geom_rain()
  if (!options[["flipped"]]) side <- "r" else side <- "l"

  # Make basic plot
  filling <- ggplot2::ggplot(
    df,
    ggplot2::aes(
      x = group,
      y = variable_vector,
      fill = group
      )  # End aes()
    ) +  # End ggplot()
    ggrain::geom_rain(
      alpha = .5,
      rain.side = side
    )  # End geom_rain()

  # Finetuning additional settings
  filling = filling + ggplot2::xlab(options[["splitBy"]])
  filling = filling + ggplot2::scale_fill_brewer(palette = 'Dark2')
  filling = filling + ggplot2::theme_classic()
  filling = filling + ggplot2::ylab(input_variable)
  if (options[["horizontal"]]) filling = filling + ggplot2::coord_flip()

  # Assign to input
  input_plot[["plotObject"]] <- filling

}  # End .rainFillPlot()


# .rainSplit() ----
# Splits observations into groups depending on split input
# if there is no split variable, all observations are assigned to the same group
.rainSplit <- function(dataset, options, variable_vector) {

  if (options[["splitBy"]] == "") {
    group <- factor(rep("Total", length(variable_vector)))
  } else {
    group <- as.factor(dataset[[options$splitBy]])
  }

  return(group)
}  # End .rainSplit()

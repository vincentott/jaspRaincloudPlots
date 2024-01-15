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
    num_var = options[["variables"]]
    split_var = options[["splitBy"]]
    if (split_var == "") split_var = c()
    output <- .readDataSetToEnd(columns.as.numeric = num_var, columns.as.factor = split_var)
  }

  return(output)
} # End .rainReadData()


# .rainSimplePlots() ----
.rainSimplePlots <- function(jaspResults, dataset, options, ready) {  # Add ready

  if(!options[["simplePlots"]]) return()


  # Add if (is.null(jaspResults[["simplePlots"]])) { or something like that

  depends = c("simplePlots", "variables", "splitBy")

  container <- createJaspContainer(title = "Simple Plots", dependencies = depends)

  if (!ready) {  # When no variables are selected, a placeholder plot is created
    container[["placeholder"]] <- createJaspPlot(title = "", dependencies = c("simplePlots"))
  }

  for (variable in options[["variables"]]) {

    # If plot for variable already exists, we can skip recalculating plot
    if (!is.null(container[[variable]])) next

    current_plot <- createJaspPlot(title = variable, dependencies = depends)
    .rainFillPlot(current_plot, dataset, options, variable)

    container[[variable]] <- current_plot

  }

  jaspResults[["simplePlots"]] <- container

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

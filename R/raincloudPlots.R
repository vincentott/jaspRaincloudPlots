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

  if(!is.null(dataset)) {
    return(dataset)
  } else {
    return(.readDataSetToEnd(columns.as.numeric = options$variables))
  }

} # End .rainReadData()


# .rainSimplePlots() ----
.rainSimplePlots <- function(jaspResults, dataset, options, ready) {  # Add ready

  if(!options[["simplePlots"]]) return()


  # Add if (is.null(jaspResults[["simplePlots"]])) { or something like that


  container <- createJaspContainer(title = "Simple Plots")

  if (!ready) {  # When no variables are selected, a placeholder plot is created
    container[["placeholder"]] <- createJaspPlot(title = "", dependencies = c("simplePlots", "variables"))
  }

  for (variable in options[["variables"]]) {

    # If plot for variable already exists, we can skip recalculating plot
    if (!is.null(container[[variable]])) next

    current_plot <- createJaspPlot(title = variable, dependencies = c("simplePlots", "variables"))
    .rainFillPlot(current_plot, dataset, variable)

    container[[variable]] <- current_plot

  }

  jaspResults[["simplePlots"]] <- container

}  # End .rainMakePlot()


# Fill plot ----
.rainFillPlot <- function(input_plot, dataset, variable) {

  # Tranform to data.frame() format - required for ggplot
  variable <- dataset[[variable]]
  df <- data.frame(variable)

  filling <- ggplot2::ggplot(
    df,
    ggplot2::aes(1, variable)) +
    ggrain::geom_rain() +
    ggplot2::theme_classic()

  input_plot$plotObject <- filling

}  # End .rainFillPlot()


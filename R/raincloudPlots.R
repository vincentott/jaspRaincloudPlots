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


# Main function ----
raincloudPlots <- function(jaspResults, dataset, options) {

  ready <- (length(options$variables) > 0)
  if (ready) {
    dataset <- .readDataSetToEnd(columns.as.numeric = options$variables)

    if (is.null(jaspResults[["raincloudPlot"]])) {
      .createRaincloudPlot(jaspResults, dataset, options, ready)
    }
  }

}  # End raincloudPlots


# Create plot ----
.createRaincloudPlot <- function(jaspResults, dataset, options, ready) {  # Add ready

  if (ready && options$myCheckbox) {

    variable_name = options$variables[1]
    raincloudPlot <- createJaspPlot(title = variable_name)

    raincloudPlot$dependOn(c("variables","myCheckbox"))

    jaspResults[["raincloudPlot"]] <- raincloudPlot

    .fillRaincloudPlot(raincloudPlot, dataset, variable_name)
  }

}  # End .createRaincloudPlot


# Fill plot ----
.fillRaincloudPlot <- function(raincloudPlot, dataset, variable_name) {

  # variable <- rnorm(50)
  # df <- data.frame(variable)
  # ggplot2::ggplot(df, aes(1, variable)) +
  #   geom_rain()

  # plot <- ggplot2::qplot(dataset[[variable]]) +
  #   ggplot2::xlab("")
  # raincloudPlot$plotObject <- plot

  variable <- dataset[[variable_name]]
  df <- data.frame(variable)

  plot <- ggplot2::ggplot(
    df,
    ggplot2::aes(1, variable, fill = variable_name)) +
    ggrain::geom_rain() +
    ggplot2::theme_classic() +
    ggplot2::scale_fill_brewer(palette = "Dark2")

  raincloudPlot$plotObject <- plot

}  # End .fillRaincloudPlot


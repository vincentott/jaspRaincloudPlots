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


raincloudPlots <- function(jaspResults, dataset, options) {

  # ready <- (length(options$variables) > 0)
  #
  # if (ready) {
  #   dataset <- .readDataSetToEnd(dataset, options)
  # }

  # Sanity Check with table
  if (is.null(jaspResults[["myTable"]])) {
    NULL
  }

  if (is.null(jaspResults[["raincloudPlot"]])) {
    .createRaincloudPlot(jaspResults, dataset, options)  # Add ready
  }

  if (options$myCheckbox) {
    if (is.null(jaspResults[["myText"]])) {
      myText <- createJaspHtml(text = gettextf("This is a public service announcement."))
      jaspResults[["myText"]] <- myText
    }
  }

  return()

}  # End raincloudPlots


.createRaincloudPlot <- function(jaspResults, dataset, options) {  # Add ready

  raincloudPlot <- createJaspPlot(title = "Look at that cloud!", width = 160, height = 320)
  # raincloudPlot$dependOn(c("myCheckbox"))

  jaspResults[["raincloudPlot"]] <- raincloudPlot

  # if (ready) {
  #   .fillRaincloudPlot(raincloudPlot, dataset, options)
  # }
  .fillRaincloudPlot(raincloudPlot, dataset, options)

  return()

}  # End .createRaincloudPlot


.fillRaincloudPlot <- function(raincloudPlot, dataset, options) {

  plot <- ggplot2::qplot(rnorm(100))
  raincloudPlot$plotObject <- plot

}  # End .fillRaincloudPlot

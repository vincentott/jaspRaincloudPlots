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
    output <- dataset
  } else {

    numericVariables <- options[["variables"]]
    splitVariable <- options[["splitBy"]]
    if (splitVariable == "") splitVariable <- c()
    covariate <- options[["covariate"]]
    if (covariate == "") covariate <- c()
    output <- .readDataSetToEnd(
      columns.as.numeric = c(numericVariables, covariate),
      columns.as.factor = splitVariable,
      )
  }

  return(output)
} # End .rainReadData()


# .rainSimplePlots() ----
.rainSimplePlots <- function(jaspResults, dataset, options, ready) {

  if(!options[["simplePlots"]]) return()

  # Create container in jaspResults
  if (is.null(jaspResults[["containerSimplePlots"]])) {
    jaspResults[["containerSimplePlots"]] <- createJaspContainer(title = gettext("Simple Plots"))
    jaspResults[["containerSimplePlots"]]$dependOn(
      c("simplePlots", "splitBy", "covariate", "horizontal", "colorPalette")
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
  for (variable in options[["variables"]]) {

    # If plot for variable already exists, we can skip recalculating plot
    if (!is.null(container[[variable]])) next

    variablePlot <- createJaspPlot(title = variable, width = 450, height = 450)
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
  if (options[["covariate"]] == "") {
    covariateVector <- rep(NA, length(variableVector))
  } else {
    covariateVector <- dataset[[options[["covariate"]]]]
  }
  df <- data.frame(variableVector, group, covariateVector)

  # Arguments geom_rain()
  argAlpha <- .5
  if (options[["covariate"]] == "") argCov <- NULL else argCov <- "covariateVector"
  # Likert argument does not work because of ggpp:position_jitternudge()

  # Basic ggplot
  filledPlot <- ggplot2::ggplot(
    df,
    ggplot2::aes(x = group, y = variableVector, fill = group, color = group)
  )

  # Coloring
  # before geom_rain() to set black contours afterwards within geom_rain()
  colorPalette <- options[["colorPalette"]]
  filledPlot <- filledPlot + ggplot2::theme_classic() +
    jaspGraphs::scale_JASPfill_discrete(colorPalette) +
    jaspGraphs::scale_JASPcolor_discrete(colorPalette)
  if (!options[["covariate"]] == "") {
    filledPlot <- filledPlot + ggplot2::scale_color_viridis_c(
      option =  "A", direction = 1, name = options[["covariate"]]  # Name sets title for legend
      )
  }

  # Geom_rain()
  filledPlot <- filledPlot + ggrain::geom_rain(

    cov = argCov,

    # Black contours
    # Alpha set for each anew as .args argument discards defaults, see ggrain vignette
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
        seed = 1  # For reproducible jitter
      )
    ),
    boxplot.args.pos = list(
      width = 0.0625, position = ggplot2::position_nudge(x = 0)
    ),
    violin.args.pos = list(
      width = 0.7, position = ggplot2::position_nudge(x = 0.07)
    ),

  )  # End geom_rain()

  # Axis Titles
  if (options[["splitBy"]] == "") xTitle <- "Total" else xTitle <- options[["splitBy"]]
  filledPlot <- filledPlot + ggplot2::labs(x = xTitle, y = inputVariable)

  # Theme
  if (options[["covariate"]] == "") {
    argLegPosition <- "none"
  } else {
    argLegPosition <- "right"
    filledPlot <- filledPlot + ggplot2::guides(color = "colorbar", fill = "none")
  }
  filledPlot <- filledPlot + ggplot2::theme(
    axis.title = ggplot2::element_text(size = 14),
    axis.text = ggplot2::element_text(size = 13, color = "black"),
    axis.ticks.length = ggplot2::unit(-0.15, "cm"),  # Inward ticks
    legend.position = argLegPosition
  )



  # Horizontal
  if (options[["horizontal"]]) filledPlot = filledPlot + ggplot2::coord_flip()
  # Blank text and ticks for one axis without splitBy - depending on horizontal
  if (options[["splitBy"]] == "") {
    if (!options[["horizontal"]]) {
      filledPlot <- filledPlot + ggplot2::theme(
        axis.text.x = ggplot2::element_blank(),
        axis.ticks.x = ggplot2::element_blank()
      )
    } else {
      filledPlot <- filledPlot + ggplot2::theme(
        axis.text.y = ggplot2::element_blank(),
        axis.ticks.y = ggplot2::element_blank()
      )
    }
  }

  # Assign to inputPlot
  inputPlot[["plotObject"]] <- filledPlot
}  # End .rainFillPlot()


# .rainSplit() ----
# Splits observations into groups depending on splitBy option
# if no splitBy option, all same group
.rainSplit <- function(dataset, options, variable_vector) {

  if (options[["splitBy"]] == "") {
    group <- factor(rep("Total", length(variable_vector)))
  } else {
    group <- as.factor(dataset[[options[["splitBy"]]]])
  }

  return(group)
}  # End .rainSplit()

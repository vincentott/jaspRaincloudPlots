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

    numericVariables <- options$variables
    factorVariable <- options$factor
    if (factorVariable == "") factorVariable <- c()
    covariate <- options$covariate
    if (covariate == "") covariate <- c()
    output <- .readDataSetToEnd(
      columns.as.numeric = c(numericVariables, covariate),
      columns.as.factor = factorVariable,
      )
  }

  return(output)
} # End .rainReadData()


# .rainSimplePlots() ----
.rainSimplePlots <- function(jaspResults, dataset, options, ready) {

  if(!options$simplePlots) return()

  # Create container in jaspResults
  if (is.null(jaspResults[["containerSimplePlots"]])) {
    jaspResults[["containerSimplePlots"]] <- createJaspContainer(title = gettext("Simple Plots"))
    jaspResults[["containerSimplePlots"]]$dependOn(
      c("simplePlots", "factor", "covariate", "horizontal", "colorPalette")
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
  if (options$covariate == "") {
    covariateVector <- rep(NA, length(variableVector))
  } else {
    covariateVector <- dataset[[options$covariate]]
  }
  df <- data.frame(variableVector, group, covariateVector)

  # Arguments geom_rain()
  argAlpha <- .5
  if (options$covariate == "") argCov <- NULL else argCov <- "covariateVector"  # argCov in geom_rain() must be string
  # Likert argument does not work because of ggpp:position_jitternudge()

  # Basic ggplot
  plot <- ggplot2::ggplot(
    df,
    ggplot2::aes(x = group, y = variableVector, fill = group, color = group)
  )

  # Geom_rain()
  plot <- plot + ggrain::geom_rain(

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
        seed = 1  # Reproducible jitter
      )
    ),
    boxplot.args.pos = list(width = 0.0625, position = ggplot2::position_nudge(x = 0)),
    violin.args.pos = list(width = 0.7, position = ggplot2::position_nudge(x = 0.07)),

  )  # End geom_rain()

  # Theme
  yBreaks <- jaspGraphs::getPrettyAxisBreaks(variableVector)
  yLimits <- range(c(yBreaks, variableVector))
  plot <- plot + ggplot2::scale_y_continuous(breaks = yBreaks, limits = yLimits)

  if (options$factor == "") xTitle <- "Total" else xTitle <- options$factor      # Axis Title
  plot <- plot + ggplot2::labs(x = xTitle, y = inputVariable)
  if (options$covariate == "") {                                                 # Legend
    argLegPos <- "none"
  } else {
    argLegPos <- "right"
    plot <- plot + ggplot2::guides(color = "colorbar", fill = "none")
  }
  plot <- plot + jaspGraphs::geom_rangeframe() +
    jaspGraphs::themeJaspRaw(
      legend.position = argLegPos
    )
  plot <- plot + ggplot2::theme(
    axis.ticks.length = ggplot2::unit(-0.25, "cm"),  # Inward ticks
    plot.margin = ggplot2::margin(3, 0, 0, 0, "pt")
  )

  colorscale <- if (options$covariate != "")
    jaspGraphs::scale_JASPcolor_continuous(colorPalette)
  else
    jaspGraphs::scale_JASPcolor_discrete(colorPalette)
  # Colors
  colorPalette <- options$colorPalette
  plot <- plot +
    jaspGraphs::scale_JASPfill_discrete(colorPalette) +
    colorscale
  # if (!options$covariate == "") {
  #   plot <- plot + jaspGraphs::scale_color_viridis_c(
  #     option =  "H", name = options$covariate  # Name sets legend title
  #   )
  # }

  # Horizontal
  if (options$horizontal) plot = plot + ggplot2::coord_flip()
  # Blank text and ticks for one axis without factor - depending on horizontal
  if (options$factor == "") {
    if (!options$horizontal) {
      plot <- plot + ggplot2::theme(
        axis.text.x = ggplot2::element_blank(),
        axis.ticks.x = ggplot2::element_blank()
      )
    } else {
      plot <- plot + ggplot2::theme(
        axis.text.y = ggplot2::element_blank(),
        axis.ticks.y = ggplot2::element_blank()
      )
    }
  }

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

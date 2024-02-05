
# larksOwls <- read.csv("jaspLarksOwls.csv")
# larksOwls <- subset(larksOwls, Chronotype != "Intermediate")
# larksOwls$TimeOfDay <- factor(larksOwls$TimeOfDay, levels = c("Morning", "Evening"))  # re-order for better understanding
# larksOwls$Chronotype <- factor(larksOwls$Chronotype, levels = c("Morning", "Evening"))
# larksOwls <- larksOwls[larksOwls$Subject %in% c(1, 4, 6, 8), ]
subjectVector <- c()
for (i in 1:4) subjectVector <- c(subjectVector, rep(i, 2))
larksOwls$Subject <- subjectVector
larksOwls$Subject <- as.factor(larksOwls$Subject)
larksOwls <- larksOwls[ , c("Subject", "Chronotype", )]

# 2x2 ----
myTest <- function() {
  options <- jaspTools::analysisOptions("raincloudPlots")
  options$variables <- "MWCount"
  options$factorAxis <- "TimeOfDay"
  options$factorFill <- "Chronotype"
  options$paletteFill <- "colorblind"
  options$colorAnyway <- FALSE    # colorAnyway must be disabled if factorFill input; done in .qml file

  # Remove violins and boxes
  options$boxOpacity <- 0
  options$boxEdges <- "none"
  options$vioOpacity <- 0
  options$vioEdges <- "none"

  options$pointWidth <- 0


  options$covariate <- "Subject"
  options$palettePoints <- "ggplot2"
  options$pointOpacity <- 1

  # options$subject <- "Subject"

  options$pointNudge <- 0.15
  options$customSides <- TRUE
  options$sidesInput <- "LR"

  debugonce(jaspRaincloudPlots:::rainFillPlot)
  results <- jaspTools::runAnalysis("raincloudPlots", larksOwls, options)
}
myTest()




larksOwls <- read.csv("jaspLarksOwls.csv")
larksOwls <- subset(larksOwls, Chronotype != "Intermediate")
larksOwls$TimeOfDay <- factor(larksOwls$TimeOfDay, levels = c("Morning", "Evening"))  # re-order for better understanding
larksOwls$Chronotype <- factor(larksOwls$Chronotype, levels = c("Morning", "Evening"))

# No Factors + color ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "MWCount"
options$factorAxis <- "TimeOfDay"
options$factorFill <- "Chronotype"
options$subject <- "Subject"
options$paletteFill <- "colorblind"
options$colorAnyway <- TRUE
options$linesSubject <- TRUE
# debugonce(jaspRaincloudPlots:::.rainFillPlot)
results <- jaspTools::runAnalysis("raincloudPlots", larksOwls, options)

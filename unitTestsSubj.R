
larksOwls <- read.csv("jaspLarksOwls.csv")
larksOwls <- subset(larksOwls, Chronotype != "Intermediate")
larksOwls$TimeOfDay <- factor(larksOwls$TimeOfDay, levels = c("Morning", "Evening"))  # re-order for better understanding
larksOwls$Chronotype <- factor(larksOwls$Chronotype, levels = c("Morning", "Evening"))

# 2x2 ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "MWCount"
options$factorAxis <- "TimeOfDay"
options$factorFill <- "Chronotype"
options$paletteFill <- "colorblind"
options$subject <- "Subject"
options$customSides <- TRUE
options$sidesInput <- "LLRR"
# debugonce(jaspRaincloudPlots:::.rainFillPlot)
results <- jaspTools::runAnalysis("raincloudPlots", larksOwls, options)

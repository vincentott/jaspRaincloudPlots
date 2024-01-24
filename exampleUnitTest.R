
library(palmerpenguins)
data(package = "palmerpenguins")
View(penguins)


options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$factorAxis <- "species"
options$paletteFill <- "colorblind"
options$colorAnyway <- TRUE
results <- jaspTools::runAnalysis("raincloudPlots", penguins, options)


# # No Factor ----
# options <- jaspTools::analysisOptions("raincloudPlots")
# options$variables <- "bill_length_mm"
# # options$paletteFill <- "colorblind"
# options$horizontal <- FALSE
# results <- jaspTools::runAnalysis("raincloudPlots", penguins, options)
#
# # Factor ----
# options <- jaspTools::analysisOptions("raincloudPlots")
# options$variables <- "bill_length_mm"
# options$factorFill <- "species"
# options$paletteFill <- "colorblind"
# debugonce(jaspRaincloudPlots:::.rainFillPlot)
# results <- jaspTools::runAnalysis("raincloudPlots", penguins, options)
#
# # Factor and Covariate ----
# options <- jaspTools::analysisOptions("raincloudPlots")
# options$variables <- "bill_length_mm"
# options$factor <- "species"
# options$paletteFill <- "colorblind"
# options$horizontal <- FALSE
# options$covariate <- "bill_depth_mm"
# results <- jaspTools::runAnalysis("raincloudPlots", penguins, options)

# Storage ----
# debugonce(jaspRaincloudPlots:::.rainReadData)
# results <- jaspTools::runAnalysis("raincloudPlots", "debug.csv", options)
# results[["state"]][["figures"]][[1]][["obj"]]

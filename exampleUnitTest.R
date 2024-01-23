
library(palmerpenguins)
data(package = "palmerpenguins")
View(penguins)

# No Factor ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
# options$paletteFill <- "colorblind"
options$horizontal <- FALSE
debugonce(jaspRaincloudPlots:::.rainFillPlot)
results <- jaspTools::runAnalysis("raincloudPlots", penguins, options)

# Factor ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$factor <- "species"
options$paletteFill <- "colorblind"
results <- jaspTools::runAnalysis("raincloudPlots", penguins, options)

# Factor and Covariate ----
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "bill_length_mm"
options$factor <- "species"
options$paletteFill <- "colorblind"
options$horizontal <- FALSE
options$covariate <- "bill_depth_mm"
results <- jaspTools::runAnalysis("raincloudPlots", penguins, options)

# Storage ----
# debugonce(jaspRaincloudPlots:::.rainReadData)
# results <- jaspTools::runAnalysis("raincloudPlots", "debug.csv", options)
# results[["state"]][["figures"]][[1]][["obj"]]

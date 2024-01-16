
options <- jaspTools::analysisOptions("raincloudPlots")
options$variables <- "contNormal"
# options$splitBy <- "facGender"
options$simplePlots <- TRUE

debugonce(jaspRaincloudPlots:::.rainReadData)
results <- jaspTools::runAnalysis("raincloudPlots", "debug.csv", options)


# results <- jaspTools::runAnalysis("raincloudPlots", "debug.csv", options)
# results[["state"]][["figures"]][[1]][["obj"]]


ggplot(iris, aes(Species, Sepal.Width, fill = Species)) +
  geom_rain(alpha = .5) +
  theme_classic() +
  scale_fill_brewer(palette = 'Dark2') +
  guides(fill = 'none', color = 'none') +
  coord_flip()
#
#
# ggplot(iris, aes(Species, Sepal.Width, fill = Species)) +
#   geom_rain(alpha = .5) +
#   theme_classic() +
#   scale_fill_brewer(palette = 'Dark2') +
#   coord_flip()


# Storage ----

# variable <- rnorm(50)
# df <- data.frame(variable)
# ggplot2::ggplot(df, aes(1, variable)) +
#   geom_rain()

# plot <- ggplot2::qplot(dataset[[variable]]) +
#   ggplot2::xlab("")
# raincloudPlot$plotObject <- plot

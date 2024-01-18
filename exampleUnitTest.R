
options <- jaspTools::analysisOptions("raincloudPlots")
options$colorPalette <- "colorblind"
options$simplePlots <- TRUE
options$variables <- "contNormal"
options$horizontal <- FALSE
options$splitBy <- "facExperim"

results <- jaspTools::runAnalysis("raincloudPlots", "debug.csv", options)

# results <- jaspTools::runAnalysis("raincloudPlots", "debug.csv", options)
# results[["state"]][["figures"]][[1]][["obj"]]

ggplot(iris, aes(Species, Sepal.Width, fill = Species)) +
  geom_rain(alpha = .5) +
  theme_classic() +
  scale_fill_brewer(palette = 'Dark2') +
  guides(fill = 'none', color = 'none') +
  coord_flip()

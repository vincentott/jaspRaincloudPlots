
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

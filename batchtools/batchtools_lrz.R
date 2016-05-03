#setwd("~/Arbeit/batchtools_test/")

library(batchtools)

reg = makeRegistry(file.dir = "test")


xs = 1:100


batchMap(function(i) {
  x = sample(1:100, 1)
  print("do it")
  rnorm(100)
  Sys.sleep(x)
  if (x %% 5 == 0) {
    stop("BOOM!")
  }
  x
}, xs)

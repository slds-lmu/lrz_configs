library(batchtools)

reg = makeRegistry(file.dir = "test")

reg$default.resources = list(
  walltime = 60L,
  memory = 128L,
  ntasks = 1L,
  ncpus = 1L,
  nodes = 1L,
  clusters = "serial")


xs = 1:100


batchMap(function(i) {
  x = sample(1:100, 1)
  print("do it")
  Sys.sleep(x)
  if (x %% 5 == 0) {
    stop("BOOM!")
  }
  x^2
}, xs)

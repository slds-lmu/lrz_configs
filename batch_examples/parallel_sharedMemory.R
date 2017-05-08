library(mlr)
library(parallelMap)
library(batchtools)

doStuff = function(i) {

  library(mlr)
  library(parallelMap)
  lrn = makeLearner("classif.xgboost", par.vals = list(nrounds = 50 + i,
                                                       nthread = 1))


  parallelMap::parallelStartMulticore(28)

  rs = makeResampleDesc("CV", iters = 10)

  lrn.list = list(makeLearner("classif.xgboost", par.vals = list(nrounds = 50 + i,
                                                                 nthread = 1)),
                  makeLearner("classif.qda"))

  task.list = list(iris.task)

  x = benchmark(lrn.list, task.list, rs)

  parallelMap::parallelStop()

  x
}


reg = makeRegistry(file.dir = "test_parallel", packages = c("methods"))


reg$default.resources = list(
  walltime = 300L,
  memory = 1024L * 62L,
  ntasks = 1L,
  ncpus = 28L,
  nodes = 1L,
  clusters = "mpp2")

batchMap(doStuff, i = 1:10)

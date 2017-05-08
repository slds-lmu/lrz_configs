library(mlr)
library(parallelMap)
library(Rmpi)
library(batchtools)

doStuff = function(i) {
  
  library(mlr)
  library(parallelMap)
  lrn = makeLearner("classif.xgboost", par.vals = list(nrounds = 50 + i,
                                                       nthread = 1))
  
  
  parallelMap::parallelStartMPI(28)
  
  rs = makeResampleDesc("CV", iters = 20)

  x = resample(learner = lrn, task = iris.task, resampling = rs)
  
  parallelMap::parallelStop()
  
  x
}


reg = makeRegistry(file.dir = "test_file", packages = c("methods"))


reg$default.resources$ntasks = 28

j = 1:100

batchMap(doStuff, j)





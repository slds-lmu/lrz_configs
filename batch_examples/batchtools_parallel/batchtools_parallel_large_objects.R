library(mlr)
library(parallelMap)
library(Rmpi)
library(batchtools)

doStuff = function(i) {
  
  library(mlr)
  library(parallelMap)
  lrn = makeLearner("classif.randomForest", ntree = 1000)
  
  
  
  parallelMap::parallelStartMPI(28)
  
  models = parallelMap(function(x) train(lrn, pid.task), 1:i)
  
  parallelStop()

  
  models
}


reg = makeRegistry(file.dir = "$PROJECT/test_file", packages = c("methods"))


reg$default.resources$ntasks = 28
reg$default.resources$walltime = 90L
reg$default.resources$memory = 1024L

j = 1:28

batchMap(doStuff, j)




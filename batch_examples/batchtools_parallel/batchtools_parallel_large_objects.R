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


path = paste0(system("echo $PROJECT"), "/test_file")

if (file.exists(path)) {
unlink(path)
}

reg = makeRegistry(file.dir = path, packages = c("methods", "mlr"))


reg$default.resources$ntasks = 28
reg$default.resources$walltime = 90L
reg$default.resources$memory = 1024L

j = 1:28

batchMap(doStuff, j)




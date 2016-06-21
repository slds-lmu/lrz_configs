library(mlr)
library(parallelMap)
library(Rmpi)
library(batchtools)

doStuff = function(i) {
  
  library(mlr)
  library(parallelMap)
  
  
  
  
  parallelMap::parallelStartMPI(28)
  
  doTrain = function(x) {
    print(x)
    require(mlr)
    lrn = makeLearner("classif.randomForest", ntree = 1000)
    train(lrn, pid.task)
  }
  
  
  models = parallelMap(doTrain, 1:i)
  
  parallelStop()

  
  models
}


path = "/naslx/projects/ua341/di25koz/test_file"

if (file.exists(path)) {
unlink(path, recursive = TRUE)
}

reg = makeRegistry(file.dir = path, packages = c("methods", "mlr"))


reg$default.resources$ntasks = 28
reg$default.resources$walltime = 90L
reg$default.resources$memory = 1024L

j = 1:28

batchMap(doStuff, j)




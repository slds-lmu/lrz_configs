library(mlr)
library(parallelMap)
library(Rmpi)
library(batchtools)

doStuff = function(i) {
  
  library(mlr)
  library(parallelMap)
  lrn = makeLearner("classif.randomForest", ntree = 1000)
  
  
  
  parallelMap::parallelStartMPI(28)
  
  models = parallelMap(function(x) mlr::train(lrn, mlr::pid.task), 1:i)
  
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




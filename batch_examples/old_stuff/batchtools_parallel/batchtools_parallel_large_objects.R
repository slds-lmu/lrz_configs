library(mlr)
library(parallelMap)
library(Rmpi)
library(batchtools)

doStuff = function(i) {
  
  library(mlr)
  library(parallelMap)
  
  
  
  
  parallelMap::parallelStartMPI(28)
  
  doTrain = function(x, i) {
    print(x)

    #require(mlr)
    #lrn = makeLearner("classif.randomForest", ntree = x*10)
    #m = train(lrn, pid.task)
    
   
    #library(randomForest)
    #library(mlbench)
    #data(PimaIndiansDiabetes)
    #m = randomForest(diabetes ~ ., data = PimaIndiansDiabetes, ntree = x*10)
    #m$terms = NULL
    #m$call = NULL
    #m$inbag = NULL
    #m$localImportance = NULL
    #m$test = NULL
    #m$proximity = NULL
    #m$localImportance = NULL
    #m$importanceSD = NULL
    #m$forest = NULL
   
    #m$forest$xbestsplit = NULL
    #m$forest$treemap = NULL


     m = list(list(y = matrix(1, nrow = 4500, ncol = 1000),  y = 2), z = 12) 
     #m = matrix(1, nrow = 4000, ncol = 1000)

    save(m, file = paste0("/naslx/projects/ua341/di25koz/test_", i, "_", x, ".RData"), compress = 
FALSE)
    return(m)
  }
  
  
  models = parallelMap(doTrain, 1:i, more.args = list(i = i))
  
  parallelStop()

  
  models
}


path = "/naslx/projects/ua341/di25koz/test_file"

if (file.exists(path)) {
unlink(path, recursive = TRUE)
}

reg = makeRegistry(file.dir = path, packages = c("methods", "mlr"))


reg$default.resources$ntasks = 28
reg$default.resources$walltime = 600L
reg$default.resources$memory = 1024L

j = 1:28

batchMap(doStuff, j)




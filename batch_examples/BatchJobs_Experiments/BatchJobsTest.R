library(BatchJobs)

if (!file.exists("reg")) {
 reg = makeRegistry(id = "reg")
} else {
 reg = loadRegistry(file.dir = "reg-files")
}


xs <- 1:50

batchMap(reg, function(i){
  x = sample(1:120, 1)
  Sys.sleep(x)
  if (x %% 10 == 0) {
  stop("Booom!")
  }
  x
}, xs)


ids = getJobIds(reg)


submitJobs(reg, ids, resources = list(walltime = 300L,
                                      memory = 512L))

reduceResultsVector(reg)
reduceResults(reg, fun = function(aggr, job, res) aggr + res)
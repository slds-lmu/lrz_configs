library(mlr)
library(OpenML)
library(batchtools)
library(parallelMap)



### Create registry ###

unlink("svm_tuning", recursive = TRUE)
reg = makeExperimentRegistry(file.dir = "svm_tuning", packages= c("mlr", "OpenML", "parallelMap"))


resources = list(
  walltime = 600L, # 10 Minute runtime per job
  memory = 62 * 1024L,
  ntasks = 1L, # No distributed memory jobs
  ncpus = 16L, # Take all 28 CPUs
  nodes = 1L, # Take one full node
  clusters = "ivymuc" # Specify cluster
  )

### Define and add problem ###


task = convertOMLTaskToMlr(getOMLTask(37))
addProblem(name = getTaskId(task$mlr.task), data = task)




### Define and add algorithm ###

# generic algorithm that gets:
# - an machine learning algorithm
# - a parameter set
# - a tuning control object
# - one or more measure(s).
# A tuneResult will be returned.
addAlgorithm(name = "mlr_tuning", fun = function(job, data, instance, learner, par.set, tune.control, measures) {

  # We specify which kind of parallelization we want to do on every node
  # As well as the number of CPUs available and on which "level" we want to parallelize.
  parallelStartMulticore(cpus = 8L, level = "mlr.tuneParams")

  result = tuneParams(learner = learner,
    task = data$mlr.task,
    resampling = data$mlr.rin,
    measures = measures,
    par.set  = par.set,
    control = tune.control)

  parallelStop() #  parallelization is turned off and all necessary stuff is cleaned up. -> good practice
  return(result)
})


# Define Learner with their parameter sets as well as the control objects and measures.

LEARNER = list(
  svm = makeLearner("classif.svm"),
  xgboost = makeLearner("classif.xgboost", nrounds = 100, nthread = 1L)
)

PAR.SETS = list(
  svm = makeParamSet(
    makeNumericParam("cost", -15, 15, trafo = function(x) 2^x),
    makeNumericParam("gamma", -15, 15, trafo = function(x) 2^x)),
  xgboost = makeParamSet(
    makeNumericParam("eta", lower = 0.01, upper = 0.2),
    makeIntegerParam("max_depth", lower = 1, upper = 10),
    makeNumericParam("lambda", lower = -10, upper = 10, trafo = function(x) 2^x))
)


CONTROL = list(makeTuneControlRandom(maxit = 100))

MEASURES = list(list(acc, timetrain))

# We can add complex objects as list columns in a data.table to save them in a structured format
algo.design = list(mlr_tuning = data.table(learner = LEARNER, par.set = PAR.SETS, tune.control = CONTROL, measures = MEASURES))


print(algo.design)
# Note: Since, CONTROL and MEASURES are the same for both LEARNERs, they are repeated in the design,
# but we COULD also easily compare multiple different optimization strategies, e.g., grid search or model-based optimization.

addExperiments(algo.designs = algo.design, repls = 10)

submitJobs(1, resources = resources)




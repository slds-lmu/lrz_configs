# Task: We'd like to tune a support vector machine on the sonar dataset (See: Gorman, R. P., and Sejnowski, T. J. (1988).)

# load parallelMap and mlr
library(mlr)
library(parallelMap)


lrn = makeLearner("classif.svm") # create the learner

# define a parameter set to tune over. In this example we tune both the cost and gamma parameter of a rbf-svm between 2^-15 and 2^15 on a log scale (see trafo function).
ps = makeParamSet(
  makeNumericParam("cost", -15, 15, trafo = function(x) 2^x),
  makeNumericParam("gamma", -15, 15, trafo = function(x) 2^x)
)


# define the kind of tuning we'd like to do. In this example we do a random search with 100 iterations.
# Alternatives would be Grid Search, CMAES, Irace or Bayesian Optimization
ctrl = makeTuneControlRandom(maxit = 100)


# define the performance measures we wan't to track. (The first measure defines the measure to be optimized, all additional measures are only tracked)
measures = list(acc, timetrain)

# define Resampling. In this example, stratified 10-fold crossvalidation
resampling = makeResampleDesc(method = "CV", iters = 10L, stratify = TRUE)

# take example data from mlr
data = sonar.task

# Start parallelization here. Define the method (alternatives are among others, Sockets or MPI), the number of CPUs/Cores and the level on which the parallelization should be used.
parallelStart("multicore", cpus = 28, level = "mlr.tuneParams")

# tune the parameters
res = tuneParams(learner = lrn, task = data, resampling = resampling, measures = measures, par.set  = ps, control = ctrl)

# Stop parallelization. Good practice!
parallelStop()

# save results
saveRDS(res, file = "result_runing.rds")

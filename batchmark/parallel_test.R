library(mlr)
library(batchtools)
library(checkmate)
source("batchmark.r")

learners = list(mlr::makeLearner("classif.xgboost"), mlr::makeLearner("classif.qda"))
tasks = list(mlr::makeClassifTask(data = iris, target = "Species"))
resamplings = list(mlr::makeResampleDesc("CV", iters = 2))


reg = makeExperimentRegistry()

ids = batchmark(learners, tasks, resamplings, reg = reg)


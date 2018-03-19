library(mlr)
library(OpenML)
library(batchtools)

### Create registry ###

# create a registry to store the experiments in
unlink("be_mlr_oml", recursive = TRUE)
reg = makeExperimentRegistry(file.dir = "be_mlr_oml", packages= c("mlr", "OpenML"))




### Define and add (ML) problems ###

# Find some simple Machine Learning tasks on OpenML
task.table = listOMLTasks(
  number.of.missing.values = 0,       # No missing values
  number.of.classes = 2,              # Binary classification
  number.of.features = c(4, 20),      # Between 4 and 20 features
  number.of.instances = c(100, 1000), # Between 100 and 1000 observations
  tag = "Study_14"                    # Included in Study 14 (pre-selected subset of problems)
)

print(tasks)

# Download and OpenML tasks
tasks = lapply(task.table$task.id, getOMLTask)
print(tasks[[1]])


# Convert tasks to mlr
tasks = lapply(tasks, convertOMLTaskToMlr)

# Each list element contains

# 1) the mlr task
tasks[[1]]$mlr.task

# 2) a resample instance, to ensure consistent folds
tasks[[1]]$mlr.rin

# 3) (optional) performance measures; Train/Predict time is always present
tasks[[1]]$mlr.measures




#Add one experiment for every element in tasks
for(task in tasks)
  addProblem(name = getTaskId(task$mlr.task), data = task)



# generic algorithm that gets the name of an mlr machine learning algorithm,
# then creates, trains and evaluates it on an experiment (i.e. OpenML data set)
addAlgorithm(name = "mlr", fun = function(job, data, instance, learner) {
  learner = makeLearner(learner)
  resample(learner, data$mlr.task, data$mlr.rin, measures = acc)
})


# Add a design, i.e. possible values for `learner` in our algorithm
algo.design = list(mlr = data.frame(learner =
    c("classif.rpart", "classif.lda", "classif.ranger"), stringsAsFactors = FALSE))

addExperiments(algo.designs = algo.design, repls = 10)

summarizeExperiments()

getStatus()

submitJobs()

getStatus()

results = reduceResultsDataTable(fun = function(job, res) res$aggr[1L])
print(results)

#Add information from job table
results = getJobPars()[results]
print(results)

results = unwrap(results)
results.aggr = results[, .(mean.perf = mean(mmce.test.mean)), by = .(problem, learner)]

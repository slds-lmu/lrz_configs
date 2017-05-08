library(BatchExperiments)
reg <- makeExperimentRegistry(id="my_experiments")


subsample <- function(static, ratio) {
  n <- nrow(static)
  train <- sample(n, floor(n * ratio))
  test <- setdiff(seq(n), train)
  list(test=test, train=train)
}
data(iris)
addProblem(reg, id="iris", static=iris,
           dynamic=subsample, seed=123)

tree.wrapper <- function(static, dynamic, ...) {
  library(rpart)
  mod <- rpart(Species ~ ., data=static[dynamic$train, ], ...)
  pred <- predict(mod, newdata=static[dynamic$test, ], type="class")
  table(static$Species[dynamic$test], pred)
}

addAlgorithm(reg, id="tree", fun=tree.wrapper)
forest.wrapper <- function(static, dynamic, ...) {
  library(randomForest)
  mod <- randomForest(Species ~ ., data=static,
                      subset=dynamic$train, ...)
  pred <- predict(mod, newdata=static[dynamic$test, ])
  table(static$Species[dynamic$test], pred)
}


pars <- list(ratio=c(0.67, 0.9))
iris.design <- makeDesign("iris", exhaustive=pars)
pars <- list(minsplit=c(5, 10, 20), cp=c(0.01, 0.1))
tree.design <- makeDesign("tree", exhaustive=pars)
pars <- list(ntree=c(100, 500, 1000))
forest.design <- makeDesign("forest", exhaustive=pars)
addAlgorithm(reg, id="forest", fun=forest.wrapper)

addExperiments(reg, prob.designs=iris.design,
               algo.designs=list(tree.design, forest.design),
               repls=100)

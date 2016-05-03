cluster.functions = batchtools::makeClusterFunctionsSLURM("~/lmu_lrz_new.tmpl", clusters = 
"mpp2")
default.resources = list(walltime = 300L, memory = 512L, ntasks = 28L)



debug = TRUE

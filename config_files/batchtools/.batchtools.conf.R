cluster.functions = batchtools::makeClusterFunctionsSlurm("/home/hpc/pr74ze/ri89coc2/lrz_configs/config_files/batchtools/slurm_lmulrz.tmpl", 
clusters = "serial")
default.resources = list(walltime = 300L, memory = 512L, ntasks = 1L)

max.concurrent.jobs = 1000L

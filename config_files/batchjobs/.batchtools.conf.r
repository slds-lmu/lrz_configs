cluster.functions = batchtools::makeClusterFunctionsSLURM("/home/hpc/ua341/di25koz/lrz_configs/config_files/batchjobs/lmu_lrz_new.tmpl", 
	clusters = "mpp2")
default.resources = list(walltime = 300L, memory = 512L, ntasks = 28L)



debug = TRUE

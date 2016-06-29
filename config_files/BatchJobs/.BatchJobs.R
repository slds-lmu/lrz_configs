cluster.functions = makeClusterFunctionsSLURM(template.file = "/home/hpc/pr74ze/ri89coc2/lrz_configs/config_files/BatchJobs/lmu_lrz.tmpl", 
	list.jobs.cmd = c("squeue", "-h", "-o %i", "-u $USER", 
	                  "--clusters=serial", "| tail -n +2"))

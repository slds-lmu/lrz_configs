cluster.functions = makeClusterFunctionsSLURM(template.file = "/home/hpc/ua341/di25koz/lrz_configs/config_files/batchjobs/lmu_lrz.tmpl", 
	list.jobs.cmd = c("squeue", "-h", "-o %i", "-u $USER", 
	                  "--clusters=serial", "| tail -n +2"))

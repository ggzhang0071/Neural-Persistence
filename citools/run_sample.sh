TOP=`pwd`/..
cd $TOP
timestamp=`date +%Y%m%d%H%M%S`
cl=`git rev-parse HEAD|cut -c1-7`
timestamp="$cl-$timestamp"

rm -fr results
mkdir results
nvidia-docker run  --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 -v $TOP/results/:/Neuralpersistence/results/ neuralpersistence python3 -u run_experiments.py 2>&1 | tee run_experiments_$timestamp.log

nvidia-docker run --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 -v $TOP/results/:/Neuralpersistence/results/ neuralpersistence python3 combine_runs.py results/runs/* --output results/combined_runs.csv 2>&1 |tee combine_runs_$timestamp.log

nvidia-docker run --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 -v $TOP/results/:/Neuralpersistence/results/ neuralpersistence python3 create_plots.py results/combined_runs.csv results/combined_runs.pdf 2>&1 |tee create_logs_$timestamp.log

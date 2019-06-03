TOP=`pwd`/..
cd $TOP
timestamp=`date +%Y%m%d%H%M%S`
cl=`git rev-parse HEAD|cut -c1-7`
timestamp="$cl-$timestamp"
docker run  --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 -v $TOP/results/:/Neuralpersistence/results/ neuralpersistence python3 -u run_experiments.py 2>&1 | tee /Neuralpersistence/results/run_experiments_$timestamp.log

docker run --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 -v $TOP/results/:/Neuralpersistence/results/ neuralpersistence python3 combine_runs.py results/runs/* --output results/combined_runs.csv 2>&1 |tee /Neuralpersistence/results/combine_runs_$timestamp.log

docker run --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 -v $TOP/results/:/Neuralpersistence/results/ neuralpersistence python3 create_plots.py results/combined_runs.csv results/combined_runs.pdf 2>&1 |tee /Neuralpersistence/results/create_logs_$timestamp.log

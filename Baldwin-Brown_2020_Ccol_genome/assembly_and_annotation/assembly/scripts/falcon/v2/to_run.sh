export PATH="/data1/jbrown/local_programs/anaconda/install_dir/anaconda/bin:$PATH"
home_pwd=`pwd`
source activate py279
source /data1/jbrown/local_programs/falcon/falcon-integrate/FALCON-integrate/env.sh
cd `dirname temp/falcon/v2/falcon_done.txt`
fc_run.py ${home_pwd}/scripts/falcon/v2/fc_run.cfg

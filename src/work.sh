#PBS -l nodes=1:ppn=10
#PBS -S /bin/bash
#PBS -j oe
#PBS -q normal_3

# Please set PBS arguments above
# This job's working directory
cd ~/test

# Following are commands
sleep 10
echo "Thi mission is run successfully!!" > ~/test/result.txt

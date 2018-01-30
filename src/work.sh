#PBS -l nodes=1:ppn=10
#PBS -S /bin/bash
#PBS -j oe
#PBS -q normal_3

# Please set PBS arguments above
# This job's working directory
cd ~/test

# Following are commands
sleep 20
echo "Thi mission is run successfully!!" > ~/test/result.txt

# call Rscripts
Rscript ~/test/test.R > ~/test/result2.txt

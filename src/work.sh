#PBS -l walltime=02:30:00
#PBS -l nodes=1:ppn=28
#PBS -S /bin/bash
#PBS -l mem=50gb

#PBS -j oe
#PBS -q normal_3

# Please set PBS arguments above
# This job's working directory (You must set this)
cd ~/wangshx/projects/biotools/ensembl-vep

# Following are commands/scripts you want to run
# If you do not know how to set this, please check README.md file 

# load perl and activate conda env

module load apps/perl/5.22.1
source activate py2

# run ensembl-vep
./vep --cache --offline --pick --symbol --species homo_sapiens --assembly GRCh38 --format vcf --terms SO \
--fasta ~/wangshx/annotation/reference/hg38.fa --dir_plugins ../VEP_plugins/ \
--plugin Downstream --plugin Wildtype  \
--input_file ../../tests/TCGA.LUAD.mutect.hg38.somatic.vcf \
--output_file ../../tests/TCGA-LUAD-mutect-hg38-VEP4pVACseq-somatic.vcf  


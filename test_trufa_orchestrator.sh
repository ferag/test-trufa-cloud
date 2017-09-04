#!/bin/bash
mkdir /data
cd /data
wget https://193.146.75.60/web/static/demo_files/reads_left.fq.tar.gz --no-check-certificate
wget https://193.146.75.60/web/static/demo_files/reads_right.fq.tar.gz --no-check-certificate

tar -zxvf ./reads_left.fq.tar.gz
tar -zxvf ./reads_right.fq.tar.gz

export READS_FILES='/data/reads_left.fq /data/reads_right.fq'
export OUT_FOLDER='/data/'
export STAT_FOLDER='/data/'


mkdir ${STAT_FOLDER}fastqc_report

echo `date +%F\ %H:%M:%S` "START FastQC" >> ${OUT_FOLDER}.LOG.txt

reads_in=($READS_FILES)

for ((i=0; i<${#reads_in[@]}; i++)); do

    fastqc -t 2  --noextract ${reads_in[ i ]} -o ${STAT_FOLDER}fastqc_report
    echo FASTQC: IN: ${reads_in[ i ]} >> ${OUT_FOLDER}.LOG.txt
done
wait
ls ${OUT_FOLDER}
cat ${OUT_FOLDER}*.html
echo `date +%F\ %H:%M:%S` "END FastQC" >> ${OUT_FOLDER}.LOG.txt


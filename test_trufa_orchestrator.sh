#!/bin/bash
apt-get update -y
apt-get install software-properties-common -y
apt-add-repository ppa:ansible/ansible
apt-get update && apt-get install -y ansible && rm -rf /var/lib/apt/lists/* 
ansible-galaxy install indigo-dc.oneclient && ansible-playbook /etc/ansible/roles/indigo-dc.oneclient/tests/test.yml

env
mkdir -p /onedata/input
mkdir -p /onedata/output

ONECLIENT_AUTHORIZATION_TOKEN="$INPUT_ONEDATA_TOKEN" PROVIDER_HOSTNAME="$INPUT_ONEDATA_PROVIDERS" oneclient --no_check_certificate --authentication token -o ro /onedata/input || exit 1
ONECLIENT_AUTHORIZATION_TOKEN="$OUTPUT_ONEDATA_TOKEN" PROVIDER_HOSTNAME="$OUTPUT_ONEDATA_PROVIDERS" oneclient --no_check_certificate --authentication token -o rw /onedata/output || exit 1

cd /onedata/input

INPUTDIR="/onedata/input/$INPUT_ONEDATA_SPACE/$INPUT_PATH"
OUTPUTDIR=

mkdir -p "$OUTPUTDIR"

OUT_FOLDER="/onedata/output/$OUTPUT_ONEDATA_SPACE/$OUTPUT_PATH"
IN_FOLDER="/onedata/input/$INPUT_ONEDATA_SPACE/$INPUT_PATH"
STAT_FOLDER="/onedata/output/$OUTPUT_ONEDATA_SPACE/$OUTPUT_PATH"
READS_FILES="$IN_FOLDER/data/reads_left.fq $IN_FOLDER/data/reads_right.fq"


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


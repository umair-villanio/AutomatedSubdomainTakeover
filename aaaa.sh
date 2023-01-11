#!/bin/bash

echo "Enter the website. Example hackerone.com "  
read website  

cd subfinder/v2/cmd/subfinder
./subfinder -d $website > ../../../../subdomains/$website.txt

cd ../../../../nuclei/v2/cmd/nuclei
./nuclei -l ../../../../subdomains/$website.txt -t ../../../../subdomain-takeover_detect-all-takeovers.yaml

for i in $n_procs; do
    ./procs[${i}] &
    pids[${i}]=$!
done

# wait for all pids
for pid in ${pids[*]}; do
    wait $pid
done


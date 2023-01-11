#!/bin/bash

SUBFINDER="https://github.com/projectdiscovery/subfinder.git"
NUCLEI="https://github.com/projectdiscovery/nuclei.git"
MAIN="../../../../"
DIR_GO=/usr/local/go
DIR_SUBFINDER=./subfinder
DIR_NUCLEI=./nuclei
DIR_SUBDOMAINS=./subdomains

############################################################
Help()
{
   # Display Help
   echo "This script allows to scan subdomains of a website using Subfinder and allows to use Nuclei to check for Subdomain Takeovers"
   echo
   echo "Syntax: scriptTemplate [-d|h|v|V]"
   echo "options:"
   echo "g     To do a simple subdomain scan and to check takeovers through nuclei."
   echo "h     Print this Help."
   echo "v     Verbose mode."
   echo
}
###################################   INSTALLING GO   ##########################

if [ -d "$DIR_GO" ];
then
    go_ver=$(go version | cut -d " " -f 3 | cut -c 5-6)
    
    if [ $go_ver -lt 19 ]
    then
        wget https://go.dev/dl/go1.19.4.linux-amd64.tar.gz
        sudo rm -rvf /usr/local/go/
        sudo tar -C /usr/local -xvf go1.19.4.linux-amd64.tar.gz
        rm go1.19.4.linux-amd64.tar.gz
    fi
    
else
    wget https://go.dev/dl/go1.19.4.linux-amd64.tar.gz
    sudo rm -r /usr/local/go
    sudo tar -C /usr/local -xvf go1.19.4.linux-amd64.tar.gz  
	echo "export PATH=\$PATH:/usr/local/go/bin" >> $HOME/.profile
fi


###################################   INSTALLING SUBFINDER   ###################
if [ ! -d "$DIR_SUBFINDER" ];
then
    git clone $SUBFINDER
    cd subfinder/v2/cmd/subfinder
    go build
    cd $MAIN
fi


###################################   INSTALING NUCLEI   #######################
if [ ! -d "$DIR_NUCLEI" ];
then
    git clone $NUCLEI
    cd nuclei/v2/cmd/nuclei
    go build
    cd $MAIN
fi

if [ ! -d "$DIR_SUBDOMAINS" ];
then
    mkdir subdomains
fi

###################################   SCRIPT   #################################

while getopts :d:h:s flag
do
    case "${flag}" in
        d) WEBSITE=${OPTARG}
           cd subfinder/v2/cmd/subfinder
           ./subfinder -d $WEBSITE > ${MAIN}$WEBSITE.txt

           cd ${MAIN}nuclei/v2/cmd/nuclei
           ./nuclei -l ${MAIN}$WEBSITE.txt -t ${MAIN}subdomain-takeover_detect-all-takeovers.yaml
        exit;;
        
        h) Help
        exit;;
        
        s) ARGS=${OPTARG}
        echo $ARGS
        cd subfinder/v2/cmd/subfinder
           ./subfinder $ARGS
           exit;;

        \?)      
        echo "Error: Invalid option"
         exit;;
        
    esac
done




#######################   DO NOT EDIT THIS   ###################################
for i in $n_procs; do
    ./procs[${i}] &
    pids[${i}]=$!
done

# wait for all pids
for pid in ${pids[*]}; do
    wait $pid
done

    




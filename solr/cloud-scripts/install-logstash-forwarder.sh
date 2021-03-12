#!/bin/bash


# This script will install logstash-forwarder in all the given solr nodes in prodb-solr-nodes.list
#
set -e

# TODO enhance this script to show correct error message 
# TODO enhance this script to do silently with out any messages
# TODO enhance this script to take the list of solr nodes or for a single node as command line argument
echo " *** starting  to install logstash forwarder for all the solr nodes in  prodb-solr-nodes.list ***  ::"

cd ~
clear
function usage
{
    echo "usage: system_page [[[-f file ] ] | [-h]]"
}

#variables definition
sshvar="sudo ssh -ti /home/rajesh/work/cert/SXM_SEARCH_PROD.pem ec2-user@"

while [ "$1" != "" ]; do
    case $1 in
        -f | --file )           shift
                                if [ "$1" = "" ]; then
				  solrNodeFileList=""
				  echo "no second argument -- file of solr nodes name with complete path "
				  exit 1
				else 
				  solrNodeFileList=$1
				fi
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done
function error_exit
{
	echo "$1" 1>&2
	exit 1
}




for solrnode in $(more $solrNodeFileList) 	
	do 
		echo " *** starting to configure logstash-forwarder in  *** $solrnode"
				
		 echo "# rpm is from another location"

		cd ~; 
		set -x
		solrnode=${solrnode::-1}
		$sshvar$solrnode sudo  pwd
		#$sshvar$solrnode sudo  ls -l ~/logstash-forwarder*;
		if [ $sshvarsolrnode sudo ls -l logstash-forwarder* != "" ]; then
		    $sshvar$solrnode sudo sudo rm -v logstash-forwarder*
		fi
		
		$sshvar$solrnode sudo curl -O http://download.elasticsearch.org/logstash-forwarder/packages/logstash-forwarder-0.3.1-1.x86_64.rpm
		$sshvar$solrnode cd /home/ec2-user
		$sshvar$solrnode sudo rpm -ivh logstash-forwarder-0.3.1-1.x86_64.rpm
		$sshvar$solrnode cd /etc/init.d/
		  
		$sshvar$solrnode sudo curl -o logstash-forwarder http://logstashbook.com/code/4/logstash_forwarder_redhat_init
		$sshvar$solrnode sudo chmod +x logstash-forwarder

		$sshvar$solrnode sudo curl -o /etc/sysconfig/logstash-forwarder http://logstashbook.com/code/4/logstash_forwarder_redhat_sysconfig

	echo"##copying the logstash-fowarder.conf to /etc/logstash-forwarder/logstash-forwarder.conf"
		$sshvar$solrnode aws s3 ls s3://k2-software/logstash-forwarder.conf
		$sshvar$solrnode aws s3 cp s3://k2-software/mnt/solrdrive/k2/logstash-forwarder/logstash-forwarder-b.conf  /home/ec2-user/software/mnt/solrdrive/k2/logstash/logstash-forwarder.conf
		$sshvar$solrnode sudo /home/ec2-user/software/mnt/solrdrive/k2/logstash/logstash-forwarder.conf  /etc/logstash-forwarder/logstash-forwarder.conf 
	echo"##downloading the certs from qws s3 and copying the logstash cert to  certs"
		$sshvar$solrnode aws s3 cp s3://k2-software/logstash-forwarder2.crt  /home/ec2-user/software/mnt/solrdrive/k2/logstash/logstash-forwarder.crt
		$sshvar$solrnode sudo /home/ec2-user/software/mnt/solrdrive/k2/logstash/logstash-forwarder.crt  /etc/pki/tls/certs/logstash-forwarder.crt				
		$sshvar$solrnode sudo aws s3 cp s3://k2-software/mnt/solrdrive/k2/solr/log4j.properties /opt/solr/example/resources/
		$sshvar$solrnode sudo /opt/solr/bin/solr restart -p 8983 -s /mnt/solrdrive/k2/solr/cores -z prod-b-zk01.tag.siriusxm.internal:2181,prod-b-zk02.tag.siriusxm.internal:2181,prod-b-zk03.tag.siriusxm.internal:2181,prod-b-zk04.tag.siriusxm.internal:2181,prod-b-zk05.tag.siriusxm.internal:2181 -c -m 16g
		$sshvar$solrnode sudo service logstash-forwarder restart
		$sshvar$solrnode sudo ps -ef | grep "logstash"
		
		echo " *** verifying logstash-forwarder connectivity to logstash instance ***"
		
		$sshvar$solrnode sudo /opt/logstash-forwarder/bin/logstash-forwarder -config /etc/logstash-forwarder/logstash-forwarder.conf -spool-size 100
	    set +x
	echo " *** Successfully installed logstash-forwarder on ***  :: $solrnode"
		
	done

echo " *** Successfully installed logstash-forwarder on all solr nodes in :: $solrNodeFileList"

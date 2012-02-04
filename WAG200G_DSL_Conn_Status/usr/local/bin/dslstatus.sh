#!/bin/bash
# Peter Senna Tschudin - peter.senna@gmail.com
# Prints the ADSL line statistics. See $param for details 
# Tunned up for Linksys WAG200G Wireless-G ADSL Home Gateway - Firmware Version: 1.01.09
# 
# Use without parameters or specify value range. Examples:
# ./dslstatus.sh will print all values ( same as ./dslstatus.sh 0 8 )
# ./dslstatus.sh 0 2 will print the first two values
# ./dslstatus.sh 2 4 will print the third and fourth values


# DSL Modem Information
GetAddress="http://10.0.0.1/setup.cgi?next_file=DSL_status.htm" 
AuthUser=admin
AuthPass=#GATEWAY PASSWORD GOES HERE

# OutFile
OutFile="/tmp/dsl_status.html"
MaxAge=240 # 4 Minutes

# Parameters to grep
param[0]="Downstream Rate:"
param[1]="Upstream Rate:"
param[2]="Downstream Margin:"
param[3]="Upstream Margin:"
param[4]="Downstream Line Attenuation:"
param[5]="Upstream Line Attenuation:"
param[6]="Downstream Transmit Power:"
param[7]="Upstream Transmit Power:"
param[8]="" # Only for safety

#Other vars
i=0

cd /tmp
if [ -f $OutFile ]; then

	now=`date +"%s"`
	fileage=`stat -c "%Y" $OutFile`
	let "diff=$now - $fileage"

	if [ $diff -gt $MaxAge ];then
		rm -f $OutFile
	fi
fi

# If $OutFile is old it is deleted by previous "if" 
if [ ! -f $OutFile ]; then
	wget --user=$AuthUser --password=$AuthPass $GetAddress -O $OutFile >/dev/null 2> /dev/null
	if [ $? != 0 ]; then
		echo Error getting page!
		exit 1
	fi
fi

# Parsing the downloaded file and storing the result in result
while true; do
	result[i]=`grep -A 1 "${param[i]}" $OutFile |tail -n 1 |cut -d ">" -f 2 |cut -d "<" -f 1|cut -d " " -f 1`

	let "i += 1"
	if [ ! "${param[i]}" ]; then
		break
	fi
done

#let "result[0] = ${result[0]} / 1000"
#let "result[1] = ${result[1]} / 1000"

i=0

# First parameter of command line
if [ $1 ] && [ $1 -gt 0 ]; then
	i=$1;
fi

#Printing out the result
while true; do
	echo ${result[i]};

        let "i += 1"

	# Second parameter of command line
	if [ $2 ] && [ $2 -eq $i ]; then
		break
	fi

        if [ ! "${param[i]}" ]; then
                break
	fi
done

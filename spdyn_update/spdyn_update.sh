#!/bin/bash


function get_public_ip()
{
	local get_public_ip_url="http://checkip4.spdyn.de"
	local public_ip=$(curl -s ${get_public_ip_url})
	echo $public_ip
}

function create_folder_if_not_existant()
{
	local path=$1
	mkdir -p $path
}

function get_containing_folder()
{
	if [ $# != 1 ]; then exit 1; fi
	local file_path=$1
	local containing_folder="$(dirname "${file_path}")"
	echo $containing_folder
}

function create_containing_folder_of_filepath_if_not_existant()
{
	if [ $# != 1 ]; then exit 1; fi
	local file_path=$1

	local containing_folder=$(get_containing_folder $file_path)
	create_folder_if_not_existant $containing_folder
}

function file_exists_and_is_readable()
{
	if [ $# != 1 ]; then exit 1; fi
	local filepath=$1

	if [ -r $filepath ]; then 
		echo true
	else 
		echo false 
	fi
}

function get_last_public_ip_from_file()
{
	if [ $# != 1 ]; then exit 1; fi
	local ip_file=$1

	if [ "$(file_exists_and_is_readable $ip_file)" = false ]; then 
		echo ""
	else
		echo $(cat ${ip_file})
	fi
}

function ip_update_is_neccesary()
{
	if [ $# != 1 ]; then exit 1; fi
	local ip_file=$1

	local new_ip=$(get_public_ip)
	local old_ip=$(get_last_public_ip_from_file $ip_file)
	if [ "${new_ip}" = "${old_ip}" ]; then
		echo false
	else
		echo true
	fi
}

function update_ip_file()
{
	if [ $# != 1 ]; then exit 1; fi
	local ip_file=$1

	create_containing_folder_of_filepath_if_not_existant $ip_file
	get_public_ip > $ip_file
}

function update_ip_spdyn()
{
	if [ $# != 2 ]; then exit 1; fi
	local host_name=$1
	local update_token=$2
	local update_url="https://update.spdyn.de/nic/update"

	new_ip=$(get_public_ip)
	response=$(curl -su "${host_name}:${update_token}" "${update_url}?hostname=${host_name}&myip=${new_ip}")
	echo $response
}

function update_ip_if_neccesary()
{
	if [ $# != 3 ]; then exit 1; fi
	local ip_file=$1
	local host_name=$2
	local update_token=$3
	
	if [ "$(ip_update_is_neccesary $ip_file)" = true ]; then
		update_ip_file $ip_file
		update_ip_spdyn $host_name $update_token
	fi
}

function test_functions()
{
	echo
	echo get_public_ip	
	echo $(get_public_ip)
	echo 
	echo get_containing_foler /folder1/folder2/testfile.txt
	echo $(get_containing_folder /folder1/folder2/testfile.txt)
	echo 
	tmp_file=/tmp/spdyn_update_tests_last_public_ip_from_file_test
	rm -f $tmp_file
	echo get_last_public_ip_from_file $tmp_file
	echo $(get_last_public_ip_from_file $tmp_file)
	echo 
	echo ip_update_is_neccesary $tmp_file
	echo $(ip_update_is_neccesary $tmp_file)
	echo
	echo update_ip_file $tmp_file
	update_ip_file $tmp_file
	echo
	echo get_last_public_ip_from_file $tmp_file
	echo $(get_last_public_ip_from_file $tmp_file)
	echo
	echo ip_update_is_neccesary $tmp_file
	echo $(ip_update_is_neccesary $tmp_file)
	rm $tmp_file
	echo
	# If you want to test your setup insert your hostname
	# and token here:
	my_hostname=yourhostnamegoesherefortesting.spdns.org
	my_update_token=your-toke-n123
	echo update_ip_spdyn $my_hostname $my_update_token
	echo $(update_ip_spdyn $my_hostname $my_update_token)
	echo
}

function main()
{
	local ip_file=~/spdyn_updatelast_ip
	local log_file=~/spdyn_update.log
	local host_name=$HOST_NAME
	local update_token=$UPDATE_TOKEN
	local update_frequency_min=$UPDATE_FREQUENCY_MIN
	
	while :
	do
		update_ip_if_neccesary $ip_file $host_name $update_token
		sleep ${update_frequency_min}m
	done
}


# test_functions
main



#!/bin/bash

function cmdHelp() {
	echo "Usage:\n  sh EgretLauncher.sh [egretProperties.json's path]"
}

echo "\nExecute EgretLanucher.sh ===================="

properties=$1

if [ "${properties}" = "" ]; then
	echo "[ERROR] Cant find the egretProperties.json"
	cmdHelp
	exit 1
fi

src=($(sh libs/JSON.sh -b < ${properties} | grep \"egret_version\"))

if [ "${src}" = "" ]; then
	src=($(sh libs/JSON.sh -b < ${properties} | grep \"engineVersion\"))	
fi

if [ "${src}" = "" ]; then
	echo "[ERROR] Cant parse the Egret properties"
	exit 1
fi

egretVer=$(echo $(echo ${src[1]} | cut -d "\"" -f 2))

if [ "${egretVer}" = "" ]; then
	echo "[ERROR] The Egret version is empty in the Egret properties"
	exit 1
fi

egretVer=v${egretVer}
rootEgret=~/egret/${egretVer}
rootEngine=${rootEgret}/egret-core

if [ ! -d "${rootEgret}" ]; then
	echo "Download the Egret engine ${egretVer}"
	git clone -b ${egretVer} https://github.com/egret-labs/egret-core.git ${rootEngine}

	if [ ! "$?" = "0" ]; then
		echo "[ERROR] Failed version ${egretVer} of the Egret engine"
		exit 1
	fi
fi

echo "Change the Egret engine to ${egretVer}"
ln -sf ${rootEngine}/tools/bin/egret /bin/egret

echo "END \n"
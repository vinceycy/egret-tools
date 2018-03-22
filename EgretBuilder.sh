#!/bin/bash

function cmdHelp() {
	echo "Usage:\n  sh EgretBuilder.sh [project path] [game tag] [html5|native]\n\n  project path: the path of project you will build\n  game tag: the release name"
}

echo "\nExecute EgretBuilder.sh ===================="

projectRoot=$1
gameTag=$2
runtime=$3
egretPath=$4

if [ "${projectRoot}" = "" ] || [ "${gameTag}" = "" ]; then
	echo "[ERROR] The parameters are empty"
	cmdHelp
	exit 1
fi

if [ "${runtime}" = "" ]; then
	runtime=html5
fi

if [ ! "${egretPath}" = "" ]; then
	egretPath=${egretPath}/
fi

temp=errlog

${egretPath}egret clean ${projectRoot}
${egretPath}egret build ${projectRoot} > ${temp}

cat ${temp}
result=$(grep error ${temp})
rm -rf ${temp}

if [ ! ${#result} = "0" ]; then
	echo "[ERROR] Egret build failed, error code $?"
	exit 1
fi

${egretPath}egret publish ${projectRoot} --version ${gameTag} --runtime ${runtime}

if [ "$?" != "0" ]; then
	echo "[ERROR] Egret publish failed, error code $?"
	exit 1
fi

echo "END \n"
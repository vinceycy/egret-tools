#!/bin/bash

projectName=project
tag=release

egret create ${projectName}

sh EgretBuilder.sh ${projectName} ${tag}
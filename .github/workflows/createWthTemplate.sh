#!/bin/bash

Help() {
   echo "Syntax: createWthTemplate [-c|d|h|n|v]"
   echo "options:"
   echo "c     How many challenges to stub out."
   echo "d     Delete existing directory with same name."
   echo "h     Print this Help."
   echo "n     Name of the new WhatTheHack. This must be a valid directory name"
   echo "p     Path to where to create new WhatTheHack directory."
   echo "v     Verbose mode."
   echo
}

CreateDirectoryStructure() {
  path=$1
  wthName=$2
  deleteExistingDirectory=$3

  fullPath="$path/$wthName"

  if $deleteExistingDirectory; then
    rm -rf $fullPath
  fi

  mkdir $fullPath
}

# Main program
verbosity=false

while getopts "c:h:n:p:v" option; do
  case $option in
    c) numberOfChallenges=${OPTARG};;
    d) deleteExistingDirectory=true;;
    h) Help
       exit;;
    n) nameOfChallenge=${OPTARG};;
    p) path=${OPTARG};;
    v) verbosity=true
  esac
done

if $verbosity; then
  echo "Number of Challenges: $numberOfChallenges"
  echo "Name of Challenge: $nameOfChallenge"
  echo "Path: $path"
fi

wthName="$numberOfChallenges-$nameOfChallenge"

CreateDirectoryStructure $path $wthName $deleteExistingDirectory
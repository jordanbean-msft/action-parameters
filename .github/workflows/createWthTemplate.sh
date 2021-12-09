#!/bin/bash
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

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
  local -r fullPath=$1
  local -r deleteExistingDirectory=$2

  if $deleteExistingDirectory; then
    rm -rf $fullPath
  fi
  
  if $verbosityArg; then
    echo "Creating $fullPath directory..."
  fi

  # create the xxx-YetAnotherWth directory
  mkdir $fullPath
  
  if $verbosityArg; then
    echo "Creating $fullPath/Coach/Solutions directories..."
  fi

  # create the Coach & Coach/Solutions directories
  mkdir -p $fullPath/Coach/Solutions
  
  if $verbosityArg; then
    echo "Creating $fullPath/Student/Resources directories..."
  fi

  # create the Student & Student/Resources directories
  mkdir -p $fullPath/Student/Resources
}

CreateReadmeFile() {
  local -r fullPath=$1
  
  if $verbosityArg; then
    echo "Creating $fullPath/README.md..."
  fi

  touch "$fullPath/README.md"
}

CreateMarkdownFile() {
  local -r fullPath=$1
  local -r prefix=$2
  local -r suffixNumber=$3
  
  if $verbosityArg; then
    echo "Creating $fullPath/$prefix-$suffixNumber.md..."
  fi

  touch "$fullPath/$prefix-$suffixNumber.md"
}

CreateChallenges() {
  local -r fullPath=$1
  local -r numberOfChallenges=$2
  
  if $verbosityArg; then
    echo "Creating $numberOfChallenges challenge Markdown files in $fullPath..."
  fi

  for challengeNumber in $(seq -f "%02g" 1 $numberOfChallenges); do
    CreateMarkdownFile "$fullPath" "Challenge" $challengeNumber
  done
}

CreateSolutions() {
  local -r fullPath=$1
  local -r numberOfSolutions=$2
  
  if $verbosityArg; then
    echo "Creating $numberOfSolutions solution Markdown files in $fullPath..."
  fi

  for solutionNumber in $(seq -f "%02g" 1 $numberOfSolutions); do
    CreateMarkdownFile "$fullPath" "Solution" $solutionNumber
  done
}

CreateChallengesAndSolutions() {
  local -r fullPath=$1
  local -r numberOfChallenges=$2

  if $verbosityArg; then
    echo "Creating $numberOfChallenges solution & challenge Markdown files in $fullPath..."
  fi

  CreateSolutions "$fullPath/Coach" $numberOfChallenges
  
  CreateChallenges "$fullPath/Student" $numberOfChallenges
}

# Main program
declare verbosityArg=false
declare deleteExistingDirectoryArg=false

while getopts ":c:dhn:p:v" option; do
  case $option in
    c) numberOfChallengesArg=${OPTARG};;
    d) deleteExistingDirectoryArg=true;;
    h) Help
       exit;;
    n) nameOfChallengeArg=${OPTARG};;
    p) pathArg=${OPTARG};;
    v) verbosityArg=true
  esac
done

if $verbosityArg; then
  echo "Number of Challenges: $numberOfChallengesArg"
  echo "Name of Challenge: $nameOfChallengeArg"
  echo "Path: $pathArg"
  echo "Delete existing directory: $deleteExistingDirectoryArg"
fi

declare -r wthName="xxx-$nameOfChallengeArg"

declare -r rootPath="$pathArg/$wthName"

CreateDirectoryStructure "$rootPath" $deleteExistingDirectoryArg

CreateReadmeFile "$rootPath"

CreateChallengesAndSolutions "$rootPath" $numberOfChallengesArg
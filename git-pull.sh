#!/bin/bash

# Variables for colouring text
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Colour

# Location of where the Git repositories are located
pwd=$(pwd)
directory="${directory:-$pwd}"

# Default blurb
echo
echo -e "${YELLOW}Git Pull Automation Script${NC}"
echo
echo "This script cycles through a directory and then runs a 'git pull' against any Git projects."
echo "https://github.com/AlexWinder/git-pull"
echo

# Enable named parameters to be passed in
while [ $# -gt 0 ]; do
    # If help has been requested
    if [[ $1 == *"--help" ]]; then
        echo "Options:"
        echo
        echo "--directory   The location where your Git projects are located. Default: current working directory"
        echo "--help        Display help about this script"
        echo
        exit 0
    fi

    # Check all other passed in parameters
    if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
    fi

    shift
done

for i in $(find $directory -maxdepth 1 -mindepth 1 -type d); do
    # Navigate to the directory
    cd $i
    echo -e "${GREEN}${i}${NC}"
    echo

    # Check if the project is Git
    if [ ! -d ".git" ]; then
        echo -e "${YELLOW}Not a Git project. Skipping.${NC}"
        echo
        continue
    fi

    # Check if the Git project has a remote
    remotes=$(git remote show)
    remotes_size=${#remotes}
    if (( ! remotes_size > 0 )); then
        echo -e "${YELLOW}Git project has no remote. Skipping.${NC}"
        echo
        continue
    fi

    # Get the default origin
    default_branch=$(git remote show ${remotes[0]} | sed -n '/HEAD branch/s/.*: //p')
    echo "Checkout to default branch..."
    git checkout $default_branch
    # Fetch everything
    echo "Fetch everything..."
    git fetch --all --prune
    # Pull everything
    echo "Pull everything..."
    git pull --all --ff-only
    # Set up a tracked branch for each branch
    echo "Setting up a tracked branch for each branch..."
    git branch -r | grep -v '\->' | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" | while read remote; do
        echo "Tracking $remote"
        git branch --track "${remote#origin/}" "$remote"
    done
    # Do a pull on each branch
    echo "Pull each tracked branch..."
    git branch --format "%(refname:short)" | while read branch; do
        echo "Pull ${remotes[0]} $branch"
        git checkout $branch
        git pull --ff-only
    done
    # Delete any branches which haven't been merged into the default
    echo "Remove deleted branches"
    git fetch -p && git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -d
    # Back to default branch
    echo "Reverting back to the default branch"
    git checkout $default_branch
    echo
done

echo -e "${GREEN}All projects pulled.${NC}"

exit 0

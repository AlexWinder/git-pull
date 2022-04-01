#!/bin/bash

# Location of where the Git repositories are located
pwd=$(pwd)
directory="${directory:-$pwd}"

# Enable named parameters to be passed in
while [ $# -gt 0 ]; do
    # If help has been requested
    if [[ $1 == *"--help" ]]; then
        echo
        echo "Git Pull Automation Script"
        echo
        echo "This script cycles through a directory and then runs a 'git pull' against any Git projects."
        echo "https://github.com/AlexWinder/git-pull"
        echo
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
    pwd

    # Check if the project is Git
    if [ ! -d ".git" ]; then
        echo "Not a Git project. Skipping."
        continue
    fi

    # Check if the Git project has a remote
    remotes=$(git remote show)
    remotes_size=${#remotes}
    if (( ! remotes_size > 0 )); then
        echo "Git project has no remote. Skipping."
        continue
    fi

    # Do a pull on the project
    git fetch --all
    for branch in "$@"; do
        git checkout "$branch"  || exit 1
        git pull                || exit 1
    done
done

echo "All projects pulled."

exit 0

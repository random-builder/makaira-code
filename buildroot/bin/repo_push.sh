#!/usr/bin/env bash

#
# store build artifacts into the repository
#

set -e

git_push() {
    local message=$(date "+%Y-%m-%d")
    git config --global push.default simple
    git add --all  :/
    git status 
    git commit --message "$message"
    git push
}

cd $makaira_repo

git_push

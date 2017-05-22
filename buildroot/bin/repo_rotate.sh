#!/usr/bin/env bash

#
# expire firmware repository artifacts
#

set -e

readonly repo="$HOME/makaira_repo_mirror"

repo_expire() {
    #
    local repo_days=90 # default
    if [[ "$MAKAIRA_REPO_DAYS" ]] ; then
        repo_days="$MAKIARA_REPO_DAYS"
    elif [[ "$makaira_repo_days" ]] ; then
        repo_days="$makaira_repo_days"
    fi 
    local expired=$(date --date="-$repo_days days" "+%Y-%m-%d")
    local pattern="*${expired}.hex.zip"
    echo "pattern=$pattern"
    #
    cd $HOME
    rm -rf "$repo"
    git clone --mirror git@github.com:random-builder/makaira-repo.git "$repo"
    #
    cd $HOME
    $bfg_command --delete-files "$pattern" "$repo"
    #
    cd "$repo"
    git reflog expire --expire=now --all
    git gc --prune=now --aggressive
    git push
}

# run only on schedule or for testing
echo "TRAVIS_EVENT_TYPE=$TRAVIS_EVENT_TYPE"
echo "DEBUG_REPO_EXPIRE=$DEBUG_REPO_EXPIRE"

# use multiple variable sources
echo "MAKAIRA_REPO_DAYS=$MAKAIRA_REPO_DAYS"
echo "makaira_repo_days=$makaira_repo_days"

if [[ "$TRAVIS_EVENT_TYPE" == "cron" ]] || [[ "$DEBUG_REPO_EXPIRE" == "YES"  ]] ; then
    echo "exec repo clean"
    repo_expire    
else
    echo "skip repo clean"
fi

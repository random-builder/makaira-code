#!/usr/bin/env bash

#
# perform config build
#

set -e

# source repository
readonly job="$1"
readonly marlin="$makaira_code/Marlin"
readonly custom="$makaira_code/Marlin-Custom/$job"

# build parameters
readonly board="arduino:avr:mega:cpu=atmega2560"
readonly sketch="$marlin/Marlin.ino"
readonly target="/tmp/$job"
readonly binary="$target/Marlin.ino.hex"

# target repository
readonly repo="$makaira_repo"
readonly repo_path="$repo/Marlin-Custom/$job"
readonly repo_date=$(date "+%Y-%m-%d")
readonly repo_file="${repo_path}/${job//\//_}_${repo_date}.hex"
readonly repo_pack="${repo_file}.zip"

# logger values
readonly color_red='\e[31m'
readonly color_yel='\e[33m'
readonly color_blu='\e[34m'
readonly color_bold='\e[1m'
readonly color_none='\e[0m'

log() {
    local text="$1"
    echo -e "${color_bold}${color_blu}### $text ###${color_none}"
}

err() {
    local text="$1"
    echo -e "${color_bold}${color_red}### $text ###${color_none}"
}

log "========================================================================"
log "custom build: $job"
log "marlin master directory: $marlin"
log "marlin custom directory: $custom"
log "------------------------------------------------------------------------"

log "reset marlin repository"
git -C "$marlin" reset --hard 

log "verify marlin repository"
git -C "$marlin" status

log "provision custom sources"
cp --force --recursive --verbose "$custom"/* "$marlin"

log "invoke arduino ide compiler"
mkdir -p "$target"
arduino --verify --board "$board" --pref build.path="$target" "$sketch"
ls -las "$target"

log "store build binary in repository"
mkdir -p "$repo_path"
mv -f -v "$binary" "$repo_file"
rm -f  "$repo_pack"
zip -j "$repo_pack" "$repo_file"
rm -f "$repo_file"
ls -las "$repo_path"


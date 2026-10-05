#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source ${SCRIPT_DIR}/common.sh

me=$(basename "$0")

bins=( git gh )

for b in ${bins[@]}; do
	which -s ${b} || die "${b} is required, but not available."
done

untracked=$(git status -s | grep -c "^??")
uncommitted=$(git status -s | grep -c "^A")

if [ $((${untracked} + ${uncommitted})) -gt 0 ]; then
	die "There are untracked or uncommitted changes on this branch."
fi

git fetch upstream
git switch master
git reset --hard upstream/master
git push origin master


#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source ${SCRIPT_DIR}/common.sh

bins=( git gh )

for b in ${bins[@]}; do
	which -s ${b} || die "Required binary '${b}' is not installed"
done

me=$(basename "$0")

repo_base="git@"
repo_suffix=".git"
gh_base="github.com"
url=${gh_base}
url_separator=":"

function usage() {
	cat <<EOH
Configure the upstream repository of a fork.
Usage: ${me} [options] [repo]

  Options:
    -h,--help         help text
    -f,--forge        base url of code forge, default: ${gh_base}
    -p,--protocol     forge connection protocol, default: ssh, values: ssh|https

EOH
}

if [ "$#" -eq 0 ]; then
	usage && exit 1
else
	while [[ $# -gt 1 ]]; do
		case "$1" in
			-h|--help) usage && exit 0 ;;
			-f|--forge) url=$2 && shift 2;;
			-p|--protocol) if [ "$2" == "https" ]; then
				repo_base="https://"
				repo_suffix=""
				url_separator="/"
			elif [ "$2" == "ssh" ]; then
				repo_base="git@"
			else
				die "Unknown protocol: $2"
			fi && shift 2 ;;
			*) die "Unknown option: $1" ;;
		esac
	done
fi

repo=$1


git remote -v add upstream ${repo_base}${url}${url_separator}${repo}${repo_suffix}
gh repo set-default ${repo}


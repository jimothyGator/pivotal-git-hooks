#!/bin/bash

# Activates the commit-msg and prepare-commit-msg hooks by
# creating symbolic links in projects' git hooks directory.

usage() {
	echo "usage: $(basename $0) [-f] repo [repo ...]"
	echo 
	echo "Options:"
	echo "    -f: Overwrite existing commit-msg and prepare-commit-msg"
	echo "        files if they exist."
}

pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

if [[ "$1" = "-f" ]]; then
	LN_OPTS="-fn"
	shift
fi

if [ $# -eq 0 ]; then
	usage
	exit 1
fi

for dest in $@; do
	if [ ! -d $dest ]; then
		echo "$dest does not exist or is not a directory."
		continue
	fi

	if [ ! -d $dest/.git ]; then
		echo "$dest is not a git repository."
		continue
	fi

	if [[ -z "$LN_OPTS" && -f $dest/.git/hooks/commit-msg ]]; then
		echo "$dest: commit-msg hook already exists. Use '$(basename $0) -f ...' to overwrite."
	else
		ln -s $LN_OPTS $SCRIPTPATH/hooks/commit-msg $dest/.git/hooks/commit-msg
	fi

	if [[ -z "$LN_OPTS" && -f $dest/.git/hooks/prepare-commit-msg ]]; then
		echo "$dest: prepare-commit-msg hook already exists. Use '$(basename $0) -f ...' to overwrite."
	else
		ln -s $LN_OPTS $SCRIPTPATH/hooks/commit-msg $dest/.git/hooks/prepare-commit-msg
	fi
done


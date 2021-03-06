#!/bin/bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function doIt() {
    rsync --exclude='.git/' \
	    --exclude='README.md' \
	    --exclude='LICENSE' \
	    --exclude='bootstrap.sh' \
	    --exclude='linuxprep.sh' \
	    --exclude='coreapps.sh' \
	    --exclude='pydev.sh' \
	    --exclude='nodedev.sh' \
	    --exclude='misclang.sh' \
      --exclude='aws.sh' \
	    --exclude='datastores.sh' \
	    -avh --no-perms . ~;
    source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
  doIt;
else
  read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
  echo "";
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    doIt;
  fi;
fi;
unset doIt;

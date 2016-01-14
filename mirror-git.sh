#!/bin/bash

# Mirrors changes from one git remote repository to another by maintaining a
# local bare clone.
# Example crontab entry for periodic sync every 30 minutes:
# */30 *  *   *   *    /path/to/github_drupalorg/mirror-git.sh &> /dev/null

TARGET=andrewbelcher@git.drupal.org:project/decoupled_auth.git
SOURCE=https://github.com/FreelyGive/decoupled_auth.git

SYNC_FOLDER=decoupled_auth-git

DIRECTORY=$(pwd)

if [ ! -d "$DIRECTORY/$SYNC_FOLDER" ]; then
  git clone --branch 8.x-1.x $SOURCE $SYNC_FOLDER
  cd $DIRECTORY/$SYNC_FOLDER
  git remote add drupal_org $TARGET
  cd $DIRECTORY
fi

cd $DIRECTORY/$SYNC_FOLDER
git fetch origin
git checkout 8.x-1.x
git pull origin 8.x-1.x
git push drupal_org 8.x-1.x

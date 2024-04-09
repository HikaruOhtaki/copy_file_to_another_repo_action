#!/bin/sh

set -e
set -x

USER_EMAIL="github-actions[bot]@users.noreply.github.com"
USER_NAME="github-actions[bot]"
CLONE_DIR="TEMP_DIR"
GIT_REPO_URL="https://x-access-token:$API_TOKEN_GITHUB@github.com/$INPUT_DESTINATION_REPO.git"

echo "Clone destination repository"
git config --global user.email $USER_EMAIL
git config --global user.name $USER_NAME
git clone $GIT_REPO_URL $CLONE_DIR
cd $CLONE_DIR

git switch -c $INPUT_DESTINATION_BRANCH

if git ls-remote | grep -q "feature/update-event"; then
  echo "Destination branch already exists."
  git config pull.rebase false
  git pull origin $INPUT_DESTINATION_BRANCH
else
  echo "Destination branch not found."
fi

echo "Copy files to destination repository"
cp -R ../$INPUT_SOURCE_FILE $INPUT_DESTINATION_FOLDER

echo "Add commit"
git add .
if [ ! -z "$(git status -s)" ]; then
  git commit --message "Update from https://github.com/${GITHUB_REPOSITORY}/commit/${GITHUB_SHA}"
  echo "Commited"
  git push -u origin $INPUT_DESTINATION_BRANCH
  echo "Push commit"
else
  echo "No changes detected"
fi

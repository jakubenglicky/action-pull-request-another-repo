#!/bin/sh

set -e
set -x

if [ $INPUT_DESTINATION_HEAD_BRANCH == "main" ] || [ $INPUT_DESTINATION_HEAD_BRANCH == "master"]
then
  echo "Destination head branch cannot be 'main' nor 'master'"
  return -1
fi

CLONE_DIR=$(mktemp -d)

echo "Setting git variables"
export GITHUB_TOKEN=$API_TOKEN_GITHUB
export TOKEN_USER=$TOKEN_USER

git config --global user.email "$INPUT_USER_EMAIL"
git config --global user.name "$INPUT_USER_NAME"

echo "Cloning destination git repository"

git clone "https://$TOKEN_USER:$API_TOKEN_GITHUB@github.com/$INPUT_DESTINATION_REPO.git" "$CLONE_DIR"
cd "$CLONE_DIR"

gh pr create -t "$INPUT_TITLE" \
			-b "$INPUT_BODY" \
			-B $INPUT_DESTINATION_BASE_BRANCH \
			-H $INPUT_DESTINATION_HEAD_BRANCH \
			-d

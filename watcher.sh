#!/bin/bash

# check if node is intalled
if ! [ -x "$(command --v node)" ]; then
  echo 'Error: node is not installed.' >&2
  # Ask to install node
  echo 'Please install node' >&2
  exit 1
fi

# check if gulp is installed
if ! [ -x "$(command --v gulp)" ]; then
  echo 'Error: gulp is not installed.' >&2
  # Ask to install gulp
  echo 'Please install gulp globally with the following command:' >&2
  echo 'npm install --global gulp' >&2
  echo 'npm install --global gulp-cli' >&2
  exit 1
fi

gulp build
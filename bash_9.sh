#!/bin/bash
mkdir test_folder

if [ $? -eq 0 ]; then
  echo "Directory created successfully."
else
  echo "Failed to create directory."
fi

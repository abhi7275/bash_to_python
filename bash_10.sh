#!/bin/bash
trap "echo 'Script interrupted! Cleaning up...'; exit" SIGINT

echo "Running... Press Ctrl+C to interrupt."
sleep 10

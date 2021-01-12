#!/bin/sh

# Redirect output to a file for troubleshooting.
exec > ${PROJECT_DIR}/build/pre-actions.log 2>&1

# Add any pre-actions before making the build here.  The project environment
# will be available to the scripts.

$PROJECT_DIR/build/createAppleMusicAPIToken.sh

#!/bin/sh

#  ci_post_clone.sh
#  Jewel
#
#  Created by Greg Hepworth on 08/11/2021.
#  Copyright © 2021 Breakbeat Ltd. All rights reserved.

set -euo pipefail

: "${FIREBASE_API_KEY:?Firebase API Key environment variable not set or empty}"

cat > $CI_WORKSPACE/Jewel/App/Secrets.swift << EOF
struct Secrets {
  static var firebaseAPIKey = $FIREBASE_API_KEY
}
EOF

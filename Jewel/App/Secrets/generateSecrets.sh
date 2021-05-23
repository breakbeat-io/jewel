set -e

echo "Starting Secrets Generation"

echo "Generating Apple Music API Token"

# Exit if any of the required variables are not available.
# They are set in secrets.xcconfig and made available to this script by the Xcode pre-action bootstrapping.
: "${APP_STORE_CONNECT_TEAM_ID?Please set APP_STORE_CONNECT_TEAM_ID in your secrets.xcconfig.}"
: "${APPLE_MUSIC_KEY_ID?Please set APPLE_MUSIC_KEY_ID in your secrets.xcconfig.}"
: "${APPLE_MUSIC_PRIVATE_KEY?Please set APPLE_MUSIC_PRIVATE_KEY in your secrets.xcconfig.}"

# Generate the token using the amtg helper [https://github.com/breakbeat-io/amtg]
APPLE_MUSIC_API_TOKEN=$( \
  $PROJECT_DIR/tools/amtg \
    -t "$APP_STORE_CONNECT_TEAM_ID" \
    -i "$APPLE_MUSIC_KEY_ID" \
    -k "$APPLE_MUSIC_PRIVATE_KEY" \
)

echo "Generating Secrets.swift"

$PROJECT_DIR/tools/sourcery/bin/sourcery \
  --sources Jewel/App/Secrets \
  --templates Jewel/App/Secrets/Secrets.stencil \
  --output Jewel/App/Secrets/Secrets.swift \
  --args appleMusicAPIToken=\"$APPLE_MUSIC_API_TOKEN\" \
  --args firebaseAPIKey=\"$FIREBASE_API_KEY\"
  
         

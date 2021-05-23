echo "Starting Secrets Generation"

echo "Generating Apple Music API Token"

# Exit if any of the required variables are not available.
# They are set in secrets.xcconfig and made available to this script by the Xcode pre-action bootstrapping.
: "${APPLE_MUSIC_KEY_ID?Please set APPLE_MUSIC_KEY_ID in your secrets.xcconfig.}"
: "${APPLE_DEVELOPER_TEAM_ID?Please set FASTLAPPLE_DEVELOPER_TEAM_IDANE_USER in your secrets.xcconfig.}"
: "${APPLE_MUSIC_PRIVATE_KEY_PATH?Please set APPLE_MUSIC_PRIVATE_KEY_PATH in your secrets.xcconfig.}"

# Generate the token using the amtg helper [https://github.com/breakbeat-io/amtg]
APPLE_MUSIC_API_TOKEN=$($PROJECT_DIR/tools/amtg -k "$APPLE_MUSIC_KEY_ID" -t "$APPLE_DEVELOPER_TEAM_ID" -p "$APPLE_MUSIC_PRIVATE_KEY_PATH")

echo "Generating Secrets.swift"

$PROJECT_DIR/tools/sourcery/bin/sourcery \
  --sources Jewel/App/Secrets \
  --templates Jewel/App/Secrets \
  --output Jewel/App/Secrets \
  --args appleMusicAPIToken="$APPLE_MUSIC_API_TOKEN",firebaseAPIKey="$FIREBASE_API_KEY"
  
         

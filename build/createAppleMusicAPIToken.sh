#!/bin/sh

echo "Generating Apple Music API Token."

# Exit if any of the required variables are not available.
# They are set in secrets.xcconfig and made available to this script by the Xcode pre-action bootstrapping.
: "${APPLE_MUSIC_KEY_ID?Please set APPLE_MUSIC_KEY_ID in your secrets.xcconfig.}"
: "${APPLE_DEVELOPER_TEAM_ID?Please set FASTLAPPLE_DEVELOPER_TEAM_IDANE_USER in your secrets.xcconfig.}"
: "${APPLE_MUSIC_PRIVATE_KEY_PATH?Please set APPLE_MUSIC_PRIVATE_KEY_PATH in your secrets.xcconfig.}"

# Generate the token using the amtg helper [https://github.com/breakbeat-io/amtg]
JWT=$($PROJECT_DIR/build/amtg -k "$APPLE_MUSIC_KEY_ID" -t "$APPLE_DEVELOPER_TEAM_ID" -p "$APPLE_MUSIC_PRIVATE_KEY_PATH")

# Simply delete any existing key/token instead of fannying wtih fancy regex to update an existing value
sed -i '' "/APPLE_MUSIC_API_TOKEN/d" $PROJECT_DIR/Jewel/App/secrets.xcconfig

# Add the generated token as a new line
echo "APPLE_MUSIC_API_TOKEN = $JWT" >> $PROJECT_DIR/Jewel/App/secrets.xcconfig

echo "Apple Music API Token added to secrets.xcconfig successfully."

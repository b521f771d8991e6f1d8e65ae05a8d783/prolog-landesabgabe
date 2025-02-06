#!/bin/bash

# Set the target folder
TARGET_FOLDER=$1

# Check if the target folder exists, create it if not
if [ ! -d "$TARGET_FOLDER" ]; then
  mkdir -p "$TARGET_FOLDER"
fi

# Get the value of the environment variable DOTENV_PRIVATE_KEY
PRIVATE_KEY=${DOTENV_PRIVATE_KEY}

# Check if the environment variable DOTENV_PRIVATE_KEY is set
if [ -z "$PRIVATE_KEY" ]; then
  echo "Error: DOTENV_PRIVATE_KEY environment variable is not set."
  exit 1
fi

# Create the .env.keys file
cat > "$TARGET_FOLDER/.env.keys" <<EOF
#/------------------!DOTENV_PRIVATE_KEYS!-------------------/
#/ private decryption keys. DO NOT commit to source control /
#/     [how it works](https://dotenvx.com/encryption)       /
#/----------------------------------------------------------/
# .env
DOTENV_PRIVATE_KEY=$PRIVATE_KEY
EOF

echo ".env.keys file created successfully in $TARGET_FOLDER"
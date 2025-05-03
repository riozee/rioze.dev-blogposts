#!/bin/bash

# Script to extract frontmatter metadata from markdown blog posts
# and aggregate them into a single index.json file

set -e

POSTS_DIR="./posts"
OUTPUT_FILE="./index.json"

echo "Generating index.json from blog posts..."

# Check if posts directory exists
if [ ! -d "$POSTS_DIR" ]; then
  echo "Error: Posts directory not found at $POSTS_DIR"
  exit 1
fi

# Initialize JSON array
echo "[" > "$OUTPUT_FILE"

# Counter to track if we need commas between entries
COUNT=0

# Get all markdown files from posts directory
for POST_FILE in "$POSTS_DIR"/*.md; do
  # Skip if no files match
  [ -e "$POST_FILE" ] || continue
  
  # Extract the filename without extension to use as slug
  FILENAME=$(basename "$POST_FILE")
  SLUG=${FILENAME%.md}
  
  # Extract frontmatter (content between first two '---' lines)
  FRONTMATTER=$(sed -n '/^---$/,/^---$/p' "$POST_FILE" | sed '1d;$d')
  
  if [ -z "$FRONTMATTER" ]; then
    echo "Warning: No frontmatter found in $POST_FILE. Skipping..."
    continue
  fi
  
  # Add comma for all but the first entry
  if [ $COUNT -gt 0 ]; then
    echo "," >> "$OUTPUT_FILE"
  fi
  
  # Extract individual metadata fields
  TITLE=$(echo "$FRONTMATTER" | grep -E "^title:" | sed 's/^title:[[:space:]]*"\{0,1\}\([^"]*\)"\{0,1\}[[:space:]]*$/\1/')
  DATE=$(echo "$FRONTMATTER" | grep -E "^date:" | sed 's/^date:[[:space:]]*"\{0,1\}\([^"]*\)"\{0,1\}[[:space:]]*$/\1/')
  DESCRIPTION=$(echo "$FRONTMATTER" | grep -E "^description:" | sed 's/^description:[[:space:]]*"\{0,1\}\([^"]*\)"\{0,1\}[[:space:]]*$/\1/')
  
  # Extract tags as an array
  TAGS=$(echo "$FRONTMATTER" | grep -E "^tags:" | sed 's/^tags:[[:space:]]*\[\([^]]*\)\][[:space:]]*$/\1/')
  TAGS_JSON="["
  if [ ! -z "$TAGS" ]; then
    IFS=',' read -ra TAG_ARRAY <<< "$TAGS"
    TAG_COUNT=0
    for TAG in "${TAG_ARRAY[@]}"; do
      CLEAN_TAG=$(echo "$TAG" | sed 's/^[[:space:]]*"\{0,1\}\([^"]*\)"\{0,1\}[[:space:]]*$/\1/')
      if [ $TAG_COUNT -gt 0 ]; then
        TAGS_JSON+=","
      fi
      TAGS_JSON+="\"$CLEAN_TAG\""
      TAG_COUNT=$((TAG_COUNT+1))
    done
  fi
  TAGS_JSON+="]"
  
  # Create JSON object for the post and append to output file
  cat >> "$OUTPUT_FILE" << EOF
  {
    "slug": "$SLUG",
    "title": "$TITLE",
    "date": "$DATE",
    "description": "$DESCRIPTION",
    "tags": $TAGS_JSON
  }
EOF
  
  COUNT=$((COUNT+1))
done

# Close JSON array
echo -e "\n]" >> "$OUTPUT_FILE"

echo "Successfully generated index.json with $COUNT blog posts."

# Make the script executable
chmod +x "$0"
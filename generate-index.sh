#!/bin/bash

# Script to extract frontmatter metadata from multilingual markdown blog posts
# and aggregate them into a single index.json file

set -e

POSTS_DIR="./posts"
OUTPUT_FILE="./index.json"

echo "Generating index.json from multilingual blog posts..."

# Check if posts directory exists
if [ ! -d "$POSTS_DIR" ]; then
  echo "Error: Posts directory not found at $POSTS_DIR"
  exit 1
fi

# Initialize JSON array
echo "[" > "$OUTPUT_FILE"

# Counter to track if we need commas between entries
COUNT=0

# Get all post directories
for POST_DIR in "$POSTS_DIR"/*; do
  # Skip if no directories match or if it's not a directory
  [ -d "$POST_DIR" ] || continue
  
  # Get the post slug from directory name
  SLUG=$(basename "$POST_DIR")
  
  # Add comma for all but the first entry
  if [ $COUNT -gt 0 ]; then
    echo "," >> "$OUTPUT_FILE"
  fi
  
  # Start JSON object for the post
  cat >> "$OUTPUT_FILE" << EOF
  {
    "slug": "$SLUG",
    "translations": {
EOF
  
  # Process each language version
  LANG_COUNT=0
  for LANG_FILE in "$POST_DIR"/*.md; do
    # Skip if no files match or if it's not a file
    [ -f "$LANG_FILE" ] || continue
    
    # Extract language code from filename (format: lang.md)
    LANG_CODE=$(basename "$LANG_FILE" .md)
    
    # Extract frontmatter (content between first two '---' lines)
    FRONTMATTER=$(sed -n '/^---$/,/^---$/p' "$LANG_FILE" | sed '1d;$d')
    
    if [ -z "$FRONTMATTER" ]; then
      echo "Warning: No frontmatter found in $LANG_FILE. Skipping..."
      continue
    fi
    
    # Extract individual metadata fields
    TITLE=$(echo "$FRONTMATTER" | grep -E "^title:" | sed 's/^title:[[:space:]]*"\{0,1\}\([^"]*\)"\{0,1\}[[:space:]]*$/\1/' | sed 's/"/\\"/g')
    DATE=$(echo "$FRONTMATTER" | grep -E "^date:" | sed 's/^date:[[:space:]]*"\{0,1\}\([^"]*\)"\{0,1\}[[:space:]]*$/\1/')
    DESCRIPTION=$(echo "$FRONTMATTER" | grep -E "^description:" | sed 's/^description:[[:space:]]*"\{0,1\}\([^"]*\)"\{0,1\}[[:space:]]*$/\1/' | sed 's/"/\\"/g')
    
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
    
    # Add comma between language entries
    if [ $LANG_COUNT -gt 0 ]; then
      echo "," >> "$OUTPUT_FILE"
    fi
    
    # Add language-specific metadata
    cat >> "$OUTPUT_FILE" << EOF
      "$LANG_CODE": {
        "title": "$TITLE",
        "date": "$DATE",
        "description": "$DESCRIPTION",
        "tags": $TAGS_JSON
      }
EOF
    
    LANG_COUNT=$((LANG_COUNT+1))
  done
  
  # Close translations object and post object
  cat >> "$OUTPUT_FILE" << EOF
    }
  }
EOF
  
  COUNT=$((COUNT+1))
done

# Close JSON array
echo -e "\n]" >> "$OUTPUT_FILE"

echo "Successfully generated index.json with $COUNT multilingual blog posts."

# Make the script executable
chmod +x "$0"
#!/bin/bash

# Number of days to go back
DAYS_BACK=100
# Number of days to randomly select for commits
SELECTED_DAYS=70

# Check if there are any commits
if [ "$(git log --oneline 2>/dev/null | wc -l)" -eq 0 ]; then
  # If no commits, create an initial commit
  git commit --allow-empty -m "Initial commit"
fi

# Randomly select 70 days within the last 100 days
selected_days=($(seq 0 $((DAYS_BACK-1)) | shuf | head -n $SELECTED_DAYS))

# Loop through the selected days and update commits
for day in "${selected_days[@]}"; do
  # Generate a random number between 5 and 10 for the commit count
  COMMIT_COUNT=$(( ( RANDOM % 6 ) + 5 ))

  # Generate a dynamic commit message
  COMMIT_MESSAGE="Update LMS content for $(date -d "$day days ago" "+%Y-%m-%d")"

  # Add commits for the current day
  for ((j = 0; j < $COMMIT_COUNT; j++)); do
    git commit --allow-empty -m "$COMMIT_MESSAGE" --date="$(date -d "$day days ago" "+%Y-%m-%dT%H:%M:%S")"
  done
done

# Force push the changes
git push origin main --force

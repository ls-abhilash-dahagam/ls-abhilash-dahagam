#!/bin/bash
# .scripts/update-repos.sh

echo "Fetching recent public repositories..."

# 1. Fetch the 5 most recently pushed public repositories (excluding forks)
# 2. Format the output directly into Markdown bullet points using jq
REPO_LIST=$(gh repo list ls-abhilash-dahagam --visibility public --source --limit 5 --sort pushed --json name,description,url --jq '.[] | "- [**\(.name)**](\(.url)) - \(.description // "No description provided.")"')

echo "Updating README.md..."

# 3. Inject the formatted list into the README between the START and END markers
awk -v insert="$REPO_LIST" '
    // { print; print insert; skip=1; next }
    // { skip=0 }
    !skip { print }
' README.md > temp.md && mv temp.md README.md

echo "README updated successfully!"

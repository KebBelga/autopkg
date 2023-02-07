#!/bin/bash

current_repo_url=$(sudo defaults read "/Library/Preferences/ManagedInstalls.plist" SoftwareRepoURL)
current_client_id=$(sudo defaults read "/Library/Preferences/ManagedInstalls.plist" ClientIdentifier)

if [ "$current_repo_url" != "http://10.10.50.12/munki_repo" ] || [ "$current_client_id" != "site-default" ]; then
  sudo defaults write "/Library/Preferences/ManagedInstalls.plist" SoftwareRepoURL "http://10.10.50.12/munki_repo"

  sudo defaults write "/Library/Preferences/ManagedInstalls.plist" ClientIdentifier "site-default"

  echo "Verifying the changes..."
  sudo defaults read "/Library/Preferences/ManagedInstalls.plist"
else
  echo "Values are already correct, no action required."
fi


if sudo systemsetup -getremotelogin | grep -q "Remote Login: On"; then
  echo "SSH is already enabled"
  exit 0
fi

sudo systemsetup -setremotelogin on

if sudo systemsetup -getremotelogin | grep -q "Remote Login: On"; then
  echo "Successfully enabled SSH"
  exit 0
else
  echo "Failed to enable SSH"
  exit 1
fi



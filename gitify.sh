#!/bin/bash

# Configuration
gitHubOrganisation=https://github.com/qbcore-framework # The GitHub organisation to use
qbDirectory=/root/fivem_server/fx_v5848/txData/QBCore/resources/[qb] # The directory to loop through
remoteName=origin # The name of the remote to add (origin, upstream, etc)
resetOrigins=false # Set to true to remove any existing origins
sleepDuration=0.25 # Time to wait between each resource

echo -e "\r\n📁  QB Directory: $qbDirectory \r\n"
read -p "⁉️  Please confirm you wish to create git origins for each resource (y/n)?" choice
echo # Blank line
case "$choice" in 
  y|Y ) echo continue;;
  n|N ) echo "Exiting..."; exit 1;;
  * ) echo "Exiting..."; exit 1;;
esac

echo "Changing Directory into QBCore Directory";
cd $qbDirectory;

# Loop around each directory in the qbDirectory variable
for resource in */ ; do
    # Skip symlinked directories
    [ -L "${d%/}" ] && continue

    # Strip the trailing slash
    resource=${resource%/}
    resourceDirectory=$qbDirectory/$resource

    echo -e "\r\n---------------------------------------------------------------------------\r\n"
    echo "📗  Found: $resource ($resourceDirectory)"

    # Conditionally remove the .git directories
    # [ killGitDirectories ] && echo "🗑️ Killing .git folder ($resourceDirectory/.git)" && rm -rf $resourceDirectory/.git

    # Initialize Git
    if [ ! -d ".git" ]; then
        git init
    else 
        echo "⏭️  Git already initialized for $resource"

        if $resetOrigins; then 
            echo "🔄  Resetting remote for $resource"
            git -C $resourceDirectory remote remove origin
        fi

        # Check if git currently has an origin set
        if [ -z "$(git -C $resourceDirectory config --get remote.origin.url)" ]; then
            originUrl=$gitHubOrganisation/$resource.git
            echo "➕  Adding origin to $resource (originUrl)"
            git -C $resourceDirectory remote add origin $originUrl
        else
            echo "⏭️  Remote already set for $resource"
        fi 
    fi

    git -C $resourceDirectory remote get-url origin

    sleep $sleepDuration
done

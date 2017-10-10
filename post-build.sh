#!/bin/bash

# Function to SSH into the bastion and master maachine
# This function will rollout the update and rollback the update.
# To rollout the update
# Set Environment Variable DEPLOYMENT_UPDATE to "update" and to rollback set to "rollback"
ENV="production"
ENVTEST="test"
DATE=`date +%Y%m%d`

function applyUpdate() {

    echo $1 $2 $3 $4 $5 $6
    if [ "$4" == "update" ]; then
      git clone $1
      kubectl apply -f $2/kubernetes/app/
      kubectl set image deployment/hello-world hello-world=kubejack/helloworld-production:$5$6 --namespace production
      rm -rf $2
    elif [ "$6" == "rollback" ]; then
      kubectl rollout undo deployments/hello-world --namespace production
    fi
}

applyUpdate $REPO_HTTPS_URL $REPO_NAME $USERNAME $DEPLOYMENT_TYPE $DATE $BUILD_NUMBER

#!/bin/bash
set -e  # Exit on error

# Create scratch org (use default dev hub or specify with -v flag)
# Note: Requires sourceApiVersion: "66.0" in sfdx-project.json for Wave dashboards
echo "Creating scratch org..."
#sf org create scratch --definition-file config/project-scratch-def.json --duration-days 30 --target-dev-hub alm_demo_hub_org_2 --set-default --alias cee-scratch
sf demoutil org create scratch -f config/project-scratch-def.json -d 5 -s -p flow -e platformfreetrial.demo
# Deploy source (Wave will fail but that's OK - we'll deploy it after permissions)
echo "Deploying metadata..."
set +e  # Temporarily allow errors
sf project deploy start --wait 10
DEPLOY_EXIT=$?
set -e  # Re-enable error handling

# If deployment failed due to Wave permissions, that's expected - continue
if [ $DEPLOY_EXIT -ne 0 ]; then
    echo "Initial deployment had errors (expected if Wave was included). Continuing..."
fi

# Assign permission sets
echo "Assigning permission sets..."
sf org assign permset -n ConnectedExecutiveEducationAccess || true
sf org assign permset -n EventMonitoringPermSet || true
sf org assign permset -n EinsteinAnalyticsPlusAdmin || true

# Wait a moment for permissions to propagate
echo "Waiting for permissions to propagate..."
sleep 5

# Deploy Wave applications and dashboards (now that permissions are assigned)
echo "Deploying Wave applications and dashboards..."
sf project deploy start --source-dir force-app/main/default/wave --wait 10

# Import test data
echo "Importing test data..."
sf data tree import -p data/masterImportPlan.json

# Open the org
echo "Opening org..."
sf org open -p lightning/n/Free_Trial_Guide

echo "✅ Setup complete!"

#!/bin/bash
# set -e  # Exit on error

# Create scratch org (use default dev hub or specify with -v flag)
# Note: Requires sourceApiVersion: "66.0" in sfdx-project.json for Wave dashboards
# echo "Creating scratch org..."
sf demoutil org create scratch -f config/project-scratch-def.json -d 5 -s -p flow -e platformfreetrial.demo
# sf org create scratch --definition-file config/project-scratch-def.json --duration-days 30 --target-dev-hub alm_demo_hub_org_2 --set-default --alias cee-scratch-8

# Deploy everything except Wave (Wave needs permissions first)
# echo "Deploying metadata (excluding Wave)..."
sf project deploy start --manifest manifest/base-package.xml

# Assign permission sets
# echo "Assigning permission sets..."
sf org assign permset -n ConnectedExecutiveEducationAccess 
sf org assign permset -n EventMonitoringPermSet
sf org assign permset -n EinsteinAnalyticsPlusAdmin || true

# Wait a moment for permissions to propagate
# echo "Waiting for permissions to propagate..."
sleep 5

# Deploy Wave applications and dashboards (now that permissions are assigned)
# echo "Deploying Wave applications and dashboards..."
sf project deploy start --source-dir wave-app

# Import test data
# echo "Importing test data..."
sf data tree import -p data/masterImportPlan.json

# Open the org
# echo "Opening org..."
sf org open -p lightning/n/Free_Trial_Guide

# echo "✅ Setup complete!"

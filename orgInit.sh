#!/bin/bash

# Create scratch org (use default dev hub or specify with -v flag)
#sf org create scratch --definition-file config/project-scratch-def.json --duration-days 30 --wait 60 --target-dev-hub alm_demo_hub_org_2 --set-default --alias cee-scratch-4
sf demoutil org create scratch -f config/project-scratch-def.json -d 5 -s -p flow -e platformfreetrial.demo

# Deploy source (excluding Wave apps and dashboards - they need permissions first)
sf project deploy start

# Assign permission set
sf org assign permset -n ConnectedExecutiveEducationAccess
sf org assign permset -n EventMonitoringPermSet
sf org assign permset -n EinsteinAnalyticsPlusAdmin

# Deploy Wave applications and dashboards (now that permissions are assigned)
# Temporarily remove all Wave exclusions
grep -v "wave" .forceignore > .forceignore.tmp && mv .forceignore.tmp .forceignore || true
sf project deploy start --source-dir force-app/main/default/wave
# Restore exclusions for future deployments
echo "" >> .forceignore
echo "# Wave apps and dashboards (excluded from initial deployment)" >> .forceignore
echo "**/wave/*.wapp-meta.xml" >> .forceignore
echo "**/wave/AdoptionAndUserJourneys.wdash" >> .forceignore
echo "**/wave/AdoptionAndUserJourneys.wdash-meta.xml" >> .forceignore
echo "**/wave/PerformanceAndHealth.wdash" >> .forceignore
echo "**/wave/PerformanceAndHealth.wdash-meta.xml" >> .forceignore
echo "**/wave/ThreatsAndAccess.wdash" >> .forceignore
echo "**/wave/ThreatsAndAccess.wdash-meta.xml" >> .forceignore

# Import test data
sf data tree import -p data/masterImportPlan.json

# Open the org
sf org open -p lightning/n/Free_Trial_Guide

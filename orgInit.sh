sfdx force:org:create -s -f config/project-scratch-def.json -d 7 --wait 60
sfdx force:source:push

sfdx force:user:permset:assign -n TrialAdmin
# sfdx force:apex:execute -f SetupScripting/apexDeletions.cls
sfdx force:data:tree:import -p data/masterImportPlan.json

sfdx force:apex:execute -f SetupScripting/urlSetup.cls &
sfdx force:org:open -p one/one.app#/n/Start

sleep 0.1 && sfdx force:user:create -f config/userDef/cloudy-user-def.json && sfdx shane:user:photo -f assets/cloudy-profile.png -l Cloudy &
sleep 0.1 && sfdx force:user:create -f config/userDef/codey-user-def.json && sfdx shane:user:photo -f assets/codey-profile.png  -l CodeBear &
sleep 0.1 && sfdx force:user:create -f config/userDef/astro-user-def.json && sfdx shane:user:photo -f assets/astro-profile.png  -l Nomical &

# install packages

# volunteering
sfdx force:package:install --package 04t6A000001Uee5QAC -w 20
sfdx force:user:permset:assign -n VolunteeringApp
sfdx force:data:tree:import -p data/volunteeringApp/VolunteerImportPlan.json
sfdx force:apex:execute -f SetupScripting/VolunteerSetupScript.cls &

# recruiting
sfdx force:package:install --package 04t6A000001Uee0QAC -w 20
sfdx force:user:permset:assign -n Referrals && sfdx force:data:bulk:upsert -f data/referrals.csv -s Referral__c -i Id &
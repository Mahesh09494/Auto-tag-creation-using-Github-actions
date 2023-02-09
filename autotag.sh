#!/bin/sh -l

previous_tag=v16-env-v0.0.0-dy-b9

echo "previous_tag : $previous_tag"; echo; echo;


echo 'Base Version from Previous Tag: '
base_version_from_prev_tag=$(echo ${previous_tag%?} | awk '{split($0,a,"-"); print a[1]}' | cut -c2-)
echo $base_version_from_prev_tag; echo;

echo 'Env Veresion from Previous Tag: '
env_version_from_prev_tag=$(echo ${previous_tag} | tr "env-v" "\n" | awk 'END{print}' | tr "-" "\n" | awk '{print;exit}')
echo $env_version_from_prev_tag; echo;

echo 'Bundle Veresion from Previous Tag: '
bundle_version_from_prev_tag=$(echo ${previous_tag} | awk '{split($0,a,"-"); print a[5]}' | cut -c2-)
echo $bundle_version_from_prev_tag; echo;
		  
env_version_from_source=$(sed -n '2p' main.tf | tr "v" "\n" | awk 'END{print}')
echo 'Extracting Env Version from Source: '
env_version_from_source=$(echo ${env_version_from_source%?})
echo $env_version_from_source; echo;


bundle_version_from_source=$(sed -n '6p' main.tf | tr "=" "\n" | awk 'END{print}' | cut -c2-)
echo 'Extracting Bundle Version from Source: '
bundle_version_from_source=$(echo ${bundle_version_from_source%?})
echo $bundle_version_from_source; echo; echo;

if [[ "$env_version_from_prev_tag" == *"$env_version_from_source"* ]]; then
 echo "Env Versions Are Same!! Env Version Will Not Be Increased"
else
 echo; echo 'New Env Version Found: '$env_version_from_source; echo;
fi

if [[ "$bundle_version_from_prev_tag" == *"$bundle_version_from_source"* ]]; then
 echo "Bundle Versions Are Same!! Bundle Version Will Not Be Increased"
else
 echo; echo 'New Bundle Version Found: '; echo $bundle_version_from_source; echo; echo;
fi

let "new_base_version_from_prev_tag=base_version_from_prev_tag+1"


echo 'New Base Version WIll Be: '$new_base_version_from_prev_tag;

echo 'New Base Version WIll Be: '$base_version_from_prev_tag;

echo; echo; 
new_tag=v$new_base_version_from_prev_tag-env-v$env_version_from_source-dy-b$bundle_version_from_source
echo 'New Tag Will Be: ' $new_tag
git tag $new_tag 
git push origin $new_tag

#! /usr/bin/env bash
export $(grep -v '^#' .env | xargs)

sls plugin install --name serverless-dotenv-plugin
sls plugin install --name serverless-python-requirements


echo Hello, can I sls deploy?
read -e -i "yes" answer
if [ $answer == "yes" ]
then
    sls deploy
fi
# if [[ "$PWD" != *"terraform" ]]; then
#     cd terraform
# fi
echo Hello, can I upload form.js file?
read -e -i "yes" answer
if [[ $answer == 'yes' ]]; then
    echo uploading...
    terraform -chdir=terraform init
    terraform -chdir=terraform apply --auto-approve
fi
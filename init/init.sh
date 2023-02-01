#/bin/bash


echo starting
check=1
while [ ${check} == 1 ]
do
check=0
sudo docker ps || { check=1 ; }
sleep 1
done

sudo usermod -aG docker $USER
sudo docker load -i $(pwd)/image.tar
sudo apt install awscli -y 
check=1
while [ ${check} == 1 ]
do
check=0
aws --version || { check=1 ; }
sleep 1
done
aws ecr get-login-password --region eu-west-3 | docker login --username AWS --password-stdin 644435390668.dkr.ecr.eu-west-3.amazonaws.com
tar -xvzf start_to_ec2.tar.gz
tar -xvzf templates.tar.gz

export VERSION_COMP=$1 && sudo docker compose -f docker-compose-prod.yaml build --no-cache
export VERSION_COMP=$1 && sudo docker compose -f docker-compose-prod.yaml up -d


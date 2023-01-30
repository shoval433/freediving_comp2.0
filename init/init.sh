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

check=1
aws ecr get-login-password --region eu-west-3 | docker login --username AWS --password-stdin 644435390668.dkr.ecr.eu-west-3.amazonaws.com
tar -xvzf start_to_ec2.tar.gz
tar -xvzf templates.tar.gz
export VERSION_COMP=$1
docker compose -f docker-compose-prod.yaml up --build -d
# while [ ${check} == 1 ]
# do
# check=0
# sudo docker-compose up -d  || { check=1 ; }
# sleep 1
# done
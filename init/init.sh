#/bin/bash


echo starting
check=1
while [ ${check} == 1 ]
do
check=0
sudo docker ps || { check=1 ; }
sleep 1
done

# sudo usermod -aG docker $USER
# sudo docker load -i $(pwd)/image.tar
# sudo apt install awscli -y 

check=1
while [ ${check} == 1 ]
do
check=0
aws --version || { check=1 ; }
sleep 1
done
echo "login-aws"
sleep 5
aws ecr get-login-password --region eu-west-3 | docker login --username AWS --password-stdin 644435390668.dkr.ecr.eu-west-3.amazonaws.com
echo "open tar"
sleep 5
tar -xvzf start_to_ec2.tar.gz
tar -xvzf templates.tar.gz
echo "tar is open"
sleep 5
echo "try docker-compose"
sleep 5
check=1
sudo chmod 666 /var/run/docker.sock
 while [ ${check} == 1 ]
 do
 echo "try"
 check=0
 docker run --rm hello-world &> /dev/null || { check=1 ; }
 sleep 1
 done
#  help
# sudo usermod -aG docker $USER
# newgrp docker
# sudo service docker restart
sleep 5
echo "docker-compose is up"
sleep 5
echo "start app"
sleep 5
aws ecr get-login-password --region eu-west-3 | docker login --username AWS --password-stdin 644435390668.dkr.ecr.eu-west-3.amazonaws.com
# export VERSION_COMP=$1 && docker compose -f docker-compose-prod.yaml up --build -d
# check=1
# while [ ${check} == 1 ]
#  do
#  check=0
# export VERSION_COMP=$1 && docker compose -f docker-compose-prod.yaml up --build -d|| { check=1 ; }
#  sleep 1
#  done
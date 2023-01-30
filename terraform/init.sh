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
# while [ ${check} == 1 ]
# do
# check=0
# sudo docker-compose up -d  || { check=1 ; }
# sleep 1
# done

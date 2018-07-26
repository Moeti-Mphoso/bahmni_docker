#!/usr/bin/env bash
export container_name=openmrseregister
export bind_mount_src=Users/mac/Documents/Spane/eregisterDev/host
export bind_mount_dest=development
export https_port=443
export http_port=81
export erp_port=8069
export debug_port=8000
export image_name=omrsregrepo/bahmni_centosls:69_230718

# check for files in current directory (backup.sql, local, blabla - if not get from git, else stop)

if sudo docker ps | grep ${container_name}; then
   sudo docker stop "${container_name}" | sudo xargs docker rm
else
  echo "Container not exists"
fi

if sudo docker ps | grep ${container_name}; then
   sudo docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs sudo docker rm
else
  echo "Exit container not present"
fi

if sudo docker images | grep ${image_name}; then
   sudo docker rmi $(sudo docker images | grep ${images_name} | tr -s ' ' | cut -d ' ' -f 3)
else
  echo "Image doesn't exists"
fi

if ! sudo docker volume ls -q --filter name="${container_name}"| grep -q "${container_name}" ; then
        sudo docker volume create --name ${container_name}
else
        echo "Volume ${container_name} exists"
fi
docker build --rm -t $image_name --build-arg container_name=${container_name} --build-arg mighty=moeti --build-arg bind_mount_dest=$bind_mount_dest .
docker run -e container_name=${container_name} -e bind_mount_dest=${bind_mount_dest} -it -d -p ${https_port}:443 -p ${http_port}:80 -p ${erp_port}:8069 -p ${debug_port}:8000 --privileged --name $container_name -v /$bind_mount_src:/$bind_mount_dest -v $container_name:/$container_name $image_name /bin/bash
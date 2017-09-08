# Install and run MarketplaceCore database server

## download docker image and setup new container "marketplacecore"
    docker run -p 5432:5432 -e POSTGRES_PASSWORD="password" --name "marketplacecore" postgres

## list docker containers
    docker container ls -la

## start docker container
    docker start marketplacecore

## stop docker container
    docker stop marketplacecore

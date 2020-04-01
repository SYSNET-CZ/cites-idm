# fortress

    cd fortress
    docker build -t sysnetcz/fortress .
    docker run -d --name fortress --network elk_elastic -t sysnetcz/fortress

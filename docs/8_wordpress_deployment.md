# Load WordPress docker image into cluster

    moop@devbox:~/Desktop/sysadmin_package$ docker pull wordpress
    Using default tag: latest
    latest: Pulling from library/wordpress
    1efc276f4ff9: Pull complete 
    3239fd0772e9: Pull complete 
    52ccb8ba6c06: Pull complete 
    e907707b68ee: Pull complete 
    f001901b2b66: Pull complete 
    3926f8e80674: Pull complete 
    abc6b8b3381c: Pull complete 
    f2aef5a590dd: Pull complete 
    4739a6591a8b: Pull complete 
    1c4c634ab8e6: Pull complete 
    d84f48c0548d: Pull complete 
    774f9d29e73c: Pull complete 
    06e87fefb4ab: Pull complete 
    382fb5566e86: Pull complete 
    b3b5294242c6: Pull complete 
    730f2c6e6033: Pull complete 
    019b868fd241: Pull complete 
    a217ccc0a4bc: Pull complete 
    8f70b51d2ae5: Pull complete 
    6c2fa69a7ed1: Pull complete 
    6a8eb3d78340: Pull complete 
    Digest: sha256:461fb4294c0b885e375c5d94521442fce329cc02ef3f49a8001ea342d14ab71a
    Status: Downloaded newer image for wordpress:latest
    docker.io/library/wordpress:latest

    moop@devbox:~/Desktop/sysadmin_package$ ./bin/kind load docker-image wordpress --name meeplabben
    Image: "wordpress" with ID "sha256:66b89e8b083b68f0bc8c80a4190bc16a72368a1b44e04b1ed625d954a854c9ea" not yet present on node "meeplabben-control-plane", loading...


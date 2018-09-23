# Instructions for Local Development

1. Install [Docker](https://docs.docker.com/install/) on your local machine and make sure you can run `docker-compose` via the command line.


2. Clone the git project to your local machine: 
    
    `git clone https://github.com/david542542/datadocs-web`


3. Move into the project directory and run docker-compose:

    `cd datadocs-web`
    
    `docker-compose up webserver`
    
*Note: if for whatever reason, you need to change the gulpfile and re-run the docker container, you can delete the docker container by running `docker rmi -f datadocs-web_webserver` and re-running `docker-compose up webserver`.*
    

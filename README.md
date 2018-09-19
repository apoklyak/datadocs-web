# Instructions for local/development environment

1. Ensure you have nodejs, npm, gulp installed in your workstation (Following are the version application was tested and working)

    1a. Install NodeJS LTS (Long Term Support) version  from https://nodejs.org/en/
    
        $ node -v
           v8.11.2 [Version with which application is verified]
        $ npm -v
           5.6.0
            
    1b. Install gulp CLI and gulp using `sudo npm install gulp-cli -g` and `sudo npm install gulp -D`  
        
        $ gulp -v
         CLI version 2.0.1
         Local version 3.9.1
        
2. Make sure datadocs-backend is up and running and listening on `http://localhost:9100`. If you want change the host or port of backend server then you can do so in gulpfile.js file residing in project root. For example: replace **`http://localhost:9100`** with **`https://dev.datadocs.com`**  
3. Run `npm install` from project root directory
4. Run `gulp watch` from project root (i.e. datadocs-web)
5. As soon as you see `Finished 'watch' after 5.84 μs` message in terminal, Front end should be up and listening on `http://localhost:8283`
6. Hit http://localhost:8283 in browser. You are all set if you see login page with appropriate style.

Development in action

7. Modify any label in `datadocs-web/src/templates/auth/login.html` For example change "Sign in to Datadocs" -> "Sign in to your Account"
8. Move cursor off the file (or switch screen to browser) and rebuilding of static resources should trigger (observe in front-end terminal from where `gulp watch` was invoked)
9. Refresh http://localhost:8283 and see the change in effect

#Steps for setup frontend project on Nginx:

1. Install nginx

	For linux:
		
		sudo apt-get install nginx

	For mac:

		brew install nginx

2. Build the project using below command from project root directory
	
	    /usr/local/bin/gulp release

3. Create  directory by using below command:
	
	    sudo mkdir /var/www/datadocs

4. Copy "build" directory from project root
	    
	    sudo cp -a build/ /var/www/datadocs/

5. Create the datadocs.com file
	
	For linux:

		sudo nano /etc/nginx/sites-enabled/datadocs.com
	
	For Mac:

		sudo nano /usr/local/etc/nginx/sites-enabled/datadocs.com
		
		or add server entry in
		
		sudo nano /usr/local/etc/nginx/nginx.conf

6. Put the below configuration inside it and Save it. 
	
	Nginx config with SSL 
	
	```
	server {
       
        server_name  <SERVER_DOMAIN_NAME>;
        listen [::]:443 ssl ipv6only=on; # managed by Certbot
        listen 443 ssl; # managed by Certbot
        ssl_certificate /etc/letsencrypt/live/dev.datadocs.com/fullchain.pem; # managed by Certbot
        ssl_certificate_key /etc/letsencrypt/live/dev.datadocs.com/privkey.pem; # managed by Certbot
        include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
        ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
        #charset koi8-r;
        #access_log  logs/host.access.log  main;
        root /var/www/datadocs;
 
            location / {
                  root /var/www/datadocs;
                  index index.html index.htm;
          include mime.types;
            }
        location ~ \.css {
           add_header  Content-Type    text/css;
        }
        location /api {
            proxy_pass http://<API_SERVER_IP>:<API_SERVER_PORT>;
        }  
        location /websocket {
            proxy_pass http://<API_SERVER_IP>:<API_SERVER_PORT>;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "Upgrade";
        }
        #error_page  404              /404.html;
        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
    ```
    
    Nginx config without SSL
    
    ```server {
       
        server_name  <SERVER_DOMAIN_NAME>;
        listen [::]:8080;
        
        root /var/www/datadocs;
 
            location / {
                  root /var/www/datadocs;
                  index index.html index.htm;
          include mime.types;
            }
        location ~ \.css {
           add_header  Content-Type    text/css;
        }
        location /api {
            proxy_pass http://<API_SERVER_IP>:<API_SERVER_PORT>;
        }  
        location /websocket {
            proxy_pass http://<API_SERVER_IP>:<API_SERVER_PORT>;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "Upgrade";
        }
        #error_page  404              /404.html;
        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }```  

7. Start the nginx server:
	
	For linux :

		sudo systemctl start nginx
	
	For mac:

		sudo nginx

8. Hit URL http(s):<SERVER_HOST>:<PORT>:/. You're good if shows login page with correct CSS.

9. Ensure to have API server up and running on API_SERVER_IP:API_SERVER_PORT in order to have features working

#Steps for setup frontend project on OSX:

## prerequisite
1. Docker and docker-compose should be installed in machine.
2. Assuming that datadocs-backend should be listening on `http://<host-IP>:9100` URL.

##Steps
1. Go to the datadocs-web directory.
2. Replace `http://localhost:9100` by `http://<host-IP>:9100` in gulpfile.js file.
3. execute `docker-compose up webserver`.
4. As soon as you see `READY -- TEST IT ON LOCALHOST:8283` message in terminal, Front end should be up and listening on `http://localhost:8283`
5. Hit http://localhost:8283 in browser. You are all set if you see login page with appropriate style.
6. You can make changes in the templates/css/js files inside src
7. In couple of seconds, you should be able to refresh the browser and see the change. 

#Steps for setup frontend project on Windows:

## prerequisite

1. Docker and docker-compose should be installed in windows machine.
2. If not installed, follow the steps from [Install Docker Toolbox on Windows](https://docs.docker.com/toolbox/toolbox_install_windows/).
3. Assuming that datadocs-backend should be listening on `http://<host-IP>:9100` URL.

##Steps

1. Add port forwarding rule to expose `8283` from docker machine to host machine. Follow below steps.

        1. Go to VirtualBox -> Your BOX -> Settings -> Network ->
        2. Choose NAT
        3. Open Advanced
        4. Click Port Forwarding
        5. Add new rule to map `8283` port you need from host to guest
        6. Click OK to save the changes.
        7. Then stop the virtual box.(Right click on virtual nox -> Close -> Power Off)
        8. Start Docker Quikstart Terminal
        
2. Ensure that the frontend directory should be inside the same directory where docker is installed. (default- C://User/username)
3. Go to the datadocs-web directory.
4. Replace `http://localhost:9100` by `http://<host-IP>:9100` in gulpfile.js file.
5. execute `docker-compose up webserver`.
6. As soon as you see `READY -- TEST IT ON LOCALHOST:8283` message in terminal, Front end should be up and listening on `http://localhost:8283`
7. Hit http://localhost:8283 in browser. You are all set if you see login page with appropriate style.
8. You can make changes in the templates/css/js files inside src
9. In couple of seconds, you should be able to refresh the browser and see the change.

# Connect dev server from local datadocs-frontend.

1. Replace proxy settings in gulpfile.js -> server task -> middleware 

        proxy('/api', {
          target: 'https://dev.datadocs.com',
          changeOrigin: true
        }),
         proxy('/share', {
          target: 'https://dev.datadocs.com',
          changeOrigin: true
        }),
        proxy('/websocket', {
          target: 'https://dev.datadocs.com',
          changeOrigin:true,
          ws: true      // <-- set it to 'true' to proxy WebSockets
        })
2. Remove docker container for webserver using `docker rmi -f datadocs-web_webserver` 
3. Start again using `docker-compose up webserver`.
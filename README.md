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

6. Put the below configuration inside it and Save it.
	
	```
	server {
       
        server_name  dev.datadocs.com;
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
    
    Config without SSL
    
    ```server {
       
        server_name  local.datadocs.com;
        listen [::]:80;
        
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


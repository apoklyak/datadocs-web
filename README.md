# Instructions for local/development environment

1. Ensure you have nodejs, npm, gulp installed in your workstation (Following are the version application was tested and working)

    gulp -v
     CLI version 2.0.1
     Local version 3.9.1
    node -v
       v8.11.2
    npm -v
       5.6.0
2. Make sure datadocs-backend is up and running and listening on `http://localhost:9100`
3. Run `gulp watch` from project root (i.e. datadocs-web)
4. As soon as you see `Finished 'watch' after 5.84 μs` message in terminal, Front end should be up and listening on `http://localhost:8283`
5. Hit http://localhost:8283 in browser. You are all set if you see login page with appropriate style.

Development in action

6. Modify any label in `datadocs-web/src/templates/auth/login.html` For example change "Sign in to Datadocs" -> "Sign in to your Account"
7. Move cursor off the file (or switch screen to browser) and rebuilding of static resources should trigger (observe in front-end terminal from where `gulp watch` was invoked)
8. Refresh http://localhost:8383 and see the change in effect

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

server {

        listen       80;
        server_name  localhost;


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
            proxy_pass http://10.138.0.7:9100;
        }
        location /websocket {
            proxy_pass http://10.138.0.7:9100;
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
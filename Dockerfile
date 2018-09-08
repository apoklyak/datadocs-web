FROM nginx:1.15.2

ADD build /var/www/datadocs
ADD conf /etc/nginx/conf.d
RUN rm -rf etc/nginx/conf.d/default.conf
FROM nginx:latest

COPY ./site.conf /etc/nginx/conf.d/00-site.conf
RUN rm -f /etc/nginx/conf.d/default.conf

# Set working directory
WORKDIR /etc/nginx

# Execute command
CMD ["nginx", "-g", "daemon off;"]

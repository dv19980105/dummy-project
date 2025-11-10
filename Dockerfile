# Dockerfile
FROM nginx:alpine

# Copy a simple static page into nginx's default directory
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

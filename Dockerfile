# build stage
FROM node:lts-alpine as build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# production stage
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
#CMD ["nginx", "-g", "daemon off;"]

# Overriding the default NGINX container behavior
COPY ./replace_env_vbles.sh /replace_env_vbles.sh
RUN chmod +x /replace_env_vbles.sh
ENTRYPOINT ["/replace_env_vbles.sh"]

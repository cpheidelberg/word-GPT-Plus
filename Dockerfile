FROM node:22.21.1-alpine3.22 AS build-stage
WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn config set network-timeout 300000
RUN apk add g++ make py3-pip
RUN yarn global add node-gyp@10
RUN yarn install
COPY . .
RUN yarn run build

FROM nginx:alpine
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

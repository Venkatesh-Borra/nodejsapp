FROM node:alpine AS build
WORKDIR /app
COPY package.json  ./
RUN npm install
COPY . .
RUN npm run build
EXPOSE 80
LABEL maintainer="NANI"

FROM nginx:alpine
COPY --from=build /app /usr/share/nginx/html

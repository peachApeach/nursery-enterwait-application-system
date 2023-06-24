FROM node:hydrogen-alpine3.18
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci --omit-dev
COPY . .
EXPOSE 3000
CMD [ "node", "app.js" ]

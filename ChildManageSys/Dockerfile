FROM node:hydrogen-alpine3.18
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --omit-dev --no-optional
COPY . .
EXPOSE 4000
CMD [ "node", "app.js" ]
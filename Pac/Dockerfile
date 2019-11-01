FROM node:13-alpine

# Install system packages
RUN npm install express --no-save

COPY server.js .
COPY my.pac .

EXPOSE 10000

CMD node server.js

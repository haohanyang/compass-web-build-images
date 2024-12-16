FROM node:22

# Install dependencies
RUN apt-get update
RUN apt-get install -y xvfb libnss3 libdbus-1-dev libatk1.0-0 libatk-bridge2.0-0 libcups2-dev libgtk-3-dev libgbm1 libasound2-dev

RUN mkdir -p /home/node/compass
COPY compass/configs /home/node/compass/configs
COPY compass/packages /home/node/compass/packages
COPY compass/scripts /home/node/compass/scripts
COPY compass/package.json /home/node/compass
COPY compass/package-lock.json /home/node/compass
COPY compass/.npmrc /home/node/compass
COPY compass/lerna.json /home/node/compass

RUN chown -R node:node /home/node/compass

WORKDIR /home/node/compass
RUN PUPPETEER_SKIP_DOWNLOAD=1 npm install

RUN chown root:root /home/node/compass/node_modules/electron/dist/chrome-sandbox && chmod 4755 /home/node/compass/node_modules/electron/dist/chrome-sandbox

EXPOSE 7777
EXPOSE 1337

USER node

ENV OPEN_BROWSER=false
ENV NODE_ENV=production

CMD ["npm", "run", "start-web"]
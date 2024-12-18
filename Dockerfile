FROM node:22 AS build

RUN mkdir -p /home/node/compass

COPY compass/configs /home/node/compass/configs
COPY compass/packages /home/node/compass/packages
COPY compass/scripts /home/node/compass/scripts
COPY compass/package.json /home/node/compass
COPY compass/package-lock.json /home/node/compass
COPY compass/.npmrc /home/node/compass
COPY compass/lerna.json /home/node/compass

WORKDIR /home/node/compass

ENV PUPPETEER_SKIP_DOWNLOAD=1

RUN npm ci

RUN npm run bootstrap

RUN npm run compile-sandbox --workspace=@mongodb-js/compass-web

RUN npm run bundle-sandbox-server --workspace=@mongodb-js/compass-web

FROM node:22

# RUN chown root:root /home/node/compass/node_modules/electron/dist/chrome-sandbox && chmod 4755 /home/node/compass/node_modules/electron/dist/chrome-sandbox

RUN mkdir -p /home/node/compass-web

COPY package.json /home/node/compass-web
COPY package-lock.json /home/node/compass-web
COPY --from=build /home/node/compass/packages/compass-web/dist /home/node/compass-web/dist

RUN chown -R node:node /home/node/compass-web

WORKDIR /home/node/compass-web

RUN npm ci

USER node

ENV OPEN_BROWSER=false
ENV NODE_ENV=production

EXPOSE 8080

CMD ["npm", "run", "start"]
FROM node:22.14.0-alpine3.21@sha256:9bef0ef1e268f60627da9ba7d7605e8831d5b56ad07487d24d1aa386336d1944 AS base
LABEL org.opencontainers.image.source https://github.com/runhub-dev/demo-app
RUN apk add --no-cache tini=0.19.0-r3
USER 1000:1000
WORKDIR /home/node/app
COPY package.json package-lock.json .

FROM base AS build
RUN npm install-clean
COPY . .
RUN npm run build

FROM base
RUN npm install-clean --omit=dev
COPY --from=build /home/node/app/build .
ENTRYPOINT ["tini", "--", "node", "index.js"]

FROM node:18-alpine

ENV npm_config_loglevel=silent

WORKDIR /lint
COPY package.json package-lock.json .remarkrc.yaml ./

RUN apk add --no-cache \
  git~=2.36.2 ;\
  npm install ;\
  npm link remark-cli ;\
  rm -rf ~/.npm

USER node
WORKDIR /lint/input
RUN git config --global --add safe.directory /lint/input
ENTRYPOINT ["/usr/local/bin/remark"]

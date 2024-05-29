# FROM node:19-alpine3.15 as dev
# WORKDIR /app
# COPY package.json ./
# RUN yarn install --network-timeout 100000
# CMD [ "yarn","start:dev" ]
 
 
# FROM node:19-alpine3.15 as dev-deps
# WORKDIR /app
# COPY package.json package.json
# RUN yarn install --frozen-lockfile --network-timeout 100000
 
 
# FROM node:19-alpine3.15 as builder
# WORKDIR /app
# COPY --from=dev-deps /app/node_modules ./node_modules
# COPY . .
# # RUN yarn test
# COPY yarn.lock ./
# RUN yarn build
 
# FROM node:19-alpine3.15 as prod-deps
# WORKDIR /app
# COPY package.json package.json
# RUN yarn install --prod --frozen-lockfile --network-timeout 100000
 
 
# FROM node:19-alpine3.15 as prod
# EXPOSE 3000
# WORKDIR /app
# ENV APP_VERSION=${APP_VERSION}
# COPY --from=prod-deps /app/node_modules ./node_modules
# COPY --from=builder /app/dist ./dist
 
# CMD [ "node","dist/main.js"]

# Etapa de desarrollo
FROM node:18.13.0-alpine as dev
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --network-timeout 100000
CMD [ "yarn", "start:dev" ]

# Etapa de dependencias de desarrollo
FROM node:18.13.0-alpine as dev-deps
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --network-timeout 100000

# Etapa de construcción
FROM node:18.13.0-alpine as builder
WORKDIR /app
COPY --from=dev-deps /app/node_modules ./node_modules
COPY . .
# RUN yarn test
RUN yarn build

# Etapa de dependencias de producción
FROM node:18.13.0-alpine as prod-deps
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --prod --frozen-lockfile --network-timeout 100000

# Etapa final de producción
FROM node:18.13.0-alpine as prod
EXPOSE 3000
WORKDIR /app
ENV APP_VERSION=${APP_VERSION}
COPY --from=prod-deps /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

CMD [ "node", "dist/main.js" ]

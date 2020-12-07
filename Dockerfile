FROM node:12-alpine AS build
WORKDIR /build
# Copy less likely to change package.* files first...
COPY package.* .
# ...and installing modules
RUN npm i
# Copy the rest. more likely to change files aftewards...
COPY . . 
# ...and build the app
RUN npm run build

# Using multistage build to fetch only necessary
# artifacts from the previous layer
FROM node:12-alpine AS output
COPY --from=build /build/package.* .
# Setting NODE_ENV=production makes  'npm i'
# install only production deps by default
ENV NODE_ENV "production"
RUN npm i
COPY --from=build /build/dist /dist

EXPOSE 4000:4000

ENTRYPOINT ["node", "dist/main"]



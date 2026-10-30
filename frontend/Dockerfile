FROM node:24-alpine
WORKDIR /app
COPY /apps/admin/package*.json .
RUN npm install
COPY /apps/admin/ .
EXPOSE 3001
CMD [ "pnpm", "run", "start" ]
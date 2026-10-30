FROM node:24-alpine
WORKDIR /app
COPY /apps/admin/package*.json .
RUN pnpm install
COPY /apps/admin/ .
EXPOSE 3001
CMD [ "pnpm", "run", "start" ]
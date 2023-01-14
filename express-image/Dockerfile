FROM node:18

LABEL authors="Kylian Manzini, Ylli Fazlija"

EXPOSE 3000

RUN apt-get update && apt-get clean

COPY src /opt/app

CMD ["node", "/opt/app/index.js"]
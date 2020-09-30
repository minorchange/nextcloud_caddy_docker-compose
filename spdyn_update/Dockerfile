FROM alpine
RUN apk add --no-cache --upgrade bash curl
COPY spdyn_update.sh /spdyn_update.sh
RUN chmod +x /spdyn_update.sh
CMD /bin/bash /spdyn_update.sh

FROM redis:7-alpine

COPY redis.conf .

ENTRYPOINT ["redis-server", "./redis.conf"]

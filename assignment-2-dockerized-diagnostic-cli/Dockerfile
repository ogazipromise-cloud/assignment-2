FROM alpine:3.22

RUN apk add --no-cache \
    bash \
    iputils \ 
    iproute2 \ 
    procps 

WORKDIR /app

COPY app/ /app/

RUN chmod +x /app/diagnostic.sh /app/health-check.sh

ENTRYPOINT ["/app/diagnostic.sh"]

CMD ["help"]

FROM scratch
WORKDIR /app
ADD main /app/
ENTRYPOINT ["./main"]
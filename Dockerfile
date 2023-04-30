################ Build & Dev ################
# Build stage will be used:
# - for building the application for production
# - as target for development (see devspace.yaml)
FROM golang:1.20.2-alpine3.17 as builder
# Create project directory (workdir)
WORKDIR /app
# copy source code files to WORKDIR
COPY . .
# Build application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o main .
# Container start command for development
# Allows DevSpace to restart the dev container
# It is also possible to override this in devspace.yaml via images.*.cmd
CMD ["go", "run", "main.go"]
################ Production ################
FROM golang:1.20.2-alpine3.17
RUN go version
COPY --from=builder /app/main /
HEALTHCHECK --interval=30s --timeout=3s CMD curl -f http://localhost:8080/hello || exit 1
# Application port (optional)
EXPOSE 8080
LABEL org.opencontainers.image.description='sample-go-app description goes here'
# Container start command for production
CMD ["/main"]
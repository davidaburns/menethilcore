FROM golang:1.24.4-alpine AS builder

RUN apk add --no-cache git ca-certificates tzdata
RUN adduser -D -g '' appuser

WORKDIR /build

COPY go.mod go.sum ./

RUN go mod download
RUN go mod verify

COPY . .

ARG BUILD_NAME=unknown
ARG BUILD_VERSION=0.0.1
ARG BUILD_NUMBER=0
ARG BUILD_TYPE=dev
ARG BUILD_COMMIT=unknown
ARG BUILD_IMPORT=unknown

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags="-w -s -X ${BUILD_IMPORT}/build.name=${BUILD_NAME} -X ${BUILD_IMPORT}/build.version=${BUILD_VERSION} -X ${BUILD_IMPORT}/build.buildNumber=${BUILD_NUMBER} -X ${BUILD_IMPORT}/build.buildCommit=${BUILD_COMMIT}" \
    -a -installsuffix cgo \
    -o app ./cmd/osmom

FROM scratch

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /build/app /app

USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD ["/app", "health"]

ENTRYPOINT ["/app"]

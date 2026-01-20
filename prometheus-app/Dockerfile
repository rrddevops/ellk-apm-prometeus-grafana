FROM golang:1.16 as builder
WORKDIR /go/src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /go/bin/app main.go

FROM alpine:3.16
RUN apk add --no-cache ca-certificates
COPY --from=builder /go/bin/app /usr/local/bin/app
EXPOSE 8181
CMD ["/usr/local/bin/app"]
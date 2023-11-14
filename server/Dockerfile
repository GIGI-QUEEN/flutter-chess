FROM golang:1.19.1-buster AS builder

WORKDIR /server
COPY go.mod .
COPY go.sum .
RUN go mod download
COPY . .
RUN go build -o /server/main .


FROM ubuntu:20.04

WORKDIR /server
COPY --from=builder /server/main .
CMD ["/server/main"]

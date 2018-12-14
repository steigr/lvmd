FROM golang:latest AS builder
RUN  git clone https://github.com/deeGraYve/credstore /go/src/github.com/google/credstore
RUN  apt-get update
RUN  apt-get install -y protobuf-compiler
RUN  go get github.com/golang/protobuf/protoc-gen-go
RUN  git clone https://github.com/grpc-ecosystem/grpc-gateway /go/src/github.com/grpc-ecosystem/grpc-gateway
WORKDIR /go/src/github.com/google/lvmd
COPY proto proto
COPY Makefile Makefile
RUN make grpc
COPY parser parser
COPY commands commands
COPY server server
COPY main.go main.go
RUN CGO_ENABLED=0 go get github.com/google/lvmd

FROM debian:stretch-slim AS lvmd

RUN  apt-get update \
 &&  apt-get install -y lvm2 \
 &&  rm -rf /var/cache/apt/lists

COPY --from=builder /go/bin/lvmd /bin/lvmd
ENTRYPOINT ["lvmd"]

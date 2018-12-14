FROM golang:latest AS builder
RUN git clone https://github.com/deeGraYve/credstore /go/src/github.com/google/credstore
RUN  apt-get update
RUN  apt-get install -y protobuf-compiler
RUN  go get -v -u github.com/golang/protobuf/protoc-gen-go
WORKDIR /go/src/github.com/google/lvmd
COPY . .
RUN make grpc
RUN CGO_ENABLED=0 go get -v github.com/google/lvmd

FROM debian:stretch-slim AS lvmd
RUN  apt-get update && apt-get install -y lvm2
COPY --from=builder /go/bin/lvmd /bin/lvmd
ENTRYPOINT ["lvmd"]

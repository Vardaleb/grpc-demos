#!/bin/bash
CLIENT_DIR=client/dart-grpc/lib/gen

mkdir -p $CLIENT_DIR

protoc \
    --dart_out=grpc:$CLIENT_DIR \
    -Iproto \
    proto/v1/hello.proto 

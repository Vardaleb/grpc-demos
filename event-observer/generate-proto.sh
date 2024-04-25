#!/bin/bash
CLIENT_DIR=client/lib/generated
SERVER_DIR=server/dart/lib/generated

mkdir -p $CLIENT_DIR
mkdir -p $SERVER_DIR

protoc \
    --dart_out=grpc:$CLIENT_DIR \
    --dart_out=grpc:$SERVER_DIR \
    -Iproto \
    proto/event.proto \
    google/protobuf/timestamp.proto \
    google/protobuf/empty.proto

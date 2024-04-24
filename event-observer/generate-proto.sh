#!/bin/bash

protoc \
    --dart_out=grpc:client/lib/generated \
    --dart_out=grpc:server/dart/lib/generated \
    -Iproto \
    proto/event.proto \
    google/protobuf/timestamp.proto \
    google/protobuf/empty.proto

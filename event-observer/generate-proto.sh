#!/bin/bash
LIBRARY_DIR=event_library/lib/src

mkdir -p $LIBRARY_DIR

protoc \
    --dart_out=grpc:$LIBRARY_DIR \
    -Iproto \
    proto/event.proto \
    google/protobuf/timestamp.proto \
    google/protobuf/empty.proto

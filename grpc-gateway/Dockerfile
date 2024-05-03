# Builder
FROM rust:latest AS builder

RUN rustup target add x86_64-unknown-linux-musl
RUN apt update && apt install -y musl-tools musl-dev protobuf-compiler
RUN update-ca-certificates

# Create app user
ENV USER=mainuser
ENV UID=1000

RUN adduser \
    --disabled-password \
    --gecos "" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    "${USER}"

COPY proto /work/proto
COPY server /work/server 
WORKDIR /work/server

RUN cargo build --target x86_64-unknown-linux-musl --release

# Image
FROM alpine

RUN apk update \
    && apk add bash

# Import from builder
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
WORKDIR /work
RUN chown -R mainuser:mainuser /work
RUN chmod 755 /work

# Copy the built binary
COPY --from=builder /work/server/target/x86_64-unknown-linux-musl/release/server ./

USER mainuser:mainuser

EXPOSE 50051
CMD ["./server"]

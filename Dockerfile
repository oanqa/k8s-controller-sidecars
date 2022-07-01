# syntax=docker/dockerfile:1.4
FROM golang:1.18-alpine AS build

ARG SOURCE_REPOSITORY=https://github.com/Riskified/k8s-controller-sidecars

RUN <<EOF
  set -eux
  apk add --no-cache \
		git \
    upx
EOF

WORKDIR /go/src/k8s-controller-sidecars

RUN <<EOF
  set -eux
  git clone --single-branch -b main ${SOURCE_REPOSITORY} /go/src/k8s-controller-sidecars
  go mod download -x

  CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -a -installsuffix cgo -o sidecars-controller .
  upx sidecars-controller
EOF

FROM alpine:3.16 AS app
COPY --from=build /go/src/k8s-controller-sidecars/sidecars-controller /
CMD ["/sidecars-controller"]

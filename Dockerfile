FROM ghcr.io/kyverno/kyverno-cli:1.8-dev-latest@sha256:496d1a3cd4f29843ae0c7fcbf1f43dce4f3c1d8f76626fd9a40037d1870d1bfa as kyverno-cli

FROM alpine/k8s:1.31.1@sha256:dfe8c7a06c41d0b6e8757da99531f8f302e9a2687fa0155af4c4087df585c9c8

RUN apk add --no-cache\ 
  yq \
  python3 \
  python3-dev \
  alpine-sdk \
  libffi-dev \
  py3-wheel \
  go

RUN GO11MODULE=on go get github.com/tmccombs/hcl2json

COPY requirements.txt ./
RUN pip install -r requirements.txt

COPY --from=kyverno-cli /kyverno /usr/local/bin/kyverno

COPY run.sh /usr/local/bin/run.sh

ENV POLICY_VERSION=0.0.0

CMD run.sh
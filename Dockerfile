FROM ghcr.io/kyverno/kyverno-cli:1.8-dev-latest@sha256:07f6a35c1bced67394ba636ade9ea9d5c6c57adb1ac98af2b05ce4a4971cb105 as kyverno-cli

FROM alpine/k8s:1.22.6@sha256:00ac10bcb759102470101b0805b1609c0d1143241e4c4f8a1d3fcbbb91f3e86d

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
FROM ghcr.io/kyverno/kyverno-cli:1.8-dev-latest@sha256:800564d2535955a38c25c928e625ea95114633f9c100fe9ee60c3630d0427b4c as kyverno-cli

FROM alpine/k8s:1.22.10@sha256:5c4d95153faec0df0cf732615894b5a90ef6ca752556800ec0017a880b6155a2

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
FROM elixir:1.13-alpine AS builder

ENV MIX_ENV=prod

RUN apk update && apk upgrade --no-cache
RUN apk add --no-cache build-base git make sassc
RUN mix local.hex --force && mix local.rebar --force

WORKDIR /app

COPY . .

RUN rm -rf _build/* 

RUN mix compile

RUN mix release

FROM elixir:1.13-alpine

ENV REPLACE_OS_VARS=true

RUN apk add --update bash openssl-dev
WORKDIR /app

COPY --from=builder --chown=nobody:nobody /_build/prod/rel/checkout .

CMD bin/checkout start;

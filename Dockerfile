FROM bitwalker/alpine-elixir:1.11.4 as release

WORKDIR /app

RUN apk update && apk add bash

# Install Hex + Rebar
RUN mix do local.hex --force, local.rebar --force

COPY config/ /app/config/
COPY mix.exs /app/
COPY mix.* /app/

ENV AMQP_HOST "$AMQP_HOST"
ENV AMQP_URL "$AMQP_URL"
ENV AMQP_USER "$AMQP_USER"
ENV AMQP_PASS "$AMQP_PASS"
ENV DATABASE_URL "$DATABASE_URL"


COPY apps/hvac_database/mix.exs /app/apps/hvac_database/
COPY apps/hvac_client/mix.exs /app/apps/hvac_client/
COPY apps/hvac_server/mix.exs /app/apps/hvac_server/

COPY . /app/

ENV MIX_ENV=prod
RUN mix do deps.get --only $MIX_ENV, deps.compile

WORKDIR /app
RUN MIX_ENV=prod mix release

########################################################################

FROM bitwalker/alpine-elixir:1.11.4

RUN apk update && apk add bash

ENV MIX_ENV=prod \
    SHELL=/bin/bash

RUN apk add --update openssl ncurses-libs postgresql-client && \
    rm -rf /var/cache/apk/*

WORKDIR /app
COPY --from=release /app/_build/prod/rel/hvac_umbrella .
COPY --from=release /app/bin ./bin

CMD ["./bin/start.sh"]

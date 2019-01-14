FROM elixir as build
COPY . .

RUN mix local.hex --force && mix local.rebar --force

RUN export MIX_ENV=prod && \
    rm -Rf _build && \
    mix deps.get && \
    mix release

CMD ["_build/prod/rel/otaku/bin/otaku", "foreground"]

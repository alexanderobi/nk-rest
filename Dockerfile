FROM haskell:8.0.2

WORKDIR /opt/server

COPY . /opt/server

RUN apt-get update && \
    apt-get install wget ca-certificates -y && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update && \
    apt-get install libpq-dev -y

RUN stack install --system-ghc --only-configure --no-terminal

RUN stack build

ENTRYPOINT ["stack", "exec", "nk-rest-exe"]

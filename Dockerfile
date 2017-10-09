FROM haskell:8

WORKDIR /opt/server

COPY ./nk-rest.cabal /opt/server/nk-rest.cabal

RUN stack install --only-dependencies

COPY . /opt/server

RUN stack install

CMD ["stack build", "--exec", "nk-rest-exe"]

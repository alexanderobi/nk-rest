FROM fpco/stack-build

WORKDIR /opt/server

COPY . /opt/server

RUN stack setup --no-terminal

RUN stack install --only-dependencies

RUN stack build

ENTRYPOINT ["stack", "exec", "nk-rest-exe"]

# NK-Rest

[![CircleCI](https://circleci.com/gh/alexanderobi/nk-rest.svg?style=svg)](https://circleci.com/gh/alexanderobi/nk-rest)

NK Rest is a rest api endpoint in Haskell with Postgres database.

## Prerequisite
```bash
GHC
Stack
Postgres
```

## Installation
Install stack and Postgres
```bash
$ curl -sSL https://get.haskellstack.org/ | sh
```

## Configurations
Set the following env variables
```bash
$ export nk_host={Database host}
$ export nk_user={Database user}
$ export nk_password={Database password}
$ export nk_dbname={Database schema}

```
## Test
```bash
$ stack test
```

## Build
```bash
$ stack build --exec nk-rest-exe
```
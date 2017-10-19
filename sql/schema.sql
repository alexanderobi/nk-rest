CREATE EXTENSION IF NOT EXISTS "uuid-ossp"
;

DROP TABLE IF EXISTS Users
;

CREATE TABLE Users (
  Id         UUID PRIMARY KEY NOT NULL UNIQUE DEFAULT uuid_generate_v1(),
  Name       VARCHAR(255)     NOT NULL,
  Slug       VARCHAR(255),
  Email      VARCHAR(255)     NOT NULL,
  Phone      VARCHAR(255),
  image_url  VARCHAR(255),
  Language   VARCHAR(255),
  Last_login TIMESTAMP        NULL,
  location   VARCHAR(255),
  Created_at TIMESTAMP        NOT NULL        DEFAULT CURRENT_TIMESTAMP,
  Updated_at TIMESTAMP        NOT NULL        DEFAULT CURRENT_TIMESTAMP,
  published  BOOLEAN          NOT NULL        DEFAULT TRUE
)
;

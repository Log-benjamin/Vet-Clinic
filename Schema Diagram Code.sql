CREATE TABLE "animals" (
  "id" int PRIMARY KEY,
  "name" varchar(50),
  "date_of_birth" date,
  "escape_attempts" int,
  "neutered" boolean,
  "weight_kg" decimal,
  "species_id" integer,
  "owner_id" integer
);

CREATE TABLE "owners" (
  "id" INT PRIMARY KEY,
  "full_name" VARCHAR(50),
  "age" int,
  "email" VARCHAR
);

CREATE TABLE "species" (
  "id" INT PRIMARY KEY,
  "name" VARCHAR(50)
);

ALTER TABLE "animals" ADD FOREIGN KEY ("species_id") REFERENCES "species" ("id");

ALTER TABLE "animals" ADD FOREIGN KEY ("owner_id") REFERENCES "owners" ("id");

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

CREATE TABLE "vets" (
  "id" integer PRIMARY KEY,
  "name" VARCHAR(50),
  "age" integer,
  "date_of_graduation" date
);

CREATE TABLE "specializations" (
  "species_id" integer,
  "vet_id" integer
);

CREATE TABLE "visits" (
  "vet_id" integer,
  "animal_id" integer,
  "visit_date" date
);

ALTER TABLE "animals" ADD FOREIGN KEY ("species_id") REFERENCES "species" ("id");

ALTER TABLE "animals" ADD FOREIGN KEY ("owner_id") REFERENCES "owners" ("id");

ALTER TABLE "specializations" ADD FOREIGN KEY ("species_id") REFERENCES "species" ("id");

ALTER TABLE "specializations" ADD FOREIGN KEY ("vet_id") REFERENCES "vets" ("id");

ALTER TABLE "visits" ADD FOREIGN KEY ("vet_id") REFERENCES "vets" ("id");

ALTER TABLE "visits" ADD FOREIGN KEY ("animal_id") REFERENCES "animals" ("id");

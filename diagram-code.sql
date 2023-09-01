CREATE TABLE "animals" (
  "id" int PRIMARY KEY,
  "name" VARCHAR(50),
  "date_of_birth" date,
  "escape_attempts" int,
  "neutered" boolean,
  "weight_kg" decimal,
  "species_id" int,
  "owner_id" int
);

CREATE TABLE "owners" (
  "id" int PRIMARY KEY,
  "full_name" VARCHAR(50),
  "age" int,
  "email" VARCHAR(120)
);

CREATE TABLE "species" (
  "id" int PRIMARY KEY,
  "name" VARCHAR(50)
);

CREATE TABLE "vets" (
  "id" int PRIMARY KEY,
  "name" VARCHAR(50),
  "age" int,
  "date_of_graduation" date
);

CREATE TABLE "specializations" (
  "species_id" int,
  "vet_id" int
);

CREATE TABLE "visits" (
  "vet_id" int,
  "animal_id" int,
  "visit_date" date
);

ALTER TABLE "animals" ADD FOREIGN KEY ("species_id") REFERENCES "species" ("id");

ALTER TABLE "animals" ADD FOREIGN KEY ("owner_id") REFERENCES "owners" ("id");

ALTER TABLE "specializations" ADD FOREIGN KEY ("species_id") REFERENCES "species" ("id");

ALTER TABLE "specializations" ADD FOREIGN KEY ("vet_id") REFERENCES "vets" ("id");

ALTER TABLE "visits" ADD FOREIGN KEY ("vet_id") REFERENCES "vets" ("id");

ALTER TABLE "visits" ADD FOREIGN KEY ("animal_id") REFERENCES "animals" ("id");

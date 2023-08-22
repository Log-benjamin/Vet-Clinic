CREATE DATABASE vet_clinic

CREATE TABLE animals (
	id int,
	name varchar(50),
	date_of_birth date,
	escape_attempts int,
	neutered boolean,
	weight_kg decimal
);

ALTER TABLE animals
ADD species varchar(50);
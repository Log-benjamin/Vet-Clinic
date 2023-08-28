SELECT * FROM animals WHERE name like '%mon';
SELECT * FROM animals WHERE EXTRACT(YEAR FROM date_of_birth) BETWEEN 2016 AND 2019;
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name NOT IN ('Gabumon');
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

-- Inside a transaction update the animals table by setting the species column to unspecified. Verify that change was made. Then roll back the change and verify that the species columns went back to the state before the transaction.
BEGIN;
	UPDATE animals
	SET species = 'unspecified';
    SELECT * FROM animals;

    ROLLBACK;
SELECT * FROM animals;


-- Inside a transaction: Update the animals table by setting the species column to digimon for all animals that have a name ending in mon. -- Update the animals table by setting the species column to pokemon for all animals that don't have species already set. -- Verify that changes were made. -- Commit the transaction. -- Verify that changes persist after commit.
BEGIN;
    UPDATE animals
    SET species = 'digimon'
    WHERE name LIKE '%mon';

	UPDATE animals
	SET species = 'pokemon'
	WHERE species IS NULL;

    COMMIT;
SELECT * FROM animals;

-- Now, take a deep breath and... Inside a transaction delete all records in the animals table, then roll back the transaction. -- After the rollback verify if all records in the animals table still exists. After that, you can start breathing as usual ;)
BEGIN;
	DELETE FROM animals;
    ROLLBACK;
SELECT * FROM animals;

-- Inside a transaction: -- Delete all animals born after Jan 1st, 2022. -- Create a savepoint for the transaction. -- Update all animals' weight to be their weight multiplied by -1. -- Rollback to the savepoint. -- Update all animals' weights that are negative to be their weight multiplied by -1. -- Commit transaction
BEGIN;
	DELETE FROM animals
	WHERE date_of_birth > '2022-01-01';
	SAVEPOINT delete_after_2022_01;
	
	UPDATE animals
	SET weight_kg = weight_kg * -1;
	
	ROLLBACK TO delete_after_2022_01;

	UPDATE animals
	SET weight_kg = weight_kg * -1
	WHERE weight_kg < 0;

    COMMIT;
SELECT * FROM animals;


-- How many animals are there?
SELECT COUNT(*) FROM animals;
-- How many animals have never tried to escape?
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
-- What is the average weight of animals?
SELECT AVG(weight_kg) FROM animals;

-- Who escapes the most, neutered or not neutered animals?
SELECT * 
FROM animals
WHERE escape_attempts = 
    ( SELECT MAX( escape_attempts) 
      FROM animals
      WHERE (neutered = true OR neutered = false));

-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg), MAX(weight_kg)
FROM animals
GROUP BY species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts)
FROM animals
WHERE EXTRACT(YEAR FROM date_of_birth) BETWEEN 1990 AND 2000
GROUP BY species;

-- What animals belong to Melody Pond?
SELECT animals.name, owners.full_name
FROM animals
INNER JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).
SELECT animals.name, species.name
FROM animals
INNER JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal.
SELECT *
FROM owners
LEFT JOIN animals
ON owners.id = animals.owner_id;

-- How many animals are there per species?
SELECT species.name, COUNT(*)
FROM animals
INNER JOIN species
ON animals.species_id = species.id
GROUP BY species.name;

-- List all Digimon owned by Jennifer Orwell.
SELECT animals.name, species.name, owners.full_name
FROM animals
INNER JOIN owners
ON animals.owner_id = owners.id 
INNER JOIN species ON species.id = animals.species_id
WHERE owners.full_name = 'Jennifer Orwell' 
AND species.name = 'Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT animals.name, owners.full_name, animals.escape_attempts 
FROM animals
INNER JOIN owners ON owners.id = animals.owner_id
WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;

-- Who owns the most animals?
SELECT owners.full_name, COUNT(animals.id) AS Number_of_Animals
FROM owners
JOIN animals ON owners.id = animals.owner_id
GROUP BY owners.id
ORDER BY Number_of_Animals DESC
LIMIT 1;

-- Who was the last animal seen by William Tatcher?
SELECT animals.name
FROM visits
INNER JOIN animals ON animals.id = visits.animal_id
INNER JOIN vets ON vets.id = visits.vet_id
WHERE vet_id = 1
AND visit_date = 
(SELECT MAX(visit_date)
 FROM visits
 WHERE vet_id = 1);

-- How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT animal_id)
FROM visits 
INNER JOIN vets ON vets.id = visits.vet_id
INNER JOIN animals ON animals.id = visits.animal_id
WHERE vets.name = 'Stephanie Mendez';

-- List all vets and their specialties, including vets with no specialties.
SELECT vets.id, vets.name AS vet_name, species.name AS specialties
FROM vets 
LEFT JOIN specializations ON vets.id = specializations.vet_id
LEFT JOIN species ON specializations.species_id = species.id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.name AS animal_name
FROM animals
INNER JOIN visits ON animals.id = visits.animal_id
INNER JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez'
AND visits.visit_date BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?
SELECT animals.name AS animal_name, COUNT(visits.animal_id) AS visit_count
FROM animals
LEFT JOIN visits ON animals.id = visits.animal_id
GROUP BY animals.id, animals.name
ORDER BY visit_count DESC
LIMIT 1;

-- Who was Maisy Smith's first visit?
SELECT animals.name
FROM vets
INNER JOIN visits ON vets.id = visits.vet_id
INNER JOIN animals ON visits.animal_id = animals.id
WHERE vets.name = 'Maisy Smith'
ORDER BY visits.visit_date ASC
LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT animals.name AS animal_name, vets.name AS vet_name, visits.visit_date
FROM visits
INNER JOIN animals ON visits.animal_id = animals.id
INNER JOIN vets ON visits.vet_id = vets.id
ORDER BY visits.visit_date DESC
LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*)
FROM visits
INNER JOIN animals ON visits.animal_id = animals.id
INNER JOIN vets ON visits.vet_id = vets.id
LEFT JOIN specializations ON (vets.id = specializations.vet_id AND animals.species_id = specializations.species_id)
WHERE specializations.species_id IS NULL;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT species.name AS suggested_specialty, COUNT(*) AS num_visits
FROM visits
INNER JOIN animals ON visits.animal_id = animals.id
INNER JOIN species ON animals.species_id = species.id
INNER JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Maisy Smith'
GROUP BY species.name
ORDER BY num_visits DESC
LIMIT 1;


EXPLAIN ANALYZE SELECT COUNT(*) FROM visits where animal_id = 4;
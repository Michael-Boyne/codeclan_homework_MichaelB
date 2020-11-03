--- “Get a list of all the animals that have diet plans together with the diet plans that they are on.” ---

SELECT 
	animals.*
	diets.*
FROM animals INNER JOIN diets 
ON animals.diet_id = diets.id 


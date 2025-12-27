SELECT DISTINCT p.name
FROM people AS p
JOIN directors AS d ON p.id = d.person_id
JOIN ratings   AS r ON d.movie_id = r.movie_id
WHERE r.rating >= 9.0;

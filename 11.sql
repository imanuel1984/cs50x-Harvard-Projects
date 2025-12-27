SELECT m.title
FROM movies AS m
JOIN ratings AS r ON m.id = r.movie_id
JOIN stars   AS s ON m.id = s.movie_id
JOIN people  AS p ON s.person_id = p.id
WHERE p.name = 'Chadwick Boseman'
ORDER BY r.rating DESC
LIMIT 5;

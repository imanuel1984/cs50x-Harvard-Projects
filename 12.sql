SELECT m.title
FROM movies AS m
WHERE m.id IN (
    SELECT s.movie_id
    FROM stars AS s
    JOIN people AS p ON s.person_id = p.id
    WHERE p.name = 'Bradley Cooper'
)
AND m.id IN (
    SELECT s.movie_id
    FROM stars AS s
    JOIN people AS p ON s.person_id = p.id
    WHERE p.name = 'Jennifer Lawrence'
);

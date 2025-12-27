SELECT DISTINCT p2.name
FROM people AS kb
JOIN stars  AS s1 ON kb.id = s1.person_id
JOIN stars  AS s2 ON s1.movie_id = s2.movie_id
JOIN people AS p2 ON s2.person_id = p2.id
WHERE kb.name = 'Kevin Bacon'
  AND kb.birth = 1958
  AND p2.id <> kb.id;

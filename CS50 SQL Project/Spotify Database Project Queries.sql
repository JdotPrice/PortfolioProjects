-- Find all songs by the artist Mac Miller
-- Songs with Mac Miller, but with other featured artists, won't be included.
SELECT *
FROM "songs"
WHERE "artist_id" = (
    SELECT "id"
    FROM "artists"
    WHERE "name" = 'Mac Miller'
);

-- Find top 100 artists, ordered by the most monthly_listens to fewest.
SELECT *
FROM "artists"
ORDER BY monthly_listens DESC
LIMIT 100;

-- Find top 100 albums, ordered by the highest rating to lowest and rounded to two decimal points.
SELECT *
FROM "albums"
ORDER BY ROUND(rating, 2) DESC
LIMIT 100;

-- Find all liked songs
SELECT *
FROM "liked_songs";

-- Find all playlists created by Taylor Swift
SELECT *
FROM "playlists"
WHERE "created_by_user_id" = (
    SELECT 'id'
    FROM 'artists'
    WHERE 'name' = 'Taylor Swift'
);

-- Add a new album
INSERT INTO "albums" ("artist_id", "album_name", "genre", "release_date", "rating")
VALUES (
    (SELECT 'id' FROM 'artists' WHERE 'name' = 'Mac Miller'),
    'Swimming',
    'HipHop',
    '08-03-2013',
    '4.9');

-- Update The Real Slim Shady
UPDATE "artists"
SET "name" = "The Real Slim Shady",
WHERE "name" = "Eminem";

-- Represent user information
CREATE TABLE "user" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "username" TEXT NOT NULL UNIQUE,
    "password" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    PRIMARY KEY("id"),
);

-- Represent songs 'liked' by the user
CREATE TABLE "likes" (
    "id" INTEGER,
    "user_id" INTEGER,
    "song_id" INTEGER,
    "playlist_id" INTEGER,
    "podcast_id" INTEGER,
    "artist_id" INTEGER,
    "album_id" INTEGER,
    PRIMARY KEY("id"),
    FOREIGN KEY("user_id") REFERENCES "users"("id"),
    FOREIGN KEY("song_id") REFERENCES "songs"("id")
    FOREIGN KEY("playlist_id") REFERENCES "playlists"("id")
    FOREIGN KEY("podcast_id") REFERENCES "podcasts"("id")
    FOREIGN KEY("artist_id") REFERENCES "artists"("id")
    FOREIGN KEY("album_id") REFERENCES "albums"("id")

);

-- Represent artists and the amount of listens they receive per month (also includes Podcast hosts)
CREATE TABLE "artists" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "monthly_listens" INTEGER,
    PRIMARY KEY("id")
);

-- Represent albums and their artist affilitations, as well as the release date of the album and the rating out of 5
CREATE TABLE "albums" (
    "id" INTEGER,
    "artist_id" INTEGER,
    "album_name" TEXT NOT NULL,
    "genre" TEXT NOT NULL,
    "release_date" DATE NOT NULL,
    "rating" REAL NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("artist_id") REFERENCES "artists"("id")
);

-- Represent individual songs, their artist & album affiliations, and the song's length in time
CREATE TABLE "songs" (
    "id" INTEGER,
    "artist_id" INTEGER,
    "album_id" INTEGER,
    "song_name" TEXT NOT NULL,
    "genre" TEXT NOT NULL,
    "song_length" NUMERIC NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("artist_id") REFERENCES "artists"("id"),
    FOREIGN KEY("album_id") REFERENCES "albums"("id")
);

-- Represent playlists created by users and how many songs are in the playlist
CREATE TABLE "playlists" (
    "id" INTEGER,
    "playlist_name" TEXT NOT NULL,
    "created_by_user_id" INTEGER NOT NULL,
    "created_on" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "total_songs" INTEGER NOT NULL, --This is the amount of songs, not a list
    PRIMARY KEY("id"),
    FOREIGN KEY("created_by_user_id") REFERENCES "users"("id")
);

-- Represent podcasts created by users and their genre
CREATE TABLE "podcasts" (
    "id" INTEGER,
    "podcast_name" TEXT NOT NULL,
    "host" TEXT NOT NULL, --The 'artist' of podcasts
    "artist_id" INTEGER, --Will be represented under artists table
    "created_on" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "genre" TEXT,
    PRIMARY KEY("id"),
    FOREIGN KEY("artist_id") REFERENCES "artists"("id")
);

-- Create indexes to speed common searches
CREATE INDEX "artist_name_search" ON "artists" ("name");
CREATE INDEX "album_name_search" ON "albums" ("album_name");
CREATE INDEX "song_name_search" ON "songs" ("song_name");
CREATE INDEX "album_genre_search" ON "albums" ("genre");
CREATE INDEX "podcast_genre_search" ON "podcasts" ("genre");
CREATE INDEX "user_likes" ON "likes" ("song_id");

--Create view for all liked songs
CREATE VIEW "liked_songs" AS
    SELECT *
    FROM 'songs'
    WHERE 'id' IN (
        SELECT 'song_id'
        FROM 'likes'
    );

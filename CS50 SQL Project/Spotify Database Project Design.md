# Design Document

By Jared Price

Video overview: https://youtu.be/fV9rXYbiWHc

## Scope

My database for Spotify includes entities to track information and statistics for users and artists alike.

**The scope includes:**

* User identification and account information
* Artists names and monthly listening statistics
* Albums information, for both organization and classification
* Songs information, for the same reason as albums information
* Playlists creation and statistical information
* Podcasts creation and classification information
* Likes, to identify a user's preferred content

**The scope does not include:**

* Finer statistics, such as time spent listening to an artist
* A users' "followed" artists, podcast hosts, or other users

## Functional Requirements

This Spotify database supports:

* CRUD operations for Spotify users, spanning artists, albums, songs, playlists, and podcasts.
* Tracking live quantifiable information, such as current album ratings or an artist's monthly listens.
* Tracking listening habits based on parameters such as genre or 'likes'

This Spotify database does not support:
* Unstructured or large data sets
* User-User interactions (messages, following)

## Representation

Entities are captured in SQLite tables with the following schema.

### Entities

The database includes the following entities:

#### User

The `User` table includes:

* `id`, which specifies the unique ID assigned to the user as an `INTEGER`. Therefore, this will be the `PRIMARY KEY`.
* `first_name`, which appropriately specifies the user's first name as `TEXT`.
* `last_name`, which appropriately specifies the user's last name as `TEXT`.
* `username`, which appropriately specifies the user's chosen username as `TEXT`. Since each user must have a different username, this field has been constrained to `UNIQUE`.
* `password`, which appropriately specifies the user's password as `TEXT`.
* `email`, which specifies the email with which the user signed up, as `TEXT`.

#### Artists

The `Artists` table includes:

* `id`, which specifies the unique ID assigned to the artist as an `INTEGER`. Therefore, this will be the `PRIMARY KEY`.
* `name`, which appropriately specifies the artist's name (or name of the band) as `TEXT`.
* `monthly_listeners`, which specifies how many times the artists' songs have been listened to per month, represented by an `INTEGER`. A 'listen' in this case is defined by a song that has been played for at least 30 seconds.

#### Albums

The `Albums` table includes:

* `id`, which specifies the unique ID assigned to the album as an `INTEGER`. Therefore, this will be the `PRIMARY KEY`.
* `artist_id`, which represents the unique ID assigned to the artist or artists who created the album as an `INTEGER`. Since this references the `id` column of the `Artists` table, the `FOREIGN KEY` constraint is applied.
* `album_name`, which appropriately specifies the name of the album as `TEXT`.
* `genre`, which classifies the album into a musical genre as `TEXT`.
* `release_date`, which specifies the date on which the album was released, represented as a `DATE` (MM-DD-YYYY).
* `rating`, which specifies how the album was rated out of 5 as `REAL`, since ratings are often represented as decimals.

#### Songs

The `Songs` table includes:

* `id`, which specifies the unique ID assigned to the song as an `INTEGER`. Therefore, this will be the `PRIMARY KEY`.
* `artist_id`, which represents the unique ID assigned to the artist or artists who created the album as an `INTEGER`. Since this references the `id` column of the `Artists` table, the `FOREIGN KEY` constraint is applied.
* `album_id`, which represents the unique ID assigned to the album to which the song belongs as an `INTEGER`. Since this references the `id` column of the `Albums` table, the `FOREIGN KEY` constraint is applied.
* `song_name`, which appropriately specifies the name of the song as `TEXT`.
* `genre`, which classifies the song into a musical genre as `TEXT`.
* `song_length`, which specifies the song's `NUMERIC` length in time.

#### Playlists

The `Playlists` table includes:

* `id`, which specifies the unique ID assigned to the playlist as an `INTEGER`.  Therefore, this will be the `PRIMARY KEY`.
* `playlist_name`, which appropriately specifies the name of the playlist as `TEXT`.
* `created_by_user_id`, which which represents the unique ID assigned to the user who created the playlist as an `INTEGER`. Since this references the `id` column of the `User` table, the `FOREIGN KEY` constraint is applied.
* `created_on`, which specifies the date on which the playlist was created, which will always be the `DEFAULT CURRENT_TIMESTAMP` to capture the exact moment.
* `total_songs`, which specifies the total amount of songs that make up the playlist, appropriately represented as an `INTEGER`.

#### Podcasts

The `Podcasts` table includes:

* `id`, which specifies the unique ID assigned to the podcast as an `INTEGER`. Therefore, this will be the `PRIMARY KEY`.
* `podcast_name`, which appropriately specifies the name of the podcast as `TEXT`.
* `host`, which appropriately specifies the name of the host or hosts of the podcast as `TEXT`.
* `artist_id`, which specifies which host, group, or user created the podcast as an `INTEGER`. Since this references the `id` column of the `Artists` table, the `FOREIGN KEY` constraint is applied.
* `created_on`, which specifies the date on which the podcast was created, which will always be the `DEFAULT CURRENT_TIMESTAMP` to capture the exact moment.
* `genre`, which classifies the podcast into a specific genre as `TEXT`.

#### Likes

The `Likes` table includes:

* `id`, which specifies the unique ID assigned to that particular 'like' as an `INTEGER`. Therefore, this will be the `PRIMARY KEY`.
* `user_id`, which represents the unique ID assigned to the user to which the 'like' belongs as an `INTEGER`. Since this references the `id` column of the `User` table, the `FOREIGN KEY` constraint is applied.
* `song_id`, which represents the unique ID assigned to the 'liked' song as an `INTEGER`. Since this references the `id` column of the `Songs` table, the `FOREIGN KEY` constraint is applied.
* `playlist_id`, which represents the unique ID assigned to the 'liked' playlist as an `INTEGER`. Since this references the `id` column of the `Playlists` table, the `FOREIGN KEY` constraint is applied.
* `podcast_id`, which represents the unique ID assigned to the 'liked' podcast as an `INTEGER`. Since this references the `id` column of the `Podcasts` table, the `FOREIGN KEY` constraint is applied.
* `artist_id`, which represents the unique ID assigned to the 'liked' artist as an `INTEGER`. Since this references the `id` column of the `Artists` table, the `FOREIGN KEY` constraint is applied.
* `album_id`, which represents the unique ID assigned to the 'liked' album as an `INTEGER`. Since this references the `id` column of the `Albums` table, the `FOREIGN KEY` constraint is applied.

### Relationships

The database relationships are detailed in the ERD below.

![ER Diagram](CS50_SQL_ERD.PNG)

This diagram explains:

* 0 to many Podcasts, Songs, Albums, Playlists, and Artists can all receive 0 to many 'likes'.
* A user can only 'like' the entities listed above one time, but can do so on 0 to many of them.
* One to many artists can create 0 to many Podcasts, Songs, or Albums. Each of those things needs at least one artist, however.
* A song can only be on one album, but an album can have one to many songs.
* An Artist must create at least one song or podcast to be considered as such, but doesn't need a whole album (0 to many) to do so.

## Optimizations

* Users of Spotify will often search what they want to listen to by name, whether it be an artist, album, song, etc. Due to this, indices have been created on artists' names, albums' names AND genres, song names, podcast genres, and songs that have been liked specifically by the user.

* A view has also been created to display the songs liked by the user for quick access to their preferred musical content.

## Limitations

* As it stands, this database is vulnerable to mistakes in classification and grouping, mostly due to the lack of corrections for typos.

* Scalability will need to be optimized as the database grows with more content.

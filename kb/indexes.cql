CREATE CONSTRAINT track_constraint
FOR (track: Track) REQUIRE (track.name, track.length) IS UNIQUE
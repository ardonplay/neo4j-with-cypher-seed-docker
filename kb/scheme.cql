CREATE (genre:Genre {name: "Trash Metal"});

MATCH (genre:Genre {name: "Trash Metal"})
CREATE (track:Track {name: "Master Of Puppets", length: 516})-[:IN_GENRE]->(genre);

MATCH (genre:Genre {name: "Trash Metal"})
CREATE (track:Track {name: "Battery", length: 313})-[:IN_GENRE]->(genre);

CREATE (band:Band {name: "Metallica", description: "Metallica is a band from California"});

CREATE (album:Album {name: "Master Of Puppets", year: 1986});

MATCH (album:Album {name: "Master Of Puppets", year: 1986}),(track:Track {name: "Master Of Puppets", length: 516})
CREATE (album)-[:INCLUDE]->(track);

MATCH (album:Album {name: "Master Of Puppets", year: 1986}), (track:Track {name: "Battery", length: 313})
CREATE (album)-[:INCLUDE]->(track);

MATCH (album:Album {name: "Master Of Puppets", year: 1986}), (band:Band {name: "Metallica", description: "Metallica is a band from California"})
CREATE (band)-[:HAS]->(album);
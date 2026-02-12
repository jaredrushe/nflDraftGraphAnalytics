// ============================================
// 1. IMPORT DATA AND CREATE NODES
// ============================================

LOAD CSV WITH HEADERS FROM 'file:///steeler.csv' AS row
MERGE (p:Player {id: row.`Player ID`})
SET p.name = row.Player,
    p.year = toInteger(row.Year),
    p.round = toInteger(row.Rnd),
    p.position = row.Pos,
    p.college = row.`College/Univ`,
    p.pb = toInteger(row.PB),
    p.starts = toInteger(row.St),
    p.games = toInteger(row.G),
    p.superbowl = toInteger(row.SB)

MERGE (pos:Position {name: row.Pos});
MERGE (c:College {name: row.`College/Univ`});

// ============================================
// 2. CREATE RELATIONSHIPS
// ============================================

MATCH (p:Player {id: row.`Player ID`})
MATCH (c:College {name: row.`College/Univ`})
MERGE (c)-[:PROVIDED]->(p);

MATCH (p:Player {id: row.`Player ID`})
MATCH (c:College {name: row.`College/Univ`})
MERGE (p)-[:ATTENDED]->(c);

MATCH (p:Player), (pos:Position)
WHERE p.position = pos.name
MERGE (p)-[:PLAYS_AS]-(pos);

MATCH (p:Player), (pos:Position)
WHERE p.position = pos.name
MERGE (pos)-[:PLAYED_BY]->(p);

MATCH (p1:Player)-[:PLAYS_AS]->(pos:Position)<-[:PLAYS_AS]-(p2:Player)
WHERE p1 <> p2
MERGE (p1)-[:SAME_POSITION]-(p2);

MATCH (p1:Player)-[:ATTENDED]->(c:College)<-[:ATTENDED]-(p2:Player)
WHERE p1 <> p2
MERGE (p1)-[:SAME_COLLEGE]-(p2);

MATCH (p1:Player), (p2:Player)
WHERE p1 <> p2 AND p1.round = p2.round
MERGE (p1)-[:SAME_DRAFT_ROUND]-(p2);

// ============================================
// 3. PROJECT FULL GRAPH
// ============================================

CALL gds.graph.project(
  'playerGraph',
  ['Player', 'Position', 'College'],
  ['PLAYS_AS', 'ATTENDED', 'SAME_COLLEGE', 'SAME_DRAFT_ROUND', 'SAME_POSITION', 'PLAYED_BY', 'PROVIDED']
) YIELD graphName, nodeCount, relationshipCount;

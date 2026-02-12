// ============================================
// DEGREE CENTRALITY — Most drafted positions
// ============================================

CALL gds.degree.stream('playerGraph')
YIELD nodeId, score
WITH nodeId, score
MATCH (pos:Position) WHERE id(pos) = nodeId
RETURN pos.name AS Position, score as degree
ORDER BY degree DESC
LIMIT 5;

// ============================================
// SUPER BOWL WINNERS SUBGRAPH
// ============================================

CALL gds.graph.project.cypher(
  'sbGraph',
  'MATCH (p:Player) WHERE p.superbowl > 0 RETURN id(p) AS id UNION MATCH (c:College) RETURN id(c) AS id UNION MATCH (pos:Position) RETURN id(pos) AS id',
  'MATCH (c:College)-[:PROVIDED]->(p:Player) WHERE p.superbowl > 0 RETURN id(c) AS source, id(p) AS target UNION
   MATCH (p:Player)-[:ATTENDED]->(c:College) WHERE p.superbowl > 0 RETURN id(p) AS source, id(c) AS target UNION
   MATCH (p1:Player)-[:PLAYS_AS]->(pos:Position)<-[:PLAYS_AS]-(p2:Player) WHERE p1.superbowl > 0 AND p2.superbowl > 0 RETURN id(p1) AS source, id(p2) AS target UNION
   MATCH (p1:Player)-[:SAME_DRAFT_ROUND]->(p2:Player) WHERE p1.superbowl > 0 AND p2.superbowl > 0 RETURN id(p1) AS source, id(p2) AS target UNION
   MATCH (p1:Player)-[:SAME_COLLEGE]->(p2:Player) WHERE p1.superbowl > 0 AND p2.superbowl > 0 RETURN id(p1) AS source, id(p2) AS target UNION
   MATCH (pos:Position)-[:PLAYED_BY]->(p:Player) WHERE p.superbowl > 0 RETURN id(pos) AS source, id(p) AS target'
) YIELD graphName, nodeCount, relationshipCount;

// Degree centrality — Super Bowl winners
CALL gds.degree.stream('sbGraph')
YIELD nodeId, score
WITH nodeId, score
MATCH (pos:Position) WHERE id(pos) = nodeId
RETURN pos.name AS Position, score as degree
ORDER BY degree DESC
LIMIT 5;

// ============================================
// BETWEENNESS CENTRALITY — Most connected colleges
// ============================================

CALL gds.betweenness.stream('playerGraph')
YIELD nodeId, score
WITH nodeId, score
MATCH (c:College) WHERE id(c) = nodeId
RETURN c.name AS College, score
ORDER BY score DESC
LIMIT 5;

// ============================================
// STARTERS SUBGRAPH (3+ seasons as starter)
// ============================================

CALL gds.graph.project.cypher(
  'startingGraph',
  'MATCH (p:Player) WHERE p.starts >= 3 RETURN id(p) AS id UNION MATCH (c:College) RETURN id(c) AS id UNION MATCH (pos:Position) RETURN id(pos) AS id',
  'MATCH (c:College)-[:PROVIDED]->(p:Player) WHERE p.starts >= 3 RETURN id(c) AS source, id(p) AS target UNION
   MATCH (p:Player)-[:ATTENDED]->(c:College) WHERE p.starts >= 3 RETURN id(p) AS source, id(c) AS target UNION
   MATCH (p1:Player)-[:PLAYS_AS]->(pos:Position)<-[:PLAYS_AS]-(p2:Player) WHERE p1.starts >= 3 AND p2.starts >= 3 RETURN id(p1) AS source, id(p2) AS target UNION
   MATCH (p1:Player)-[:SAME_DRAFT_ROUND]->(p2:Player) WHERE p1.starts >= 3 AND p2.starts >= 3 RETURN id(p1) AS source, id(p2) AS target UNION
   MATCH (p1:Player)-[:SAME_COLLEGE]->(p2:Player) WHERE p1.starts >= 3 AND p2.starts >= 3 RETURN id(p1) AS source, id(p2) AS target UNION
   MATCH (pos:Position)-[:PLAYED_BY]->(p:Player) WHERE p.starts >= 3 RETURN id(pos) AS source, id(p) AS target'
) YIELD graphName, nodeCount, relationshipCount;

// Betweenness centrality — starters only
CALL gds.betweenness.stream('startingGraph')
YIELD nodeId, score
WITH nodeId, score
MATCH (c:College) WHERE id(c) = nodeId
RETURN c.name AS College, score
ORDER BY score DESC
LIMIT 5;

// ============================================
// PAGERANK — Archetypal Steelers draft picks
// ============================================

CALL gds.pageRank.stream('playerGraph')
YIELD nodeId, score
WITH nodeId, score
MATCH (p:Player) WHERE id(p) = nodeId
RETURN p.name as Player, p.college as College, p.round as Round, p.position as Position, score
ORDER BY score DESC
LIMIT 5;

// ============================================
// 50+ GAMES SUBGRAPH
// ============================================

CALL gds.graph.project.cypher(
  'played50GamesGraph',
  'MATCH (p:Player) WHERE p.games >= 50 RETURN id(p) AS id UNION MATCH (pos:Position) RETURN id(pos) AS id UNION MATCH (c:College) RETURN id(c) AS id',
  'MATCH (p:Player)-[:PLAYS_AS]->(pos:Position) WHERE p.games >= 50 RETURN id(p) AS source, id(pos) AS target UNION
   MATCH (p:Player)-[:ATTENDED]->(c:College) WHERE p.games >= 50 RETURN id(p) AS source, id(c) AS target UNION
   MATCH (p1:Player)-[:SAME_COLLEGE]->(p2:Player) WHERE p1.games >= 50 AND p2.games >= 50 RETURN id(p1) AS source, id(p2) AS target UNION
   MATCH (p1:Player)-[:SAME_DRAFT_ROUND]->(p2:Player) WHERE p1.games >= 50 AND p2.games >= 50 RETURN id(p1) AS source, id(p2) AS target'
) YIELD graphName, nodeCount, relationshipCount;

// PageRank — 50+ game veterans
CALL gds.pageRank.stream('played50GamesGraph')
YIELD nodeId, score
WITH nodeId, score
MATCH (p:Player) WHERE id(p) = nodeId
RETURN p.name as Player, p.college as College, p.round as Round, p.position as Position, score
ORDER BY score DESC
LIMIT 5;

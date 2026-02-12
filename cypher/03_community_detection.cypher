// ============================================
// 1. PROJECT BIDIRECTIONAL PLAYER SUBGRAPH
// ============================================

CALL gds.graph.project.cypher(
  'triangleGraph',
  'MATCH (p:Player) RETURN id(p) AS id',
  'MATCH (p1:Player)-[:SAME_COLLEGE]-(p2:Player) RETURN id(p1) AS source, id(p2) AS target
   UNION
   MATCH (p1:Player)-[:SAME_POSITION]-(p2:Player) RETURN id(p1) AS source, id(p2) AS target
   UNION
   MATCH (p1:Player)-[:SAME_DRAFT_ROUND]-(p2:Player) RETURN id(p1) AS source, id(p2) AS target'
) YIELD graphName, nodeCount, relationshipCount;

// ============================================
// 2. LOUVAIN COMMUNITY DETECTION
// ============================================

CALL gds.louvain.stream('triangleGraph')
YIELD nodeId, communityId
MATCH (p:Player) WHERE id(p) = nodeId
SET p.communityId = communityId;

// ============================================
// 3. BEST AND WORST PERFORMING COMMUNITIES
// ============================================

// Best performing
MATCH (p:Player)
WITH p.communityId AS communityId, COUNT(p) AS numPlayers,
     AVG(p.games) AS avgGames,
     AVG(p.superbowl) AS avgSuperbowlWins,
     AVG(CASE WHEN p.pb > 0 THEN 1 ELSE 0 END) AS avgProBowlSelections,
     AVG(p.starts) AS avgStarts
ORDER BY avgSuperbowlWins DESC, avgGames DESC, avgStarts DESC
LIMIT 10
RETURN communityId, numPlayers, avgGames, avgSuperbowlWins, avgProBowlSelections, avgStarts;

// Worst performing
MATCH (p:Player)
WITH p.communityId AS communityId, COUNT(p) AS numPlayers,
     AVG(p.games) AS avgGames,
     AVG(p.superbowl) AS avgSuperbowlWins,
     AVG(CASE WHEN p.pb > 0 THEN 1 ELSE 0 END) AS avgProBowlSelections,
     AVG(p.starts) AS avgStarts
ORDER BY avgSuperbowlWins ASC, avgGames ASC, avgStarts ASC
LIMIT 10
RETURN communityId, numPlayers, avgGames, avgSuperbowlWins, avgProBowlSelections, avgStarts;

// ============================================
// 4. PROFILE COMMUNITY ATTRIBUTES
// ============================================

// Most successful community (763)
CALL {
    MATCH (p:Player)
    WHERE p.communityId = 763
    RETURN p.round AS value, COUNT(*) AS count, "DraftRound" AS type
    ORDER BY count DESC
    LIMIT 5
    UNION
    MATCH (p:Player)
    WHERE p.communityId = 763
    RETURN p.college AS value, COUNT(*) AS count, "College" AS type
    ORDER BY count DESC
    LIMIT 5
    UNION
    MATCH (p:Player)
    WHERE p.communityId = 763
    RETURN p.position AS value, COUNT(*) AS count, "Position" AS type
    ORDER BY count DESC
    LIMIT 5
}
WITH value, count, type
RETURN
  COLLECT(CASE WHEN type = "DraftRound" THEN value END) AS DraftRounds,
  COLLECT(CASE WHEN type = "College" THEN value END) AS Colleges,
  COLLECT(CASE WHEN type = "Position" THEN value END) AS Positions;

// Second most successful community (1324)
CALL {
    MATCH (p:Player)
    WHERE p.communityId = 1324
    RETURN p.round AS value, COUNT(*) AS count, "DraftRound" AS type
    ORDER BY count DESC
    LIMIT 5
    UNION
    MATCH (p:Player)
    WHERE p.communityId = 1324
    RETURN p.college AS value, COUNT(*) AS count, "College" AS type
    ORDER BY count DESC
    LIMIT 5
    UNION
    MATCH (p:Player)
    WHERE p.communityId = 1324
    RETURN p.position AS value, COUNT(*) AS count, "Position" AS type
    ORDER BY count DESC
    LIMIT 5
}
WITH value, count, type
RETURN
  COLLECT(CASE WHEN type = "DraftRound" THEN value END) AS DraftRounds,
  COLLECT(CASE WHEN type = "College" THEN value END) AS Colleges,
  COLLECT(CASE WHEN type = "Position" THEN value END) AS Positions;

// Least successful community (1086)
CALL {
    MATCH (p:Player)
    WHERE p.communityId = 1086
    RETURN p.round AS value, COUNT(*) AS count, "DraftRound" AS type
    ORDER BY count DESC
    LIMIT 5
    UNION
    MATCH (p:Player)
    WHERE p.communityId = 1086
    RETURN p.college AS value, COUNT(*) AS count, "College" AS type
    ORDER BY count DESC
    LIMIT 5
    UNION
    MATCH (p:Player)
    WHERE p.communityId = 1086
    RETURN p.position AS value, COUNT(*) AS count, "Position" AS type
    ORDER BY count DESC
    LIMIT 5
}
WITH value, count, type
RETURN
  COLLECT(CASE WHEN type = "DraftRound" THEN value END) AS DraftRounds,
  COLLECT(CASE WHEN type = "College" THEN value END) AS Colleges,
  COLLECT(CASE WHEN type = "Position" THEN value END) AS Positions;

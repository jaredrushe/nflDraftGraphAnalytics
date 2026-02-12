# Pittsburgh Steelers Draft Strategy — Graph Analytics

Exploring patterns in the Pittsburgh Steelers' NFL Draft history using graph theory, centrality analysis, and community detection in Neo4j.

## Overview

The Pittsburgh Steelers are the most decorated franchise in NFL history, with six Super Bowl titles. The draft is the primary mechanism for acquiring talent in the NFL, so an effective selection process is a cornerstone of sustained success. This project models the Steelers' entire draft history (1936–2024) as a graph database and applies network analytics to uncover the positions, colleges, and draft rounds that have driven the franchise's dominance — and where untapped potential remains.

## Research Questions

- Which positions does the franchise prioritise, and do those picks translate to championship success?
- Are there preferred college pipelines, and do they actually produce the most impactful players?
- What player archetypes (position, round, college) cluster together among the most and least successful draft picks?

## Key Findings

- **Tackles, Backs, Guards, Defensive Backs, and Linebackers** are the most frequently drafted positions — and DB, LB, and T remain the most connected among Super Bowl winners, validating the strategy
- **University of Texas** has the highest betweenness centrality overall, but **none of the top 5 colleges** for long-term starters (3+ seasons) overlap with the top 5 overall — suggesting a disconnect between where the team drafts and where their best players actually come from
- The **most successful player community** contains a surprising mix of Round 1 picks alongside Rounds 12–17, indicating the Steelers have a strong ability to find hidden gems in late rounds
- **Running Back and Wide Receiver** emerge as highly connected positions among Super Bowl winners and long-career players, despite not being among the most frequently drafted — a potential area for increased investment
- The **least successful community** is dominated by very late-round picks (Rounds 15–22) from a mix of elite and smaller programs, with near-zero games played

## Graph Model

The dataset was scraped from [Pro Football Reference](https://www.pro-football-reference.com/teams/pit/draft.htm) and modelled in Neo4j with the following schema:

**Nodes** (1,673 total):
| Type | Count | Properties |
|------|-------|------------|
| Player | 1,366 | name, year, round, position, college, games, starts, Pro Bowls, Super Bowls |
| Position | 29 | name |
| College | 278 | name |

**Relationships** (124,432 total):
| Relationship | Description |
|-------------|-------------|
| `ATTENDED` / `PROVIDED` | Player ↔ College |
| `PLAYS_AS` / `PLAYED_BY` | Player ↔ Position |
| `SAME_COLLEGE` | Players who attended the same college |
| `SAME_DRAFT_ROUND` | Players selected in the same round |
| `SAME_POSITION` | Players who play the same position |

## Analytics Techniques

- **Degree centrality** — identifying the most frequently drafted positions, compared across the full graph and a Super Bowl winners subgraph
- **Betweenness centrality** — finding the most strategically connected colleges, compared across all players vs long-term starters (3+ seasons)
- **PageRank** — identifying the most "archetypal" Steelers draft picks based on connection quality, compared across all players vs 50+ game veterans
- **Louvain community detection** — clustering players by shared college, position, and draft round to profile the characteristics of the most and least successful groups

## Tech Stack

- **Neo4j** + **Graph Data Science (GDS)** library
- **Cypher** query language
- **Python** (pandas) for data preparation and web scraping

## Data Source

- [Pro Football Reference — Steelers Draft History](https://www.pro-football-reference.com/teams/pit/draft.htm)
- Super Bowl rosters scraped from Pro Football Reference for the franchise's 6 championship seasons

## Project Structure

```
├── data/                   # Scraped CSV datasets
├── cypher/                 # Neo4j Cypher queries
├── scripts/                # Python data preparation scripts
├── report/                 # Technical report (PDF)
└── README.md
```

## License

MIT

import pandas as pd

steelers_file = "data/steeler.csv"
rosters_file = "data/rosters.csv"

steelers_df = pd.read_csv(steelers_file)
rosters_df = pd.read_csv(rosters_file)

roster_players = set(rosters_df['Player'].values)

steelers_df['SB'] = 0

for index, row in steelers_df.iterrows():
    if row['Player'] in roster_players:
        steelers_df.at[index, 'SB'] += 1

steelers_df.to_csv(steelers_file, index=False)

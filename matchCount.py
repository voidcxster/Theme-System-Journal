matches: dict[str, list[tuple[str, ...]]] = {'John Dickey v. "Twig" Yurick': [('Paper', 'Paper'), ('Draw', 'Draw'), ('Scissors', 'Scissors'), ('Draw', 'Draw'), ('Paper', 'Scissors'), ('Lose', 'Win'), ('Paper', 'Rock'), ('Win', 'Lose'), ('Rock', 'Scissors'), ('Win', 'Lose')], 'Thomas Altman v. Jenny "The Gavel"': [('Paper', 'Paper'), ('Draw', 'Draw'), ('Rock', 'Paper'), ('Lose', 'Win'), ('Rock', 'Scissors'), ('Win', 'Lose'), ('Scissors', 'Paper'), ('Win', 'Lose')], 'Duane Bruun v. Greg "The Goose"': [('Rock', 'Scissors'), ('Win', 'Lose'), ('Paper', 'Rock'), ('Win', 'Lose'), ('Scissors', 'Rock'), ('Lose', 'Win'), ('Paper', 'Scissors'), ('Lose', 'Win')], 'Rob "Grappler" Gorey v. Kristina "Red Rock"': [('Paper', 'Paper'), ('Draw', 'Draw'), ('Rock', 'Scissors'), ('Win', 'Lose'), ('Scissors', 'Rock'), ('Lose', 'Win'), ('Paper', 'Scissors'), ('Lose', 'Win')], 'Richard "Stone" Wells v. Lacey "Scissorhands"': [('Rock', 'Paper'), ('Lose', 'Win'), ('Rock', 'Scissors'), ('Win', 'Lose'), ('Rock', 'Paper'), ('Lose', 'Win'), ('Rock', 'Paper'), ('Lose', 'Win'), ('Rock', 'Paper'), ('Lose', 'Win')], 'Silva Barrera v. Amber "Quarters"': [('Scissors', 'Rock'), ('Lose', 'Win'), ('Rock', 'Paper'), ('Lose', 'Win'), ('Paper', 'Scissors'), ('Lose', 'Win'), ('Rock', 'Paper'), ('Lose', 'Win')], 'Russell "The Muscle" v. John Dickey': [('Unknown', 'Unknown'), ('Win', 'Lose'), ('Scissors', 'Paper'), ('Win', 'Lose'), ('Rock', 'Scissors'), ('Win', 'Lose'), ('Paper', 'Rock'), ('Win', 'Lose')], 'Golden Groves v. Jason "Fat" Albers': [('Unknown', 'Unknown'), ('Win', 'Lose'), ('Unknown', 'Unknown'), ('Lose', 'Win'), ('Paper', 'Paper'), ('Draw', 'Draw'), ('Rock', 'Rock'), ('Draw', 'Draw'), ('Rock', 'Rock'), ('Draw', 'Draw'), ('Rock', 'Rock'), ('Draw', 'Draw'), ('Rock', 'Rock'), ('Draw', 'Draw'), ('Rock', 'Rock'), ('Draw', 'Draw'), ('Rock', 'Rock'), ('Draw', 'Draw'), ('Scissors', 'Paper'), ('Win', 'Lose')], 'Lynne Tuccio v. Jason Wood': [('Scissors', 'Rock'), ('Lose', 'Win'), ('Rock', 'Paper'), ('Lose', 'Win'), ('Paper', 'Scissors'), ('Lose', 'Win'), ('Paper', 'Scissors'), ('Lose', 'Win'), ('Rock', 'Rock'), ('Draw', 'Draw'), ('Scissors', 'Scissors'), ('Draw', 'Draw'), ('Scissors', 'Rock'), ('Lose', 'Win'), ('Rock', 'Scissors'), ('Win', 'Lose'), ('Scissors', 'Paper'), ('Win', 'Lose'), ('Scissors', 'Scissors'), ('Draw', 'Draw'), ('Rock', 'Scissors'), ('Win', 'Lose'), ('Scissors', 'Scissors'), ('Draw', 'Draw'), ('Rock', 'Scissors'), ('Win', 'Lose'), ('Scissors', 'Paper'), ('Win', 'Lose'), ('Rock', 'Paper'), ('Lose', 'Win')], '"Fast-Twitch" Twitchel v. Matt "Double Fister"': [('Rock', 'Scissors'), ('Win', 'Lose'), ('Scissors', 'Rock'), ('Lose', 'Win'), ('Scissors', 'Scissors'), ('Draw', 'Draw'), ('Scissors', 'Paper'), ('Win', 'Lose')], 'Greg "The Goose" v. "Claw" Clemmer': [('Paper', 'Rock'), ('Win', 'Lose'), ('Scissors', 'Rock'), ('Lose', 'Win'), ('Paper', 'Paper'), ('Draw', 'Draw'), ('Paper', 'Rock'), ('Win', 'Lose')], 'Amber "Quarters" v. "Striped Smurf"': [('Rock', 'Paper'), ('Lose', 'Win'), ('Paper', 'Scissors'), ('Lose', 'Win'), ('Scissors', 'Rock'), ('Lose', 'Win'), ('Paper', 'Scissors'), ('Lose', 'Win')], 'Dave "The Drill" McGill v. Carl "Tiny" Kirchner': [('Rock', 'Scissors'), ('Win', 'Lose'), ('Scissors', 'Paper'), ('Win', 'Lose'), ('Paper', 'Rock'), ('Win', 'Lose'), ('Rock', 'Scissors'), ('Win', 'Lose')], '"Iron Fist" Cardwell v. Lacey "Scissorhands"': [('Paper', 'Scissors'), ('Lose', 'Win'), ('Paper', 'Scissors'), ('Rock', 'Scissors'), ('Win', 'Lose'), ('Scissors', 'Rock'), ('Lose', 'Win'), ('Scissors', 'Paper'), ('Win', 'Lose')], 'Lynne Tuccio v. Jason Wood cont.': [('Rock', 'Paper'), ('Lose', 'Win'), ('Paper', 'Rock'), ('Win', 'Lose'), ('Paper', 'Paper'), ('Draw', 'Draw'), ('Scissors', 'Scissors'), ('Draw', 'Draw'), ('Paper', 'Paper'), ('Draw', 'Draw'), ('Rock', 'Paper'), ('Lose', 'Win'), ('Rock', 'Scissors'), ('Win', 'Lose'), ('Scissors', 'Scissors'), ('Draw', 'Draw'), ('Paper', 'Rock'), ('Win', 'Lose')], 'Kristina "Red Rock" v. "Superman" Macy': [('Rock', 'Paper'), ('Lose', 'Win'), ('Rock', 'Scissors'), ('Win', 'Lose'), ('Scissors', 'Paper'), ('Win', 'Lose'), ('Paper', 'Rock'), ('Win', 'Lose'), ('Rock', 'Paper'), ('Lose', 'Win'), ('Paper', 'Rock'), ('Win', 'Lose')], 'Dave "The Drill" McGill v. "Claw" Clemmer': [('Rock', 'Paper'), ('Lose', 'Win'), ('Rock', 'Scissors'), ('Win', 'Lose'), ('Scissors', 'Paper'), ('Win', 'Lose'), ('Paper', 'Rock'), ('Win', 'Lose'), ('Rock', 'Scissors'), ('Win', 'Lose')], 'Kristina "Red Rock" v. Sandy "Rabbit Patch"': [('Rock', 'Paper'), ('Lose', 'Win'), ('Paper', 'Scissors'), ('Lose', 'Win'), ('Scissors', 'Rock'), ('Lose', 'Win'), ('Rock', 'Paper'), ('Lose', 'Win')], '"Fast-Twitch" Twitchell v. "Squint" Kleinschmidt': [('Paper', 'Rock'), ('Win', 'Lose'), ('Scissors', 'Rock'), ('Lose', 'Win'), ('Paper', 'Scissors'), ('Lose', 'Win'), ('Scissors', 'Rock'), ('Lose', 'Win'), ('Rock', 'Scissors'), ('Win', 'Lose')], 'Dave "The Drill" McGill v. Sandy "Rabbit Patch"': [('Paper', 'Scissors'), ('Lose', 'Win'), ('Rock', 'Paper'), ('Lose', 'Win'), ('Scissors', 'Rock'), ('Lose', 'Win'), ('Rock', 'Scissors'), ('Win', 'Lose'), ('Rock', 'Scissors'), ('Win', 'Lose'), ('Paper', 'Scissors'), ('Lose', 'Win'), ('Paper', 'Rock'), ('Win', 'Lose'), ('Paper', 'Scissors'), ('Lose', 'Win')], 'Lynne Tuccio v. Jason Wood cont. cont.': [('Rock', 'Paper'), ('Lose', 'Win'), ('Scissors', 'Paper'), ('Win', 'Lose'), ('Rock', 'Paper'), ('Lose', 'Win'), ('Scissors', 'Scissors'), ('Draw', 'Draw'), ('Scissors', 'Scissors'), ('Draw', 'Draw'), ('Scissors', 'Rock'), ('Lose', 'Win')], 'Dave "The Drill" McGill v. "Iron Fist" Cardwell': [('Scissors', 'Paper'), ('Win', 'Lose'), ('Scissors', 'Rock'), ('Lose', 'Win'), ('Scissors', 'Paper'), ('Win', 'Lose'), ('Paper', 'Paper'), ('Draw', 'Draw'), ('Rock', 'Scissors'), ('Win', 'Lose'), ('Scissors', 'Paper'), ('Win', 'Lose')], '"Fast-Twitch" Twitchel v. "Wild Hand" Albright': [('Scissors', 'Paper'), ('Win', 'Lose'), ('Paper', 'Rock'), ('Win', 'Lose'), ('Scissors', 'Paper'), ('Win', 'Lose'), ('Scissors', 'Rock'), ('Lose', 'Win'), ('Scissors', 'Paper'), ('Win', 'Lose')], '"Fast-Twitch" Twitchel v. Dave "The Drill" McGill': [('Paper', 'Scissors'), ('Lose', 'Win'), ('Paper', 'Rock'), ('Win', 'Lose'), ('Scissors', 'Rock'), ('Lose', 'Win'), ('Rock', 'Rock'), ('Draw', 'Draw'), ('Rock', 'Scissors'), ('Win', 'Lose'), ('Scissors', 'Rock'), ('Lose', 'Win'), ('Rock', 'Scissors'), ('Win', 'Lose'), ('Paper', 'Paper'), ('Draw', 'Draw'), ('Rock', 'Paper'), ('Lose', 'Win'), ('Rock', 'Paper'), ('Lose', 'Win')]}
uniqueMatches: set[str] = set()
for matchName in matches:
    uniqueMatches.add(matchName)

print(f'''All matches: {uniqueMatches}
Length: {len(uniqueMatches)}''')
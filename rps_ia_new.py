from typing import Any
from bidict import bidict
import itertools

xls: str = '''John Dickey	"Twig" Yurick		Thomas Altman	Jenny "The Gavel"		Duane Bruun	Greg "The Goose"				Rob "Grappler" Gorey	Kristina "Red Rock"		Richard "Stone" Wells	Lacey "Scissorhands"				Silva Barrera	Amber "Quarters"				Russell "The Muscle"	John Dickey				Golden Groves	Jason "Fat" Albers		Lynne Tuccio	Jason Wood		"Fast-Twitch" Twitchel	Matt "Double Fister"		Greg "The Goose"	"Claw" Clemmer		Amber "Quarters"	"Striped Smurf"				Dave "The Drill" McGill	Carl "Tiny" Kirchner				"Iron Fist" Cardwell	Lacey "Scissorhands"				Lynne Tuccio	Jason Wood		Kristina "Red Rock"	"Superman" Macy				Dave "The Drill" McGill	"Claw" Clemmer				Kristina "Red Rock"	Sandy "Rabbit Patch"				"Fast-Twitch" Twitchell	"Squint" Kleinschmidt				Dave "The Drill" McGill	Sandy "Rabbit Patch"						Lynne Tuccio	Jason Wood		Dave "The Drill" McGill	"Iron Fist" Cardwell				"Fast-Twitch" Twitchel	"Wild Hand" Albright				"Fast-Twitch" Twitchel	Dave "The Drill" McGill				
Paper	Paper		Paper	Paper		Rock	Scissors	Scissors	Rock		Paper	Paper		Rock	Paper	Rock	Paper		Scissors	Rock	Paper	Scissors		Unknown	Unknown	Rock	Scissors		Unknown	Unknown		Scissors	Rock		Rock	Scissors		Paper	Rock		Rock	Paper	Scissors	Rock		Rock	Scissors	Paper	Rock		Paper	Scissors	Rock	Scissors		Rock	Paper		Rock	Paper	Paper	Rock		Rock	Paper	Paper	Rock		Rock	Paper	Scissors	Rock		Paper	Rock	Scissors	Rock		Paper	Scissors	Scissors	Rock	Paper	Scissors		Rock	Paper		Scissors	Paper	Paper	Paper		Scissors	Paper	Scissors	Paper		Paper	Scissors	Rock	Rock	Paper	Paper
Draw	Draw		Draw	Draw		Win	Lose	Lose	Win		Draw	Draw		Lose	Win	Lose	Win		Lose	Win	Lose	Win		Win	Lose	Win	Lose		Win	Lose		Lose	Win		Win	Lose		Win	Lose		Lose	Win	Lose	Win		Win	Lose	Win	Lose		Lose	Win	Win	Lose		Lose	Win		Lose	Win	Win	Lose		Lose	Win	Win	Lose		Lose	Win	Lose	Win		Win	Lose	Lose	Win		Lose	Win	Lose	Win	Lose	Win		Lose	Win		Win	Lose	Draw	Draw		Win	Lose	Win	Lose		Lose	Win	Draw	Draw	Draw	Draw
Scissors	Scissors		Rock	Paper		Paper	Rock	Paper	Scissors		Rock	Scissors		Rock	Scissors	Rock	Paper		Rock	Paper	Rock	Paper		Scissors	Paper	Paper	Rock		Unknown	Unknown		Rock	Paper		Scissors	Rock		Scissors	Rock		Paper	Scissors	Paper	Scissors		Scissors	Paper	Rock	Scissors		Paper	Scissors	Scissors	Rock		Paper	Rock		Rock	Scissors	Rock	Paper		Rock	Scissors	Rock	Scissors		Paper	Scissors	Rock	Paper		Scissors	Rock	Rock	Scissors		Rock	Paper	Rock	Scissors	Paper	Rock		Scissors	Paper		Scissors	Rock	Rock	Scissors		Paper	Rock	Scissors	Rock		Paper	Rock	Rock	Scissors	Rock	Paper
Draw	Draw		Lose	Win		Win	Lose	Lose	Win		Win	Lose		Win	Lose	Lose	Win		Lose	Win	Lose	Win		Win	Lose	Win	Lose		Lose	Win		Lose	Win		Lose	Win		Lose	Win		Lose	Win	Lose	Win		Win	Lose	Win	Lose		Lose	Win	Lose	Win		Win	Lose		Win	Lose	Lose	Win		Win	Lose	Win	Lose		Lose	Win	Lose	Win		Lose	Win	Win	Lose		Lose	Win	Win	Lose	Win	Lose		Win	Lose		Lose	Win	Win	Lose		Win	Lose	Lose	Win		Win	Lose	Win	Lose	Lose	Win
Paper	Scissors		Rock	Scissors		1	1	1	2		Scissors	Rock		Rock	Paper	0	2		0	1	0	2		1	0	2	0		Paper	Paper		Paper	Scissors		Scissors	Scissors		Paper	Paper		0	1	0	2		0	1	0	2		1	1	Scissors	Paper		Paper	Paper		Scissors	Paper	Paper	Rock		Scissors	Paper	2	0		0	1	0	2		Paper	Scissors	0	2		0	1	Rock	Scissors	Paper	Scissors		Rock	Paper		Scissors	Paper	Scissors	Paper		1	0	Scissors	Paper		Scissors	Rock	Scissors	Rock	Rock	Paper
Lose	Win		Win	Lose							Lose	Win		Lose	Win														Draw	Draw		Lose	Win		Draw	Draw		Draw	Draw														Win	Lose		Draw	Draw		Win	Lose	Win	Lose		Win	Lose									Lose	Win						Win	Lose	Lose	Win		Lose	Win		Win	Lose	Win	Lose				Win	Lose		Lose	Win	Lose	Win	Lose	Win
Paper	Rock		Scissors	Paper							Paper	Scissors		0	1														Rock	Rock		Paper	Scissors		Scissors	Paper		Paper	Rock														2	1		Scissors	Scissors		1	0	2	0		1	0									0	1						1	1	1	2		Scissors	Scissors		1	0	2	0				2	0		0	1	Rock	Scissors	1	2
Win	Lose		Win	Lose							Lose	Win																	Draw	Draw		Lose	Win		Win	Lose		Win	Lose																	Draw	Draw																													Draw	Draw														Win	Lose		
Rock	Scissors																												Rock	Rock		Rock	Rock		2	1		2	1																	Paper	Paper																													Scissors	Scissors														1	1		
Win	Lose																												Draw	Draw		Draw	Draw																							Draw	Draw																													Draw	Draw																	
2	1																												Rock	Rock		Scissors	Scissors																							Rock	Paper																													Scissors	Rock																	
Win	Lose																												Draw	Draw		Draw	Draw		rock	0		< these values were found with the excel find (^f) function, for some reason the formula breaks if too many cells are given to it																		Lose	Win																													Lose	Win																	
																													Rock	Rock		Scissors	Rock		paper	22																				Rock	Scissors																																															
																													Draw	Draw		Lose	Win		scissors	16				Count number of wins	 of winScissors	2	0	2												Win	Lose																																															
																													Rock	Rock		Rock	Scissors				rock	94																		Scissors	Scissors																																															
																													Draw	Draw		Win	Lose				paper	88																		Draw	Draw																																															
																													Rock	Rock		Scissors	Paper				scissors	92																		Paper	Rock																																															
																													Draw	Draw		Win	Lose																							Win	Lose																																															
																													Scissors	Paper		Scissors	Scissors		rock	27																																																																				
																													Win	Lose		Draw	Draw		paper	3																																																																				
																																Rock	Scissors		scissors	3																																																																				
																																Win	Lose																																																																							
																																Scissors	Scissors																																																																							
																																Draw	Draw																																																																							
																																Rock	Scissors																																																																							
																																Win	Lose																																																																							
																																Scissors	Paper																																																																							
																																Win	Lose																																																																							
																																Rock	Paper																																																																							
																																Lose	Win																																																																							'''

matchUps: dict[str, bidict[str, str]] = {
    'Rock': bidict({
        'Win': 'Scissors',
        'Lose': 'Paper',
        'Draw': 'Rock'
    }),
    'Paper': bidict({
        'Win': 'Rock',
        'Lose': 'Scissors',
        'Draw': 'Paper'
    }),
    'Scissors': bidict({
        'Win': 'Paper',
        'Lose': 'Rock',
        'Draw': 'Scissors'
    })
}

class Matrix:
    def __init__(self, xlsData: str):
        self.rockCounters = {
            'rock': 'tie'
        }
        self.matrix: list[list[str]] = [
            line.split("\t") for line in xlsData.split("\n")
        ]
        self.affectedThrows: dict[str, dict[str, int]] = {
            'Win': {},
            'Lose': {},
            'Draw': {}
        }
        self.calculateValues()
        
    # region
    def calculateValues(self):
        self.rockCount: int = 0
        self.paperCount: int = 0
        self.scissorsCount: int = 0
        self.rockCountByRow: dict[int, int] = {}
        self.winStayRockCount: int = 0
        for y, row in enumerate(self.matrix):
            for x, item in enumerate(row):
                match item:
                    case 'Rock':
                        # print(self.matrix[y + 1][x])
                        self.rockCount += 1
                        if y in self.rockCountByRow.keys():
                            self.rockCountByRow[y] += 1
                        else:
                            self.rockCountByRow[y] = 1
                        if self[x, y + 1] == 'Win' and self[x, y + 2] == 'Rock':
                            print('win-stay w rock')
                            self.winStayRockCount += 1
                    case 'Paper':
                        self.paperCount += 1
                        try:
                            if self[x, y + 1] == 'Win' and self[x, y + 2] == 'Paper':
                                print('win-stay w paper')
                        except IndexError:
                            print("indexerror")
                    case 'Scissors':
                        self.scissorsCount += 1
                        if self[x, y + 1] == 'Win' and self[x, y + 2] == 'Scissors':
                            print('win-stay w scissors')
        self.totalThrowCount: int = self.rockCount + self.paperCount + self.scissorsCount

    def __getitem__(self, coordinates: tuple[int, ...]) -> Any:
        x, y = coordinates
        return self.matrix[y][x]
    
    def whoWinsFilter(self, p1, p2):
        pass
    
    def testWinStay(self, rpsDict, t1, t2):
        pass    

    def testLoseShift(self, rpsDict, t1, t2):
        pass

    # endregion

    def initRpsGamesDict(self):
        pass

    def filterAffectedThrows(self, throw: str) -> None:
        try:
            # increment per play count
            locals()[f'{throw.lower()}Count'] += 1

            gameResult: str = Match[y + 1][x]
            nextThrow: str = Match[y + 2][x]

            # test effects of win
            validResults: list[str] = ['Win', 'Lose', 'Draw']
            if gameResult in validResults:
                nextMatchUpWithCurrent: str = matchUps[throw][nextThrow]
                if gameResult in self.affectedThrows.keys() and nextMatchUpWithCurrent in self.affectedThrows[gameResult].keys():
                    affectedThrows[gameResult][nextMatchUpWithCurrent] += 1
                    print('entered try statement')
                else:
                    affectedThrows[gameResult][nextMatchUpWithCurrent] = 1
                    print('handled error')
            # elif gameResult == 'Lose':
            #     pass
            # elif gameResult == 'Draw':
            #     pass
            else:
                print(gameResult)
                # raise Exception("The result of the game was weird, check for missing data.")
        except IndexError: # reached end of table
            return
        except KeyError: # value wasn't a throw (Unknown, w/l, etc)
            print(f"{throw} isn't a valid play.")


m: Matrix = Matrix(xls)


def filterAffectedThrows(throw: str) -> None:
    try:
        # increment per play count
        globals()[f'{throw.lower()}Count'] += 1

        gameResult: str = Match[y + 1][x]
        nextThrow: str = Match[y + 2][x]

        # test effects of win
        global affectedThrows
        validResults: list[str] = ['Win', 'Lose', 'Draw']
        if gameResult in validResults:
            nextMatchUpWithCurrent: str = matchUps[throw][nextThrow]
            if gameResult in affectedThrows.keys() and nextMatchUpWithCurrent in affectedThrows[gameResult].keys():
                affectedThrows[gameResult][nextMatchUpWithCurrent] += 1
                print('entered try statement')
            else:
                affectedThrows[gameResult][nextMatchUpWithCurrent] = 1
                print('handled error')
        # elif gameResult == 'Lose':
        #     pass
        # elif gameResult == 'Draw':
        #     pass
        else:
            print(gameResult)
            # raise Exception("The result of the game was weird, check for missing data.")
    except IndexError: # reached end of table
        return
    except KeyError: # value wasn't a throw (Unknown, w/l, etc)
        print(f"{throw} isn't a valid play.")



m: Matrix = Matrix(xls)
# print(m[1, 1])
# print(m.matrix)
rpsGames = [
    list(group) for key, group in itertools.groupby(enumerate(m.matrix[0]), lambda z: z == '') if not key
]
del rpsGames[0][0] # name label which was left in there
# print(rpsGames)

prevPlayer: str = ''
prevIndex: int = -99999
rpsGamesDict: dict[str, list[tuple[str, ...]]] = {}
for index, player in enumerate(m.matrix[0]):
    if player == '':
        continue
    if prevPlayer == '':
        prevPlayer: str = player
        prevIndex = index
    else:
        throws: list[tuple[str, ...]] = []
        yLevelCount: int = 1
        p1Index: int = prevIndex
        p2Index: int = index
        errorOccurred: bool = False
        print(f'{prevPlayer} v. {player}')
        gamePair: tuple[str, ...] = ()
        while True:
            try: 
                # print(yLevelCount)
                
                gamePair = (m[p1Index, yLevelCount], m[p2Index, yLevelCount])
                if gamePair[0].isnumeric(): # parsed to end of column, at scores
                    # print(f'(numeric) {prevPlayer} v. {player}: {gamePair}')
                    errorOccurred = True
                elif gamePair[0] == '':
                    # print('e')
                    # print(f'{prevPlayer} v. {player}: {gamePair}')
                    errorOccurred = True
                else: 
                    # print(f'Appending: {gamePair}')
                    throws.append(gamePair)
                    yLevelCount += 1
            except IndexError:
                errorOccurred = True
                # print(p2Index, len(m.matrix[0]))
                # print(p2Index < len(m.matrix[0]))
                # print(m[p2Index + 1, 1] + " : " + str(m[p2Index + 1, 1].isalpha()))
                # print(str(m[p2Index + 1, 0] == '') + " : " + m[p2Index + 1, 0])
                # print(m[p2Index + 1, 1])
            if errorOccurred:
                # print('an error occurred!')
                errorOccurred = False
                if p2Index < len(m.matrix[0]) - 1 and m[p2Index + 1, 1].isalpha() and m[p2Index + 1, 0] == '':
                    p1Index += 2
                    p2Index += 2
                    yLevelCount = 1
                    # print(f'continued: {p1Index}, {p2Index}')
                    print(f'Continuing: {gamePair}')
                    continue
                # print(f'{gamePair} {p2Index}')
                print(f'Discarding: {gamePair}')
                break
        key: str = f'{prevPlayer} v. {player}'
        while key in rpsGamesDict.keys():
            key += ' cont.'
        rpsGamesDict[key] = throws
        # rpsGamesDict[f'{prevPlayer} v. {player}'] = throws
        prevPlayer = ''

print(f'Dictionary of Matches: {rpsGamesDict}')

rockCount = 0
winStayRockCount: int = 0
winStayPaperCount: int = 0
winStayScissorsCount: int = 0
loseShiftRockCount: int = 0
loseShiftPaperCount: int = 0
loseShiftScissorsCount: int = 0
totalAffectedThrows: int = 0
affectedThrows: dict[str, dict[str, int]] = {
    'Win': {},
    'Lose': {},
    'Draw': {}
}
paperCount = 0
scissorsCount = 0
rockCountByRow = {}
rockNextThrow = {}
paperNextThrow = {}
scissorsNextThrow = {}
# [['Duane', 'Greg', '', '', '', 'Rob "Grappler" Gorey', 'Kristina "Red Rock"'],
#             ['Rock', 'Scissors', 'Scissors', 'Rock', '', 'Paper', 'Paper'],
#             ['Win', 'Lose', 'Lose', 'Win', '', 'Draw', 'Draw'],
#             ['Paper', 'Rock', 'Paper', 'Scissors', '', 'Rock', 'Scissors'],
#             ['Win', 'Lose', 'Lose', 'Win', '', 'Win', 'Lose']]
for key, Match in rpsGamesDict.items():
    for y, game in enumerate(Match):
        for x, throw in enumerate(game):
            print(key)
            print(Match)
            filterAffectedThrows(throw)
            # outcome: str = m[x, y + 1]
            
            # if Matchps == m[x, y + 2]
                # match throw:
                #     case 'Rock':
                #         # print(self.matrix[y + 1][x])
                #         rockCount += 1
                #         columnNum: int = y + 1
                #         if columnNum in rockCountByRow.keys():
                #             rockCountByRow[columnNum] += 1
                #         else:
                #             rockCountByRow[columnNum] = 1
                #         try:
                #             if Match[y + 1][x] == 'Win' and Match[y + 2][x] == 'Rock':
                #                 print('win-stay w Rock')
                #                 winStayRockCount += 1
                #             if Match[y + 1][x] == 'Lose' and Match[y + 2][x] == 'Paper':
                #                 print('lose-shift w Rock')
                #                 loseShiftRockCount += 1
                #             totalAffectedThrows += 1
                #         except IndexError:
                #             pass
                #     case 'Paper':
                #         paperCount += 1
                #         # try:
                #         #     if [x, y + 1] == 'Win' and [x, y + 2] == 'Paper':
                #         #         print('win-stay w Paper')
                #         # except IndexError:
                #         #     print("indexerror")
                #         try:
                #             if Match[y + 1][x] == 'Win' and Match[y + 2][x] == 'Paper':
                #                 print('win-stay w Paper')
                #                 winStayPaperCount += 1
                #             if Match[y + 1][x] == 'Lose' and Match[y + 2][x] == 'Scissors':
                #                 print('lose-shift w Paper')
                #                 loseShiftPaperCount += 1
                #             totalAffectedThrows += 1
                #         except IndexError:
                #             pass
                #     case 'Scissors':
                #         scissorsCount += 1
                #         # if [x, y + 1] == 'Win' and [x, y + 2] == 'Scissors':
                #         #     print('win-stay w Scissors')
                #         try:
                #             if Match[y + 1][x] == 'Win' and Match[y + 2][x] == 'Scissors':
                #                 print('win-stay w Scissors')
                #                 winStayScissorsCount += 1
                #             if Match[y + 1][x] == 'Lose' and Match[y + 2][x] == 'Rock':
                #                 print('lose-shift w Scissors')
                #                 loseShiftScissorsCount += 1
                #             totalAffectedThrows += 1
                #         except IndexError:
                #             pass
totalThrowCount: int = rockCount + paperCount + scissorsCount
totalWinStayCount: int = winStayRockCount + winStayPaperCount + winStayScissorsCount
totalLoseShiftCount: int = loseShiftRockCount + loseShiftPaperCount + loseShiftScissorsCount
print(sorted(rockCountByRow.items()))
print(sum(rockCountByRow.values()))
print(
f'''Rock: {rockCount} ({rockCount / totalThrowCount * 100}%)
Paper: {paperCount} ({paperCount / totalThrowCount * 100}%)
Scissors: {scissorsCount} ({scissorsCount / totalThrowCount * 100}%)
Total Throws: {totalThrowCount}
Win-Stay's with Rock: {winStayRockCount}
Win-Stay's with Paper: {winStayPaperCount}
Win-Stay's with Scissors: {winStayScissorsCount}
Total Win-Stay's: {totalWinStayCount}
Lose-Shift's with Rock: {loseShiftRockCount}
Lose-Shift's with Paper: {loseShiftPaperCount}
Lose-Shift's with Scissors: {loseShiftScissorsCount}
Total Lose-Shift's: {totalLoseShiftCount}
Total affected throws: {totalAffectedThrows}'''
)
print(affectedThrows)
# print(sorted(m.rockCountByRow.items()))
# print(sum(m.rockCountByRow.values()))
"""[
('Paper', 'Paper'), 
('Draw', 'Draw'), 
('Scissors', 'Scissors'), 
('Draw', 'Draw'), 
('Paper', 'Scissors'), 
('Lose', 'Win'), 
('Paper', 'Rock'), 
('Win', 'Lose'), 
('Rock', 'Scissors'), 
('Win', 'Lose')]
"""
# print(
# f"""Rock: {m.rockCount} ({m.rockCount / m.totalThrowCount})
# Paper: {m.paperCount} ({m.rockCount / m.totalThrowCount})
# Scissors: {m.scissorsCount} ({m.rockCount / m.totalThrowCount})
# Total Throws: {m.totalThrowCount}"""
# )
# print(
# f"""Rock: {rockCount}
# Paper: {paperCount}
# Scissors: {scissorsCount}"""
# )
# arr: Sequence[str] = xls.split("\n")
# matrix = [] # : Sequence[Sequence[str]] 
# row: Sequence[str] = []
# for line in arr:
#     row = line.split("\t")
#     matrix.append(row)
#     # print(f'{len(row)}{row}')
# # for idx, item in enumerate(arr):
# #     if item == "":
# #         arr[idx] = None
# # print(matrix)
# np.set_printoptions(threshold=np.inf, linewidth=9999)
# print(np.matrix(matrix))
# rockCount: int = 0
# paperCount: int = 0
# scissorsCount: int = 0

# for y, row in enumerate(matrix):
#     for x, item in enumerate(row):
#         match item:
#             case 'Rock':
#                 print(matrix[y + 1][x])
#                 if matrix[y + 1][x] == '0':
#                     print(f'{x}, {y}')
#                 rockCount += 1
#             case 'Paper':
#                 paperCount += 1
#             case 'Scissors':
#                 scissorsCount += 1

# print(
# f"""Rock: {rockCount}
# Paper: {paperCount}
# Scissors: {scissorsCount}"""
# )
# Total Throws: 274
# Win-Stay's with Rock: 3
# Win-Stay's with Paper: 6
# Win-Stay's with Scissors: 5
# Total Win-Stay's: 14
# Lose-Shift's with Rock: 9
# Lose-Shift's with Paper: 5
# Lose-Shift's with Scissors: 14
# Total Lose-Shift's: 28
# Total affected throws: 226

# Rock: 94 (34.306569343065696%)
# Paper: 88 (32.11678832116788%)
# Scissors: 92 (33.57664233576642%)
# Total Throws: 274
# Win-Stay's with Rock: 3
# Win-Stay's with Paper: 6
# Win-Stay's with Scissors: 6
# Total Win-Stay's: 15
# Lose-Shift's with Rock: 9
# Lose-Shift's with Paper: 5
# Lose-Shift's with Scissors: 14
# Total Lose-Shift's: 28 
# ! lose lose doesn't seem to match with current data
# Total affected throws: 226

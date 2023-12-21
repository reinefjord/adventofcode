import std/[math, sequtils, strutils, sugar]

type
  Card = object
    winning, having: seq[int]

proc toCard(line: string): Card =
  let sp = line.split(':')[1].strip().split('|')
  result.winning = sp[0].strip().splitWhitespace.map(parseInt)
  result.having = sp[1].strip().splitWhitespace.map(parseInt)

func winningNumbers(card: Card): seq[int] =
  card.having.filterIt(it in card.winning)

func points(winning: seq[int]): int =
  if winning.len > 0:
    2 ^ (winning.len - 1)
  else:
    0

proc count(winning, cards: seq[int]): int =
  # [4, 2, 2, 1,  0, 0]
  # [1, 2, 4, 8, 14, 1]
  result = 1
  for _ in 1..winning[0]:
    result += cards.count(winning[1..winning[0]])

proc p1(input: string) =
  echo input.splitLines().map(toCard).map(winningNumbers).map(points).sum()

proc p2(input: string) =
  let wins = input.splitLines().map(toCard).map(winningNumbers).mapIt(it.len)
  var cards = collect:
    for i in 0..wins.high:
      1
  for i, v in wins:
    for j in 0..<cards[i]:
      for k in 0..<v:
        cards[i+k+1] += 1
  echo cards.sum()

when isMainModule:
  let input = stdin.readAll().strip()
  p1(input)
  p2(input)

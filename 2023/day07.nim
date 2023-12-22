import std/[algorithm, enumerate, sequtils, sets, strutils, tables]

type
  HandType = enum
    highCard, onePair, twoPair, threeOfAKind,
    fullHouse, fourOfAKind, fiveOfAKind
  Hand = tuple[cards: string, typ: HandType, bid: int]

const
  handValues = {
    (5, 0): fiveOfAKind,
    (4, 1): fourOfAKind,
    (3, 2): fullHouse,
    (3, 1): threeOfAKind,
    (2, 2): twoPair,
    (2, 1): onePair,
    (1, 1): highCard,
    (1, 0): highCard
  }.toTable

var cardOrder: string

proc cmp(x, y: Hand): int =
  if x.typ != y.typ:
    return ord(x.typ) - ord(y.typ)
  for (xc, yc) in zip(x.cards, y.cards):
    if xc != yc:
      return cardOrder.find(xc) - cardOrder.find(yc)
  return 0

func count(cards: string): seq[int] =
  let cardTypes = cards.toHashSet()
  result.add(0)
  for t in cardTypes:
    result.add(cards.count(t))
  result.sort(SortOrder.Descending)

func handType(cards: string): HandType =
  let counts = cards.count()
  result = handValues[(counts[0], counts[1])]

func handTypeP2(cards: string): HandType =
  let 
    counts = cards.replace("J", "").count()
    jokers = cards.count('J')
  if counts.len > 1:
    result = handValues[(counts[0] + jokers, counts[1])]
  else:
    result = handValues[(counts[0] + jokers, 0)]

proc hand(line: string, handType: proc(c: string): HandType): Hand =
  let
    sp = line.split(' ')  
    (cards, bid) = (sp[0], sp[1].parseInt)
    typ = cards.handType()
  result = (cards, typ, bid)

proc winnings(hands: seq[Hand]): int =
  for (rank, hand) in enumerate(1, hands):
    result += hand.bid * rank

proc parse(input: string): seq[Hand] =
  input.splitLines().mapIt(hand(it, handType))

proc parseP2(input: string): seq[Hand] =
  input.splitLines().mapIt(hand(it, handTypeP2))

proc p1(input: string) =
  cardOrder = "23456789TJQKA"
  echo input.parse().sorted(cmp).winnings()

proc p2(input: string) =
  cardOrder = "J123456789TQKA"
  echo input.parseP2().sorted(cmp).winnings()

when isMainModule:
  let input = stdin.readAll().strip()
  p1(input)
  p2(input)

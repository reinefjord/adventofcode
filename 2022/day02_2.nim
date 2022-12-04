import std/[strutils, sugar, tables]

type
  Shape = ref object
    loses: Shape
    beats: Shape
    score: int
  Strat = enum Lose, Draw, Win

let rock = Shape(score: 1)
let paper = Shape(beats: rock, score: 2)
rock.loses = paper
let scissors = Shape(loses: rock, beats: paper, score: 3)
rock.beats = scissors
paper.loses = scissors

let charToMove =
  { "A": rock
  , "B": paper
  , "C": scissors
  }.toTable

let charToStrat =
  { "X": Lose
  , "Y": Draw
  , "Z": Win
  }.toTable

let input = readAll(stdin).strip().split('\n')
let rounds = collect:
  for game in input:
    let s = game.split(' ')
    (charToMove[s[0]], charToStrat[s[1]])

var score = 0
for (opponent, strat) in rounds:
  case strat
  of Lose:
    score += opponent.beats.score
  of Draw:
    score += opponent.score
    score += 3
  of Win:
    score += opponent.loses.score
    score += 6

echo score

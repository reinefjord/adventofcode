import std/[strutils, sugar, tables]

type
  Shape = ref object
    loses: Shape
    beats: Shape
    score: int

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
  , "X": rock
  , "Y": paper
  , "Z": scissors
  }.toTable

let input = readAll(stdin).strip().split('\n')
let rounds = collect:
  for game in input:
    let s = game.split(' ')
    (charToMove[s[0]], charToMove[s[1]])

var score = 0
for (opponent, me) in rounds:
  score += me.score
  if me.beats == opponent:
    score += 6
  elif me == opponent:
    score += 3

echo score

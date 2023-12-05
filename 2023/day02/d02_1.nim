import std/[math, sequtils, strutils, sugar]

type
  Rules = object
    red: int
    green: int
    blue: int

  CubeSet* = object
    red*: int
    green*: int
    blue*: int

  Game* = object
    id*: int
    sets*: seq[CubeSet]

const rules = Rules(red: 12, green: 13, blue: 14)

func isPossible(rules: Rules, cubes: CubeSet): bool =
  if cubes.red > rules.red:
    return false
  if cubes.green > rules.green:
    return false
  if cubes.blue > rules.blue:
    return false
  return true

func parseGame*(game: string): Game =
  let
    sp = game.split({':', ';'})
    sets = sp[1..^1]

  result.id = sp[0].split(' ')[1].parseInt()

  for set in sets:
    var cubes = CubeSet()
    for reveal in set.split(','):
      let
        sp = reveal.strip().split(' ')
      let
        amount = sp[0].strip().parseInt()
        colour = sp[1]
      case colour
      of "red":
        cubes.red = amount
      of "green":
        cubes.green = amount
      of "blue":
        cubes.blue = amount
    result.sets.add(cubes)

when isMainModule:
  let
    input = stdin.readAll().strip().splitLines()
    games = input.map(parseGame)
    possibleIds =
      collect:
        for game in games:
          block gameBlock:
            for set in game.sets:
              if not rules.isPossible(set):
                break gameBlock
            game.id
  echo possibleIds.sum()

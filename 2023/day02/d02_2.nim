import std/[math, sequtils, strutils, sugar]
import d02_1

func fewestCubes(sets: seq[CubeSet]): CubeSet =
  for cubes in sets:
    if cubes.red > result.red:
      result.red = cubes.red
    if cubes.green > result.green:
      result.green = cubes.green
    if cubes.blue > result.blue:
      result.blue = cubes.blue

when isMainModule:
  let
    input = stdin.readAll().strip().splitLines()
    games = input.map(parseGame).mapIt(it.sets)
    fewest = games.map(fewestCubes)
  echo fewest.mapIt(it.red * it.green * it.blue).sum()

import std/[sequtils, strutils, sugar, threadpool]

type
  CatMap = seq[tuple[srcStart, dstStart, range: int]]

func get(catMap: CatMap, thing: int): int =
  for m in catMap:
    let
      low = m.srcStart
      high = m.srcStart + m.range - 1
    if low <= thing and thing <= high:
      return m.dstStart + (thing - m.srcStart)
  return thing

func location(catMaps: seq[CatMap], thing: int): int =
  result = thing
  for catMap in catMaps:
    result = catMap.get(result)

func catMaps(lines: seq[string]): CatMap =
  for line in lines[1..^1]:
    let
      sp = line.split(' ')
      ints = sp.map(parseInt)
      md = (srcStart: ints[1], dstStart: ints[0], range: ints[2])
    result.add(md)

func parseSeeds(s: string): seq[int] = s.split(' ')[1..^1].map(parseInt)

proc p1(input: string) =
  let
    parts = input.strip().split("\n\n")
    seeds = parts[0].parseSeeds()
    maps = parts[1..^1].mapIt(splitLines(it)).map(catMaps)
  echo seeds.mapIt(location(maps, it)).min()

func seedRanges(ranges: seq[int]): seq[(int, int)] =
  for i in countup(0, ranges.high, 2):
    let
      start = ranges[i]
      stop = start + ranges[i+1] - 1
    result.add (start, stop)

func lowest(maps: seq[CatMap], start, stop: int): int =
  result = high(int)
  for seed in start..stop:
    let loc = maps.location(seed)
    if loc < result:
      result = loc
  
proc p2(input: string) =
  let 
    parts = input.strip().split("\n\n")
    ranges = parts[0].parseSeeds()
    maps = parts[1..^1].mapIt(splitLines(it)).map(catMaps)

  let responses: seq[FlowVar[int]] = collect:
    for (start, stop) in seedRanges(ranges):
      spawn lowest(maps, start, stop)
  sync()

  let locations = collect:
    for r in responses:
      ^r
  echo min(locations)

when isMainModule:
  let input = stdin.readAll()
  p1(input)
  p2(input)  # takes a minute or two.

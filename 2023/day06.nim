import std/[sequtils, strutils, sugar]

func distance(raceTime: int, chargeTime: int): int =
  (raceTime - chargeTime) * chargeTime

func possible(raceTime: int): seq[int] =
  collect:
    for chargeTime in 0..raceTime:
      distance(raceTime, chargeTime)

func wins(raceTime: int, record: int): int =
  possible(raceTime).countIt(it > record)

func parse(s: string): seq[int] =
  s.splitWhitespace()[1..^1].map(parseInt)

func parse(input: seq[string]): seq[(int, int)] =
  zip(input[0].parse(), input[1].parse())

proc p1(input: string) =
  echo input.splitLines().parse().mapIt(wins(it[0], it[1])).foldl(a * b)

func parse2(input: string): int =
  input.splitWhitespace()[1..^1].join().parseInt()

func parse2(input: seq[string]): (int, int) =
  (input[0].parse2(), input[1].parse2())

proc p2(input: string) =
  let (t, d) = input.splitLines().parse2()
  echo wins(t, d)

when isMainModule:
  let input = stdin.readAll()
  p1(input)
  p2(input)

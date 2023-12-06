import std/[math, sequtils, strutils]

func calcDigitLookup(): seq[(string, string)] =
  let digits = {
    "one": "1",
    "two": "2",
    "three": "3",
    "four": "4",
    "five": "5",
    "six": "6",
    "seven": "7",
    "eight": "8",
    "nine": "9"
  }
  for (k1, v1) in digits:
    for (k2, v2) in digits:
      if k1[^1] == k2[0]:
        result.add((k1[0..^2] & k2, v1 & v2))
  result & @digits

const digits = calcDigitLookup()

proc calibrationValue(line: string): int =
  var digits: seq[char]
  for ch in line:
    if ch.isDigit():
      digits.add(ch)
  result = parseInt(digits[0] & digits[^1])

proc p1(input: string) =
  let lines = input.strip().splitLines()
  echo lines.map(calibrationValue).sum()

proc p2(input: string) =
  let
    input = input.strip()
    realInput = input.multiReplace(digits)
    lines = realInput.splitLines()
  echo lines.map(calibrationValue).sum()

when isMainModule:
  let input = stdin.readAll()
  p1(input)
  p2(input)

import std/[math, sequtils, strutils]

proc calibrationValue*(line: string): int =
  var digits: seq[char]
  for ch in line:
    if ch.isDigit():
      digits.add(ch)
  result = parseInt(digits[0] & digits[^1])

when isMainModule:
  var input = stdin.readAll().strip().splitLines()
  echo input.map(calibrationValue).sum()

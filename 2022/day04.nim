import std/[os, setutils, strutils]

proc boundToSet(bound: string): set[uint8] =
  let lowHigh = bound.split('-')
  let low = parseInt(lowHigh[0]).uint8
  let high = parseInt(lowHigh[1]).uint8
  toSet(low..high)

proc eitherContains(a, b: set[uint8]): bool =
  a <= b or b < a

proc intersects(a, b: set[uint8]): bool =
  a * b != {}

let compare =
  case paramStr(1):
  of "1":
    eitherContains
  of "2":
    intersects
  else:
    eitherContains

var number = 0
for pair in lines(stdin):
  let elves = pair.split(',')
  let s1 = boundToSet(elves[0])
  let s2 = boundToSet(elves[1])
  if compare(s1, s2):
    number.inc

echo number

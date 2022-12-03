import std/[os, math, sequtils, setutils, strutils, sugar, tables]

const letters = toSeq('a'..'z').concat(toSeq('A'..'Z'))
const priorities = zip(letters, toSeq(1..52)).toTable

proc commonType(sacks: varargs[string]): char =
  let sets = sacks.map(x => x.toSet)
  let intersection = sets.foldl(a * b)
  intersection.toSeq[0]

proc compartments(sack: string): seq[string] =
  let
    sackMid = sack.len div 2
    comp1 = sack[0..<sackMid]
    comp2 = sack[sackMid..^1]
  @[comp1, comp2]

let sacks = stdin.readAll().strip().splitLines()

var groups: seq[seq[string]]
if paramStr(1) == "1":
  groups = sacks.map(compartments)
elif paramStr(1) == "2":
  groups = sacks.distribute(sacks.len div 3)

let types = groups.mapIt(it.commonType)
let prios = types.mapIt(priorities[it])
echo sum(prios)

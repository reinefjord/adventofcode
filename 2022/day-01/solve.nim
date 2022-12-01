import std/[algorithm, math, os, strutils, sugar]

let lst = stdin.readAll().strip()
let elves = lst.split("\n\n")

var totals = collect:
  for elf in elves:
    let elfInts = collect:
      for cal in elf.split("\n"):
        parseInt(cal)
    sum(elfInts)

totals.sort(order = Descending)

if paramStr(1) == "1":
  echo totals[0]
elif paramStr(1) == "2":
  echo sum(totals[0..2])

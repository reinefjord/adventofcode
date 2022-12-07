import std/[algorithm, sequtils, strutils, tables]

var pwd: seq[string]
var sizes: Table[string, int]

for line in lines(stdin):
  if line[0] == '$':
    let cmd = line[2..^1]
    if cmd.startswith("cd"):
      if cmd[3..^1] == "..":
        discard pwd.pop()
      else:
        pwd.add(cmd[3..^1])
    continue
  if line.startswith("dir"):
    continue
  let size = line.split(' ')[0].parseInt()
  for i in countdown(pwd.high, 0):
    let path = pwd[0..i].join("/")
    if path in sizes:
      sizes[path] += size
    else:
      sizes[path] = size

var part1 = 0
for path, size in sizes.pairs():
  if size <= 100_000:
    part1 += size
echo part1

let usedSpace = sizes["/"]
let toFree = 30_000_000 - (70_000_000 - usedSpace)
for size in sizes.values().toSeq().sorted():
  if size >= toFree:
    echo size
    break

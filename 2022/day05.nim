import std/[algorithm, os, sequtils, strutils]

let
  input = stdin.readAll().strip().split("\n\n")
  stackLevels = input[0].splitLines().reversed()
  steps = input[1]
  stackIndices = stackLevels[0].splitWhitespace()
  stackSize = stackIndices[^1].parseInt()

var stacks = newSeq[seq[char]](stackSize)

for stackLevel in stackLevels[1..^1]:
  for i in 0 ..< stackSize:
    let charIdx = i * 4 + 1
    let crateId = stackLevel[charIdx]
    if crateId != ' ':
      stacks[i].add(crateId)

proc crateMover9000(fromStack, toStack: var seq[char]; number: int) =
  for i in 0 ..< number:
    let crate = fromStack.pop()
    toStack.add(crate)

proc crateMover9001(fromStack, toStack: var seq[char]; number: int) =
  for crate in fromStack[^number..^1]:
    toStack.add(crate)
  fromStack.delete(fromStack.len - number .. fromStack.high)

let move =
  if paramCount() > 0 and paramStr(1) == "2":
    crateMover9001
  else:
    crateMover9000

for step in steps.splitLines():
  let
    tokens = step.splitWhitespace()
    moves = tokens[1].parseInt()
    fromStackIdx = tokens[3].parseInt() - 1
    toStackIdx = tokens[5].parseInt() - 1
  stacks[fromStackIdx].move(stacks[toStackIdx], moves)

for stack in stacks:
  stdout.write(stack[^1])
echo()

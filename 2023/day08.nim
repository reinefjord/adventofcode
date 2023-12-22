import std/[sequtils, strscans, strutils, sugar, tables]

type
  Map = tuple
    instructions: string
    nodes: Table[string, tuple[l: string, r: string]]

func walk(map: Map, startingNodes: seq[string]): int =
  let il = map.instructions.len
  var
    p = 0
    nodes = startingNodes
  while true:
    let i = map.instructions[p mod il]
    nodes = block:
      var newNodes: seq[string]
      if i == 'L':
        for node in nodes:
          newNodes.add(map.nodes[node].l)
      else:
        for node in nodes:
          newNodes.add(map.nodes[node].r)
      newNodes
    p += 1
    if nodes.allIt(it[^1] == 'Z'):
      return p
    if p mod 1_000_000 == 0:
      debugEcho p

func parse(input: string): Map =
  let
    sp = input.split("\n\n")
    nodeLines = sp[1].splitLines
  result.instructions = sp[0]

  var n, l, r: string
  for line in nodeLines:
    discard scanf(line, "$* = ($*, $*)", n, l, r)
    result.nodes[n] = (l, r)

proc p1(input: string) =
  let startingNodes = @["AAA"]
  echo input.parse().walk(startingNodes)

proc p2(input: string) =
  let
    map = input.parse()
  let
    startingNodes = collect:
      for k in map.nodes.keys:
        if k[^1] == 'A':
          k
  echo startingNodes
  echo map.walk(startingNodes)

when isMainModule:
  let input = stdin.readAll().strip()
  p1(input)
  #p2(input)  # takes too much time

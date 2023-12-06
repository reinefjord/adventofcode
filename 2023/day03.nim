import std/[math, strutils]

type
  Number = object
    x1, x2, y: int
    value: int

  Symbol = object
    x, y: int
    symbol: char

  Schematic = object
    numbers: seq[Number]
    symbols: seq[Symbol]

func parse(input: string): Schematic =
  let lines = input.splitLines()
  for y, line in lines:
    var nums: string
    for x, ch in line:
      if ch.isDigit():
        nums = nums & ch
        if nums.len > 0:
          if x+1 == line.len or not line[x+1].isDigit():
            let number = Number(x1: x-nums.len+1, x2: x, y: y,
                                value: nums.parseInt())
            result.numbers.add(number)
            nums = ""
        continue
      if ch != '.':
        let symbol = Symbol(x: x, y: y, symbol: ch)
        result.symbols.add(symbol)

func isAdjacent(n: Number, s: Symbol): bool =
  (n.y - 1 <= s.y and s.y <= n.y + 1 and
   n.x1 - 1 <= s.x and s.x <= n.x2 + 1)

func partNumbers(schematic: Schematic): seq[int] =
  for number in schematic.numbers:
    for symbol in schematic.symbols:
      if number.isAdjacent(symbol):
        result.add(number.value)

func gearRatios(schematic: Schematic): seq[int] =
  for symbol in schematic.symbols:
    if symbol.symbol != '*':
      continue
    block findNumbers:
      var partNumbers: seq[int]
      for number in schematic.numbers:
        if number.isAdjacent(symbol):
          partNumbers.add(number.value)
          if partNumbers.len > 2:
            break findNumbers
      if partNumbers.len == 2:
        result.add(partNumbers[0] * partNumbers[1])

proc p1(input: string) =
  echo parse(input).partNumbers().sum()

proc p2(input: string) =
  echo parse(input).gearRatios().sum()

when isMainModule:
  let input = stdin.readAll()
  p1(input)
  p2(input)

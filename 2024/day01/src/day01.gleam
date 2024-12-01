import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import gleam/yielder
import stdin.{stdin}

pub fn main() {
  let assert #(pairs, []) =
    stdin()
    |> yielder.map(fn(l) {
      string.trim_end(l)
      |> string.split_once("   ")
      |> result.map(fn(p) {
        p |> pair.map_first(int.parse) |> pair.map_second(int.parse)
      })
    })
    |> yielder.to_list
    |> result.partition
  let #(a, b) = list.unzip(pairs)
  let assert #(a, []) = result.partition(a)
  let assert #(b, []) = result.partition(b)

  part1(a, b)
  |> int.to_string
  |> io.println

  part2(a, b)
  |> int.to_string
  |> io.println
}

fn part1(a: List(Int), b: List(Int)) -> Int {
  list.zip(list.sort(a, int.compare), list.sort(b, int.compare))
  |> list.map(fn(p) { p.0 - p.1 |> int.absolute_value })
  |> int.sum
}

fn part2(a: List(Int), b: List(Int)) -> Int {
  let count =
    list.unique(b)
    |> list.fold(dict.new(), fn(d, i) {
      dict.insert(d, i, list.count(b, fn(x) { x == i }))
    })
  list.fold(a, 0, fn(s, x) {
    s + x * { dict.get(count, x) |> result.unwrap(0) }
  })
}

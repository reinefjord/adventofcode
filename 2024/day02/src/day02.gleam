import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/yielder
import stdin.{stdin}

pub fn main() {
  let reports =
    stdin()
    |> yielder.map(fn(line) {
      let assert #(ints, []) =
        string.trim_end(line)
        |> string.split(" ")
        |> list.map(int.parse)
        |> result.partition
      ints
    })
    |> yielder.to_list

  part1(reports)
  |> int.to_string
  |> io.println

  part2(reports)
  |> int.to_string
  |> io.println
}

fn part1(reports: List(List(Int))) -> Int {
  list.map(reports, is_safe)
  |> list.count(fn(x) { x })
}

fn part2(reports: List(List(Int))) {
  let #(safe, unsafe) = list.partition(reports, is_safe)
  let non_unsafe =
    list.map(unsafe, fn(report) {
      list.combinations(report, list.length(report) - 1)
      |> until_true(is_safe)
    })
  list.length(safe) + list.count(non_unsafe, fn(x) { x })
}

fn until_true(over list: List(a), with fun: fn(a) -> Bool) -> Bool {
  case list {
    [] -> False
    [head] -> fun(head)
    [head, ..tail] ->
      case fun(head) {
        True -> True
        False -> until_true(tail, fun)
      }
  }
}

fn is_safe(report: List(Int)) -> Bool {
  list.window_by_2(report)
  |> list.try_fold(0, fn(sum, window) {
    let diff = window.1 - window.0
    case int.absolute_value(diff) {
      x if x >= 1 && x <= 3 ->
        case bool.exclusive_nor(sum > 0, diff > 0) {
          True -> Ok(sum + diff)
          False if sum == 0 -> Ok(sum + diff)
          False -> Error(Nil)
        }
      _ -> Error(Nil)
    }
  })
  |> result.is_ok
}

import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/regexp
import gleam/string
import gleam/yielder
import stdin.{stdin}

pub fn main() {
  let memory =
    stdin()
    |> yielder.to_list
    |> string.concat

  part1(memory) |> int.to_string |> io.println
  part2(memory) |> int.to_string |> io.println
}

fn part1(memory: String) -> Int {
  let assert Ok(re) =
    regexp.compile(
      "mul\\((\\d{1,3}),(\\d{1,3})\\)",
      regexp.Options(case_insensitive: False, multi_line: True),
    )
  regexp.scan(re, memory)
  |> list.map(fn(m) {
    list.map(m.submatches, fn(s) {
      case s {
        Some(n) -> int.parse(n)
        None -> Error(Nil)
      }
    })
  })
  |> list.map(fn(x) {
    let assert [Ok(a), Ok(b)] = x
    a * b
  })
  |> int.sum
}

fn part2(memory: String) {
  let assert Ok(re) =
    regexp.compile(
      "do\\(\\)|don't\\(\\)|mul\\((\\d{1,3}),(\\d{1,3})\\)",
      regexp.Options(case_insensitive: False, multi_line: True),
    )
  regexp.scan(re, memory)
  |> do(True)
  |> list.map(fn(x) {
    let assert Ok(a) = int.parse(x.0)
    let assert Ok(b) = int.parse(x.1)
    a * b
  })
  |> int.sum
}

fn do(matches: List(regexp.Match), enabled: Bool) -> List(#(String, String)) {
  case matches {
    [match, ..rest] ->
      case match.content {
        "do()" -> do(rest, True)
        "don't()" -> do(rest, False)
        _ ->
          case enabled {
            True ->
              case match.submatches {
                [Some(a), Some(b)] ->
                  list.flatten([[#(a, b)], do(rest, enabled)])
                _ -> panic as "Invalid submatches!"
              }
            False -> do(rest, enabled)
          }
      }
    [] -> []
  }
}

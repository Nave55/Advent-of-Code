import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub fn main() {
  let pt1 = solution("input/day12.txt")
  io.println("Part 1: " <> pt1)
}

fn solution(path: String) -> String {
  let assert Ok(con) = simplifile.read(path)

  let parse_left = fn(left: String) -> Int {
    case string.split(left, "x") |> list.filter_map(int.parse) {
      [first, second] -> first * second
      _ -> 0
    }
  }

  let parse_right = fn(right: String) -> Int {
    string.split(right, " ")
    |> list.filter_map(int.parse)
    |> list.fold(0, int.add)
  }

  con
  |> string.trim_end
  |> string.split("\r\n\r\n")
  |> list.filter(fn(x) { string.contains(x, "x") })
  |> list.flat_map(fn(x) {
    x
    |> string.split("\r\n")
    |> list.filter_map(fn(y) {
      let assert Ok(#(left, right)) = string.split_once(y, ": ")
      case parse_left(left) >= parse_right(right) * 9 {
        True -> Ok(1)
        False -> Error(Nil)
      }
    })
  })
  |> list.fold(0, int.add)
  |> int.to_string
}

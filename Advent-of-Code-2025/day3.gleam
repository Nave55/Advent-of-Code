import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub type LLI =
  List(List(Int))

pub fn main() {
  let con = parse_input("input/day3.txt")
  let pt1 = solver(con, 2) |> int.to_string
  let pt2 = solver(con, 12) |> int.to_string
  io.println("Part 1: " <> pt1)
  io.println("Part 2: " <> pt2)
}

fn parse_input(path: String) -> LLI {
  let assert Ok(con) = simplifile.read(path)
  con
  |> string.trim_end
  |> string.split("\r\n")
  |> list.map(fn(x) {
    let g = string.to_graphemes(x)
    use y <- list.filter_map(g)
    int.parse(y)
  })
}

fn extend(prefixes: List(Int), d: Int) -> List(Int) {
  list.fold(prefixes, #([], -1), fn(acc, prev_original) {
    let #(out, last_prev_original) = acc

    let new_val = case last_prev_original {
      -1 -> int.max(prev_original, d)
      _ -> int.max(prev_original, last_prev_original * 10 + d)
    }

    #([new_val, ..out], prev_original)
  }).0
  |> list.reverse
}

fn max_joltage(bank: List(Int), k: Int) -> Int {
  list.fold(bank, list.repeat(-1, k), fn(prefixes, d) { extend(prefixes, d) })
  |> list.last
  |> result.unwrap(0)
}

fn solver(banks: List(List(Int)), k: Int) -> Int {
  list.fold(banks, 0, fn(x, acc) { x + max_joltage(acc, k) })
}

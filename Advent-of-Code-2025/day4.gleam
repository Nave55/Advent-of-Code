import gleam/int
import gleam/io
import gleam/list
import gleam/set.{type Set}
import gleam/string
import simplifile

type TI =
  #(Int, Int)

type STI =
  Set(TI)

const directions = [
  #(-1, -1),
  #(-1, 0),
  #(-1, 1),
  #(0, -1),
  #(0, 1),
  #(1, -1),
  #(1, 0),
  #(1, 1),
]

pub fn main() {
  let grid = parse_input("input/day4.txt")
  let pos = positions(grid)
  let pt1 = solution1(pos).1 |> int.to_string
  let pt2 = solution2(pos, 0) |> int.to_string
  io.println("Part 1: " <> pt1)
  io.println("Part 2: " <> pt2)
}

fn parse_input(path: String) -> List(List(String)) {
  let assert Ok(con) = simplifile.read(path)
  con
  |> string.trim_end
  |> string.split("\n")
  |> list.map(fn(x) { string.to_graphemes(x) })
}

fn positions(grid: List(List(String))) -> STI {
  list.index_map(grid, fn(row, row_i) {
    list.index_map(row, fn(value, col_i) {
      case value {
        "@" -> Ok(#(row_i, col_i))
        _ -> Error(Nil)
      }
    })
    |> list.filter_map(fn(r) { r })
  })
  |> list.flatten
  |> set.from_list
}

fn add_tuple(a: TI, b: TI) -> TI {
  #(a.0 + b.0, a.1 + b.1)
}

fn solution1(locs: STI) -> #(STI, Int) {
  use outer_acc, outer_val <- set.fold(locs, #(set.new(), 0))
  let len =
    list.fold(directions, 0, fn(inner_acc, inner_val) {
      let tup = add_tuple(outer_val, inner_val)
      case set.contains(locs, tup) {
        True -> inner_acc + 1
        False -> inner_acc
      }
    })

  case len < 4 {
    True -> #(set.insert(outer_acc.0, outer_val), outer_acc.1 + 1)
    False -> outer_acc
  }
}

fn solution2(locs: STI, acc: Int) -> Int {
  let rolls = solution1(locs)

  case rolls.1 == 0 {
    True -> acc
    False ->
      set.difference(locs, rolls.0)
      |> solution2(acc + rolls.1)
  }
}

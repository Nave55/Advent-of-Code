import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/set.{type Set}
import gleam/string
import simplifile

type TI =
  #(Int, Int)

type Locs =
  Dict(TI, String)

pub fn main() {
  let #(start, locs) = parse_input("input/day7.txt")
  let pt1 = solution1(locs, set.from_list([start]), 0) |> int.to_string
  let pt2 = solution2(locs, start, dict.new()).0 |> int.to_string
  io.println("Part 1: " <> pt1 <> "\nPart 2: " <> pt2)
}

pub fn parse_input(path: String) -> #(TI, Locs) {
  let assert Ok(con) = simplifile.read(path)

  let pairs =
    con
    |> string.trim_end
    |> string.split("\r\n")
    |> list.index_map(fn(row, row_i) {
      row
      |> string.to_graphemes
      |> list.index_map(fn(col, col_i) { #(#(row_i, col_i), col) })
    })
    |> list.flatten

  let assert Ok(start) = list.find(pairs, fn(x) { x.1 == "S" })
  #(start.0, dict.from_list(pairs))
}

fn add_tups(a: TI, b: TI) -> TI {
  #(a.0 + b.0, a.1 + b.1)
}

fn split_tup(a: TI) -> Set(TI) {
  set.from_list([add_tups(a, #(0, -1)), add_tups(a, #(0, 1))])
}

fn step(locs: Locs, pos: TI) -> #(Set(TI), Int) {
  let down = add_tups(pos, #(1, 0))
  case dict.get(locs, down) {
    Ok(".") -> #(set.from_list([down]), 0)
    Ok("^") -> #(split_tup(down), 1)
    _ -> #(set.new(), 0)
  }
}

fn solution1(locs: Locs, active: Set(TI), split_amt: Int) -> Int {
  case set.is_empty(active) {
    True -> split_amt
    False -> {
      let #(next_active_set, next_split_amt) =
        set.fold(active, #(set.new(), 0), fn(acc, p) {
          let #(acc_set, acc_split_amt) = acc
          let #(step_set, step_split_amt) = step(locs, p)
          #(set.union(acc_set, step_set), acc_split_amt + step_split_amt)
        })

      solution1(locs, next_active_set, split_amt + next_split_amt)
    }
  }
}

fn solution2(locs: Locs, pos: TI, memo: Dict(TI, Int)) -> #(Int, Dict(TI, Int)) {
  case dict.get(memo, pos) {
    Ok(count) -> #(count, memo)
    Error(_) -> {
      let down = add_tups(pos, #(1, 0))
      let result = case dict.get(locs, down) {
        Ok(".") -> solution2(locs, down, memo)
        Ok("^") -> {
          let left = add_tups(down, #(0, -1))
          let right = add_tups(down, #(0, 1))
          let #(lc, memo1) = solution2(locs, left, memo)
          let #(rc, memo2) = solution2(locs, right, memo1)
          #(lc + rc, memo2)
        }
        _ -> #(1, memo)
      }

      let #(count, memo2) = result
      #(count, dict.insert(memo2, pos, count))
    }
  }
}

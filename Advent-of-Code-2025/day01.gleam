import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

type LTSI =
  List(#(String, Int))

const d_size = 100

const d_start = 50

pub fn main() {
  let con = parse_input("input/day1.txt")
  let pt1 = solution1(con) |> int.to_string
  let pt2 = solution2(con) |> int.to_string
  io.println("Part 1: " <> pt1)
  io.println("Part 2: " <> pt2)
}

fn parse_input(path: String) -> LTSI {
  let assert Ok(con) = simplifile.read(path)
  con
  |> string.trim_end
  |> string.split("\r\n")
  |> list.map(fn(x) {
    let assert Ok(left) = string.first(x)
    let assert Ok(right) = string.drop_start(x, 1) |> int.parse
    #(left, right)
  })
}

fn wrap_number(pos: Int, steps: Int, dir: String) -> #(Int, Int) {
  let delta = case dir {
    "R" -> 1
    _ -> -1
  }
  let crossings = { { d_size + delta * pos } % d_size + steps } / d_size
  let n_pos = { pos + delta * steps } % d_size
  #(n_pos, crossings)
}

fn solve(con: LTSI, dial: Int, acc: Int, func: fn(Int, Int, Int) -> Int) -> Int {
  case con {
    [] -> acc
    [first, ..rest] -> {
      let #(new_dial, crossings) = wrap_number(dial, first.1, first.0)
      let new_acc = func(new_dial, crossings, acc)
      solve(rest, new_dial, new_acc, func)
    }
  }
}

fn solution1(con: LTSI) -> Int {
  use new_dial, _, acc <- solve(con, d_start, 0)
  case new_dial == 0 {
    True -> acc + 1
    False -> acc
  }
}

fn solution2(con: LTSI) -> Int {
  use _, crossings, acc <- solve(con, d_start, 0)
  acc + crossings
}

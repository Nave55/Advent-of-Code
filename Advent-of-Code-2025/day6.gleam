import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

type LS =
  List(String)

type LI =
  List(Int)

type LLI =
  List(LI)

pub fn main() {
  let #(nums_pt1, nums_pt2, ops) = parse_input("input/day6.txt")
  let pt1 = solver(nums_pt1, ops) |> int.to_string
  let pt2 = solver(nums_pt2, list.reverse(ops)) |> int.to_string
  io.println("Part 1: " <> pt1)
  io.println("Part 2: " <> pt2)
}

fn tokens(line: String) -> LS {
  list.filter(string.split(line, " "), fn(s) { s != "" })
}

fn body_lines(con: LS) -> LS {
  list.take(con, list.length(con) - 1)
}

fn max_width(col: LS) -> Result(Int, Nil) {
  use r <- result.try(
    list.max(col, fn(a, b) { int.compare(string.length(a), string.length(b)) }),
  )
  Ok(string.length(r))
}

fn transpose(lists: List(List(a))) -> List(List(a)) {
  case list.any(lists, fn(xs) { xs == [] }) {
    True -> []
    False -> {
      let heads = list.filter_map(lists, list.first)
      let tails = list.map(lists, fn(xs) { list.drop(xs, 1) })
      [heads, ..transpose(tails)]
    }
  }
}

fn take_skip(lst: LS, take: LI, acc: LS) -> LS {
  case lst {
    [] -> list.reverse(acc)
    _ ->
      case take {
        [] -> acc
        [first, ..rest_of_take] -> {
          let taken = list.take(lst, first) |> string.join("")
          let rest_of_list = list.drop(lst, first + 1)
          take_skip(rest_of_list, rest_of_take, [taken, ..acc])
        }
      }
  }
}

fn parse_input(path: String) -> #(LLI, LLI, LS) {
  let con =
    simplifile.read(path)
    |> result.unwrap("")
    |> string.trim_end
    |> string.split("\r\n")

  let ops =
    list.last(con)
    |> result.unwrap("")
    |> string.replace(" ", "")
    |> string.to_graphemes

  let body = body_lines(con)

  let nums_part1 =
    list.map(body, fn(line) { tokens(line) |> list.filter_map(int.parse) })
    |> transpose

  let take =
    list.map(body, tokens)
    |> transpose
    |> list.filter_map(max_width)

  let nums_part2 =
    list.map(body, fn(line) {
      line
      |> string.replace(" ", "x")
      |> string.to_graphemes
      |> take_skip(take, [])
    })
    |> transpose
    |> list.map(fn(col) {
      col
      |> list.map(string.to_graphemes)
      |> transpose
      |> list.filter_map(fn(graphemes) {
        string.join(graphemes, "")
        |> string.replace("x", "")
        |> int.parse
      })
    })
    |> list.reverse

  #(nums_part1, nums_part2, ops)
}

fn solver(nums: LLI, ops: LS) -> Int {
  let zipped = list.zip(nums, ops)
  use outer_acc, outer_val <- list.fold(zipped, 0)
  let #(nums, op) = outer_val
  let inner = case op {
    "*" -> list.fold(nums, 1, fn(acc, n) { acc * n })
    _ -> list.fold(nums, 0, fn(acc, n) { acc + n })
  }

  outer_acc + inner
}

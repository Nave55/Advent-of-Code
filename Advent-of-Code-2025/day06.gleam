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
  let #(p1n, p2n, ops) = parse_input("input/day6.txt")
  io.println("Part 1: " <> int.to_string(solver(p1n, ops)))
  io.println("Part 2: " <> int.to_string(solver(p2n, list.reverse(ops))))
}

fn tokens(line: String) -> LS {
  string.split(line, " ") |> list.filter(fn(s) { s != "" })
}

fn max_width(col: LS) -> Result(Int, Nil) {
  use m <- result.try(
    list.max(col, fn(a, b) { int.compare(string.length(a), string.length(b)) }),
  )
  Ok(string.length(m))
}

fn take_then_skip(xs: LS, widths: LI, acc: LS) -> Result(LS, String) {
  case xs, widths {
    [], _ -> Ok(list.reverse(acc))
    _, [] -> Error("Nothing in take")
    xs, [w, ..ws] -> {
      let taken = xs |> list.take(w) |> string.join("")
      let rest = xs |> list.drop(w + 1)
      take_then_skip(rest, ws, [taken, ..acc])
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

  let body = list.take(con, list.length(con) - 1)

  let widths =
    body |> list.map(tokens) |> list.transpose |> list.filter_map(max_width)

  let nums_pt1 =
    body
    |> list.map(fn(l) { tokens(l) |> list.filter_map(int.parse) })
    |> list.transpose

  let nums_pt2 =
    body
    |> list.filter_map(fn(l) {
      l
      |> string.replace(" ", "x")
      |> string.to_graphemes
      |> take_then_skip(widths, [])
    })
    |> list.transpose
    |> list.map(fn(col) {
      col
      |> list.map(string.to_graphemes)
      |> list.transpose
      |> list.filter_map(fn(g) {
        g |> string.join("") |> string.replace("x", "") |> int.parse
      })
    })
    |> list.reverse

  #(nums_pt1, nums_pt2, ops)
}

fn solver(nums: LLI, ops: LS) -> Int {
  nums
  |> list.zip(ops)
  |> list.fold(0, fn(acc, val) {
    let #(ns, op) = val
    let inner = case op {
      "*" -> list.fold(ns, 1, fn(a, n) { a * n })
      _ -> list.fold(ns, 0, fn(a, n) { a + n })
    }
    acc + inner
  })
}

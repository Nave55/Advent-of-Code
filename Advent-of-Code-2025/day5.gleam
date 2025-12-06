import gleam/int
import gleam/io
import gleam/list
import gleam/order.{Eq, Gt, Lt}
import gleam/string
import simplifile

type LI =
  List(Int)

type TI =
  #(Int, Int)

type LTI =
  List(TI)

pub fn main() {
  let input = parse_input("input/day5.txt")
  let pt1 = solution1(input) |> int.to_string
  let pt2 = solution2(input.0) |> int.to_string
  io.println("Part 1: " <> pt1)
  io.println("Part 2: " <> pt2)
}

fn parse_range(line: String) -> Result(TI, Nil) {
  case string.split(line, "-") {
    [a, b] ->
      case int.parse(a), int.parse(b) {
        Ok(x), Ok(y) -> Ok(#(x, y))
        _, _ -> Error(Nil)
      }

    _ -> Error(Nil)
  }
}

fn sort_ranges(xs: LTI) -> LTI {
  use a, b <- list.sort(xs)
  case int.compare(a.0, b.0) {
    Eq -> int.compare(a.1, b.1)
    other -> other
  }
}

fn merge_ranges(input: LTI) -> LTI {
  list.fold(input, [], fn(acc, current) {
    case acc {
      [] -> [current]

      [last, ..rest] -> {
        let #(last_start, last_end) = last
        let #(cur_start, cur_end) = current

        case int.compare(cur_start, last_end) {
          Lt | Eq -> [#(last_start, int.max(last_end, cur_end)), ..rest]
          Gt -> [current, last, ..rest]
        }
      }
    }
  })
}

fn parse_input(path: String) -> #(LTI, LI) {
  let assert Ok(con) = simplifile.read(path)
  let assert Ok(#(first, second)) =
    con
    |> string.trim_end
    |> string.split_once("\r\n\r\n")

  let f_parse =
    first
    |> string.split("\r\n")
    |> list.filter_map(parse_range)
    |> sort_ranges
    |> merge_ranges

  let s_parse =
    second
    |> string.split("\r\n")
    |> list.filter_map(fn(x) { int.parse(x) })

  #(f_parse, s_parse)
}

fn val_in_range(tup: TI, val: Int) -> Bool {
  val >= tup.0 && val <= tup.1
}

fn solution1(input: #(LTI, LI)) -> Int {
  use acc, x <- list.fold(input.1, 0)
  case list.any(input.0, fn(s) { val_in_range(s, x) }) {
    True -> acc + 1
    False -> acc
  }
}

fn solution2(input: LTI) -> Int {
  use acc, x <- list.fold(input, 0)
  acc + x.1 - x.0 + 1
}

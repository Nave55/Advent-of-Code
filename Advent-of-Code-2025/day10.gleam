// *** Part 1 Only ***

// import gleam/io
// import gleam/result
// import gleam/set.{type Set}
import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/string
import simplifile

pub type LI =
  List(Int)

pub type LLI =
  List(LI)

pub type Buttons {
  Buttons(pt1: LLI, pt2: LLI)
}

pub type Data {
  Data(indicator: Int, voltage: Dict(Int, Int), buttons: Buttons)
}

pub fn main() {
  // let con = parse_input("input/day10-test.txt")
  let con = parse_input("input/day10.txt")
  let pt1 = solution1(con)
  echo pt1
  // echo list.first(con)
  // let pt1 = solution1(con, 1000) |> int.to_string
  // let pt2 = solution2(con, 1000) |> int.to_string
  // io.println("Part 1: " <> pt1 <> "\nPart 2: " <> pt2)
}

pub fn bits_to_int(bits: List(Int)) -> Int {
  list.fold(bits, 0, fn(acc, bit) { acc * 2 + bit })
}

pub fn int_pow(base: Int, exp: Int) -> Int {
  case exp {
    0 -> 1
    _ -> list.fold(list.range(1, exp), 1, fn(acc, _) { acc * base })
  }
}

pub fn index_to_value(indices: List(Int), n: Int) -> List(Int) {
  list.map(indices, fn(i) { int_pow(2, n - 1 - i) })
}

fn parse_int_list(s: String) -> List(Int) {
  s
  |> string.slice(1, string.length(s) - 1)
  |> string.to_graphemes
  |> list.filter_map(int.parse)
}

fn parse_indicator(s: String) -> Int {
  let len = string.length(s) - 2
  s
  |> string.slice(1, len)
  |> string.to_graphemes
  |> list.map(fn(ch) {
    case ch {
      "." -> 0
      _ -> 1
    }
  })
  |> bits_to_int
}

pub fn parse_input(path: String) -> List(Data) {
  let assert Ok(con) = simplifile.read(path)

  con
  |> string.trim_end
  |> string.split("\r\n")
  |> list.map(fn(line) {
    let assert Ok(#(indicator_str, rest)) = string.split_once(line, " ")
    let parts = string.split(rest, " ")
    let assert Ok(volt_str) = list.last(parts)
    let button_strs = list.take(parts, list.length(parts) - 1)

    let indicator = parse_indicator(indicator_str)
    let buttons1 =
      list.map(button_strs, fn(b) {
        parse_int_list(b)
        |> index_to_value(string.length(indicator_str) - 2)
      })

    let buttons2 = list.map(button_strs, parse_int_list)

    let voltage =
      parse_int_list(volt_str)
      |> list.index_fold(dict.new(), fn(acc, x, ind) {
        dict.insert(acc, ind, x)
      })

    Data(indicator, voltage, Buttons(buttons1, buttons2))
  })
}

pub fn comb_sets(lst: LLI, curr_comb: Int) -> LLI {
  list.combinations(lst, curr_comb)
  |> list.map(list.flatten)
}

fn xor_all(xs: List(Int)) -> Int {
  list.fold(xs, 0, int.bitwise_exclusive_or)
}

pub fn press_buttons(
  data: Data,
  max_comb: Int,
  curr_comb: Int,
) -> Result(Int, Nil) {
  let found =
    data.buttons.pt1
    |> comb_sets(curr_comb)
    |> list.any(fn(xs) { xor_all(xs) == data.indicator })

  case found {
    True -> Ok(curr_comb)
    False ->
      case curr_comb == max_comb {
        True -> Error(Nil)
        False -> press_buttons(data, max_comb, curr_comb + 1)
      }
  }
}

pub fn solution1(lst: List(Data)) -> Int {
  use acc, x <- list.fold(lst, 0)
  case press_buttons(x, list.length(x.buttons.pt1), 1) {
    Ok(val) -> acc + val
    _ -> acc
  }
}

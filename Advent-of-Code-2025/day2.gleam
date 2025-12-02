import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub fn main() {
  let con = parse_input("input/day2.txt")
  let pt1 = solver(con, is_symetrical) |> int.to_string
  let pt2 = solver(con, is_repeated) |> int.to_string
  io.println("Part 1: " <> pt1)
  io.println("Part 2: " <> pt2)
}

fn list_from_range(range: String) -> List(Int) {
  let assert Ok(#(s_str, e_str)) = string.split_once(range, "-")
  let assert Ok(s) = int.parse(s_str)
  let assert Ok(e) = int.parse(e_str)
  list.range(s, e)
}

fn parse_input(path: String) -> List(Int) {
  let assert Ok(con) = simplifile.read(path)
  con
  |> string.trim_end
  |> string.split("\r\n")
  |> list.flat_map(fn(x) {
    let ranges = string.split(x, ",")
    list.flat_map(ranges, fn(y) { list_from_range(y) })
  })
}

pub fn digit_len(n: Int) -> Int {
  do_digit_len(n, 0)
}

fn do_digit_len(x: Int, acc: Int) -> Int {
  case x < 10 {
    True ->
      case acc == 0 {
        True -> 1
        False -> acc + 1
      }
    False -> do_digit_len(x / 10, acc + 1)
  }
}

pub fn pow10(k: Int) -> Int {
  do_pow10(k, 1)
}

fn do_pow10(i: Int, acc: Int) -> Int {
  case i <= 0 {
    True -> acc
    False -> do_pow10(i - 1, acc * 10)
  }
}

fn is_symetrical(n: Int) -> Bool {
  let digits = digit_len(n)
  case digits % 2 == 0 {
    False -> False
    True -> {
      let divisor = pow10(digits / 2)
      n / divisor == n % divisor
    }
  }
}

pub fn is_repeated(n: Int) -> Bool {
  let len = digit_len(n)
  case len <= 1 {
    True -> False
    False -> has_repeated_block(n, len, 2)
  }
}

fn has_repeated_block(n: Int, len: Int, k: Int) -> Bool {
  case k > len {
    True -> False
    False ->
      case len % k {
        0 -> {
          let block_len = len / k
          let block = n / pow10(len - block_len)
          let candidate = repeat_block(block, pow10(block_len), k, 0)
          case candidate == n {
            True -> True
            False -> has_repeated_block(n, len, k + 1)
          }
        }
        _ -> has_repeated_block(n, len, k + 1)
      }
  }
}

fn repeat_block(block: Int, pow_block: Int, k: Int, acc: Int) -> Int {
  case k <= 0 {
    True -> acc
    False -> repeat_block(block, pow_block, k - 1, acc * pow_block + block)
  }
}

fn solver(lst: List(Int), is_valid: fn(Int) -> Bool) {
  use acc, x <- list.fold(lst, 0)
  case is_valid(x) {
    True -> acc + x
    False -> acc
  }
}

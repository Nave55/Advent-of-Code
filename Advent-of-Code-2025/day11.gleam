import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub type PathDict =
  Dict(String, List(String))

pub type Memo =
  Dict(String, Int)

pub fn main() {
  let con = parse_input("input/day11.txt")
  let pt1 = solution1(con, "you", "out") |> int.to_string
  let pt2 = solution2(con, "svr", "out") |> int.to_string
  io.println("Part 1: " <> pt1 <> "\nPart 2: " <> pt2)
}

pub fn parse_input(path: String) -> PathDict {
  let assert Ok(con) = simplifile.read(path)

  con
  |> string.trim_end
  |> string.split("\r\n")
  |> list.map(fn(x) {
    let line = string.trim(x)
    let assert Ok(#(first, second)) = string.split_once(line, ": ")
    #(string.trim(first), string.split(second, " ") |> list.map(string.trim))
  })
  |> dict.from_list
}

pub fn solution1(con: PathDict, start: String, goal: String) -> Int {
  dfs(con, start, goal, 0, -1, dict.new()).0
}

pub fn solution2(con: PathDict, start: String, goal: String) -> Int {
  dfs(con, start, goal, 0, 3, dict.new()).0
}

fn key_for(node: String, mask: Int, use_mask: Bool) -> String {
  case use_mask {
    True -> node <> ":" <> int.to_string(mask)
    False -> node
  }
}

fn update_mask_for(node: String, mask: Int, use_mask: Bool) -> Int {
  case use_mask {
    True ->
      case node {
        "dac" -> int.bitwise_or(mask, int.bitwise_shift_left(1, 0))
        "fft" -> int.bitwise_or(mask, int.bitwise_shift_left(1, 1))
        _ -> mask
      }
    False -> mask
  }
}

fn dfs(
  con: PathDict,
  node: String,
  goal: String,
  mask: Int,
  target_mask: Int,
  memo: Memo,
) -> #(Int, Memo) {
  let use_mask = target_mask != -1
  let mask2 = update_mask_for(node, mask, use_mask)
  let k = key_for(node, mask2, use_mask)

  case dict.get(memo, k) {
    Ok(n) -> #(n, memo)
    Error(_) ->
      case node == goal {
        True -> {
          let res = case use_mask {
            True ->
              case mask2 == target_mask {
                True -> 1
                False -> 0
              }
            False -> 1
          }
          #(res, dict.insert(memo, k, res))
        }

        False ->
          case dict.get(con, node) {
            Error(_) -> #(0, dict.insert(memo, k, 0))
            Ok(neighbors) -> {
              let init = #(0, memo)
              let #(total, memo_final) =
                list.fold(neighbors, init, fn(acc_m, nei) {
                  let #(acc, m) = acc_m
                  let #(c, m2) = dfs(con, nei, goal, mask2, target_mask, m)
                  #(acc + c, m2)
                })
              let memo_with_k = dict.insert(memo_final, k, total)
              #(total, memo_with_k)
            }
          }
      }
  }
}

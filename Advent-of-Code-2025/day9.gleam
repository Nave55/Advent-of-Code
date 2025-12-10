import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub type Data {
  Data(nums: List(Int), len: Int, pos: Int)
}

pub type Point {
  Point(x: Int, y: Int)
}

pub fn main() {
  let #(data, lst) = parse_input("input/day9.txt")
  let #(ret1, _) = day9_scan_from(data, data.pos, 1, 100)
  let #(ret2, _) = day9_scan_from(data, data.pos + 1, -1, 100)
  io.println("Part 1: " <> part1(lst) |> int.to_string)
  io.println("Part 2: " <> int.max(ret1, ret2) |> int.to_string)
}

fn get(nums: List(Int), i: Int) -> Int {
  case list.first(list.drop(nums, i)) {
    Ok(x) -> x
    Error(_) -> panic as "index out of bounds: "
  }
}

pub fn parse_input(contents: String) -> #(Data, List(Point)) {
  let lines =
    simplifile.read(contents)
    |> result.unwrap("")
    |> string.trim_end
    |> string.split("\r\n")

  let parsed =
    lines
    |> list.filter_map(fn(line) {
      case string.split(line, ",") |> list.filter_map(int.parse) {
        [f, s] -> Ok(#(f, s))
        _ -> Error(Nil)
      }
    })

  let nums = list.flat_map(parsed, fn(v) { [v.0, v.1] })
  let lst = list.map(parsed, fn(v) { Point(v.0, v.1) })

  let len = list.length(nums) / 2

  let #(pos, _) =
    list.fold(list.range(1, len - 1), #(0, 0), fn(acc, i) {
      let #(best_i, maxdx) = acc
      let dx = int.absolute_value(get(nums, i * 2) - get(nums, { i - 1 } * 2))
      case dx > maxdx {
        True -> #(i, dx)
        False -> #(best_i, maxdx)
      }
    })

  #(Data(nums, len, pos), lst)
}

pub fn area(a: Point, b: Point) {
  let width = int.absolute_value(a.x - b.x) + 1
  let height = int.absolute_value(a.y - b.y) + 1
  width * height
}

pub fn part1(lst: List(Point)) -> Int {
  list.fold(list.combination_pairs(lst), 0, fn(acc, pair) {
    let #(a, b) = pair
    case a.x != b.x && a.y != b.y {
      True -> int.max(acc, area(a, b))
      False -> acc
    }
  })
}

fn advance(nums: List(Int), kcur: Int, kdir: Int, y2: Int) -> Int {
  case get(nums, kcur * 2 + 1) * kdir < y2 * kdir {
    True -> advance(nums, kcur + kdir, kdir, y2)
    False -> kcur
  }
}

fn loop(
  nums: List(Int),
  j: Int,
  k: Int,
  max: Int,
  ret: Int,
  best: Int,
  remaining: Int,
  x1: Int,
  y1: Int,
  kdir: Int,
) -> #(Int, Int) {
  case remaining < 0 {
    True -> #(ret, best)
    False -> {
      let j2 = j - kdir
      let x2 = get(nums, j2 * 2)
      let y2 = get(nums, j2 * 2 + 1)

      case x2 < max {
        True -> loop(nums, j2, k, max, ret, best, remaining - 1, x1, y1, kdir)
        False -> {
          let maxx2 = x2
          let k2 = advance(nums, k, kdir, y2)

          case get(nums, k2 * 2) < x1 {
            True -> #(ret, best)
            False -> {
              let area =
                { int.absolute_value(x2 - x1) + 1 }
                * { int.absolute_value(y2 - y1) + 1 }

              case area > ret {
                True ->
                  loop(
                    nums,
                    j2,
                    k2,
                    maxx2,
                    area,
                    j2,
                    remaining - 1,
                    x1,
                    y1,
                    kdir,
                  )
                False ->
                  loop(
                    nums,
                    j2,
                    k2,
                    maxx2,
                    ret,
                    best,
                    remaining - 1,
                    x1,
                    y1,
                    kdir,
                  )
              }
            }
          }
        }
      }
    }
  }
}

pub fn day9_scan_from(data: Data, i: Int, kdir: Int, limit: Int) -> #(Int, Int) {
  let x1 = get(data.nums, i * 2)
  let y1 = get(data.nums, i * 2 + 1)
  let kstart = case kdir > 0 {
    True -> 0
    False -> data.len - 1
  }
  loop(data.nums, i, kstart, 0, 0, i, limit, x1, y1, kdir)
}

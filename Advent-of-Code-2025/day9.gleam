import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub type PDict =
  Dict(Int, Point)

pub type Data {
  Data(points_dict: PDict, point_count: Int, pivot_index: Int)
}

pub type Point {
  Point(x: Int, y: Int)
}

pub fn main() {
  let #(data, points_list) = parse_input("input/day9.txt")

  let remaining_forward = data.point_count - data.pivot_index - 1
  let remaining_backward = data.pivot_index + 1
  let #(scan_a, _) = scan_from(data, data.pivot_index, 1, remaining_forward)
  let #(scan_b, _) =
    scan_from(data, data.pivot_index + 1, -1, remaining_backward)

  io.println("Part 1: " <> max_area_pairs(points_list) |> int.to_string)
  io.println("Part 2: " <> int.max(scan_a, scan_b) |> int.to_string)
}

fn get_dict(points_dict: PDict, i: Int) -> Point {
  case dict.get(points_dict, i) {
    Ok(p) -> p
    Error(_) -> panic as "index out of bounds"
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
        [x, y] -> Ok(#(x, y))
        _ -> Error(Nil)
      }
    })

  let points_list = list.map(parsed, fn(v) { Point(v.0, v.1) })
  let #(_, points_dict) =
    list.fold(points_list, #(0, dict.new()), fn(acc, p) {
      let #(i, d) = acc
      #(i + 1, dict.insert(d, i, p))
    })

  let point_count = list.length(points_list)
  let #(pivot_index, _) =
    list.fold(list.range(1, point_count - 1), #(0, 0), fn(acc, i) {
      let #(best_i, max_dx) = acc
      let a = get_dict(points_dict, i)
      let b = get_dict(points_dict, i - 1)
      let dx = int.absolute_value(a.x - b.x)
      case dx > max_dx {
        True -> #(i, dx)
        False -> #(best_i, max_dx)
      }
    })

  #(Data(points_dict, point_count, pivot_index), points_list)
}

pub fn rect_area(a: Point, b: Point) {
  let width = int.absolute_value(a.x - b.x) + 1
  let height = int.absolute_value(a.y - b.y) + 1
  width * height
}

pub fn max_area_pairs(points: List(Point)) -> Int {
  list.fold(list.combination_pairs(points), 0, fn(acc, pair) {
    let #(a, b) = pair
    case a.x != b.x && a.y != b.y {
      True -> int.max(acc, rect_area(a, b))
      False -> acc
    }
  })
}

fn advance_k(points_dict: PDict, kcur: Int, kdir: Int, y_target: Int) -> Int {
  let p = get_dict(points_dict, kcur)
  case p.y * kdir < y_target * kdir {
    True -> advance_k(points_dict, kcur + kdir, kdir, y_target)
    False -> kcur
  }
}

fn scan_loop(
  pdict: PDict,
  j_ind: Int,
  k_ind: Int,
  x_lim: Int,
  best_area: Int,
  best_j: Int,
  rem: Int,
  x1: Int,
  y1: Int,
  k_dir: Int,
) -> #(Int, Int) {
  case rem <= 0 {
    True -> #(best_area, best_j)
    False -> {
      let j_prev = j_ind - k_dir
      let p2 = get_dict(pdict, j_prev)
      let x2 = p2.x
      let y2 = p2.y

      case x2 < x_lim {
        True ->
          scan_loop(
            pdict,
            j_prev,
            k_ind,
            x_lim,
            best_area,
            best_j,
            rem - 1,
            x1,
            y1,
            k_dir,
          )
        False -> {
          let new_x_limit = x2
          let k_next = advance_k(pdict, k_ind, k_dir, y2)
          let pk = get_dict(pdict, k_next)

          case pk.x < x1 {
            True -> #(best_area, best_j)
            False -> {
              let area =
                { int.absolute_value(x2 - x1) + 1 }
                * { int.absolute_value(y2 - y1) + 1 }

              case area > best_area {
                True ->
                  scan_loop(
                    pdict,
                    j_prev,
                    k_next,
                    new_x_limit,
                    area,
                    j_prev,
                    rem - 1,
                    x1,
                    y1,
                    k_dir,
                  )
                False ->
                  scan_loop(
                    pdict,
                    j_prev,
                    k_next,
                    new_x_limit,
                    best_area,
                    best_j,
                    rem - 1,
                    x1,
                    y1,
                    k_dir,
                  )
              }
            }
          }
        }
      }
    }
  }
}

pub fn scan_from(data: Data, start: Int, k_dir: Int, rem: Int) -> #(Int, Int) {
  let p1 = get_dict(data.points_dict, start)
  let x1 = p1.x
  let y1 = p1.y
  let k_start = case k_dir > 0 {
    True -> 0
    False -> data.point_count - 1
  }
  scan_loop(data.points_dict, start, k_start, 0, 0, start, rem, x1, y1, k_dir)
}

import gleam/float
import gleam/int
import gleam/io
import gleam/list.{Continue, Stop}
import gleam/result
import gleam/set.{type Set}
import gleam/string
import simplifile

pub type Coord {
  Coord(x: Int, y: Int, z: Int)
}

pub type Circuit {
  Circuit(a: Coord, b: Coord, len: Float)
}

pub type SC =
  Set(Coord)

pub fn main() {
  let con = parse_input("input/day8.txt")
  let pt1 = solution1(con, 1000) |> int.to_string
  let pt2 = solution2(con, 1000) |> int.to_string
  io.println("Part 1: " <> pt1 <> "\nPart 2: " <> pt2)
}

pub fn euclid_distance(a: Coord, b: Coord) -> Float {
  let dx = a.x - b.x
  let dy = a.y - b.y
  let dz = a.z - b.z
  int.square_root(dx * dx + dy * dy + dz * dz) |> result.unwrap(0.0)
}

pub fn parse_input(path: String) -> List(Circuit) {
  let assert Ok(con) = simplifile.read(path)

  con
  |> string.trim_end
  |> string.split("\r\n")
  |> list.filter_map(fn(s) {
    case list.filter_map(string.split(s, ","), int.parse) {
      [x, y, z] -> Ok(Coord(x, y, z))
      _ -> Error(Nil)
    }
  })
  |> list.combination_pairs
  |> list.map(fn(p) { Circuit(p.0, p.1, euclid_distance(p.0, p.1)) })
  |> list.sort(fn(a, b) { float.compare(a.len, b.len) })
}

fn extract_set(item: Coord, groups: List(SC)) -> #(Result(SC, Nil), List(SC)) {
  let #(matches, rest) = list.partition(groups, fn(s) { set.contains(s, item) })
  #(list.first(matches), rest)
}

fn merge_coords(circ: Circuit, circuits: List(SC)) -> List(SC) {
  let #(circ1, rest1) = extract_set(circ.a, circuits)
  let #(circ2, rest2) = extract_set(circ.b, rest1)

  case circ1, circ2 {
    Error(_), Error(_) -> [set.from_list([circ.a, circ.b]), ..rest2]
    Ok(c), Error(_) -> [set.insert(c, circ.b), ..rest2]
    Error(_), Ok(c) -> [set.insert(c, circ.a), ..rest2]
    Ok(c1), Ok(c2) -> [set.union(c1, c2), ..rest2]
  }
}

pub fn solution1(lst: List(Circuit), connections: Int) -> Int {
  lst
  |> list.take(connections)
  |> list.fold([], fn(acc, circ) { merge_coords(circ, acc) })
  |> list.map(set.size)
  |> list.sort(fn(a, b) { int.compare(b, a) })
  |> list.take(3)
  |> list.fold(1, int.multiply)
}

pub fn solution2(lst: List(Circuit), total_nodes: Int) -> Int {
  let #(_, last_pair) =
    lst
    |> list.fold_until(#([], #(Coord(0, 0, 0), Coord(0, 0, 0))), fn(acc, circ) {
      let #(circuits, _) = acc
      let new_circuits = merge_coords(circ, circuits)
      let assert Ok(first_set) = list.first(new_circuits)

      case set.size(first_set) == total_nodes {
        True -> Stop(#(new_circuits, #(circ.a, circ.b)))
        False -> Continue(#(new_circuits, #(circ.a, circ.b)))
      }
    })

  { last_pair.0 }.x * { last_pair.1 }.x
}

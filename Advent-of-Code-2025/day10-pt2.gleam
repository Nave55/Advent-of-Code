import gleam/int
import gleam/list
import gleam/string
import simplifile

// ---------- Types ----------
pub type LI =
  List(Int)

pub type LLI =
  List(LI)

pub type LB =
  List(Bool)

pub type Rat =
  #(Int, Int)

pub type LR =
  List(Rat)

pub type LLR =
  List(LR)

pub type TII =
  #(Int, Int, Int)

pub type Node {
  Node(buttons: LLI, target: LI)
}

// -------- Helpers --------
fn lcm(a: Int, b: Int) -> Int {
  case a == 0 || b == 0 {
    True -> 0
    False -> int.absolute_value(a * b) / gcd(a, b)
  }
}

fn gcd(a: Int, b: Int) -> Int {
  let a = int.absolute_value(a)
  let b = int.absolute_value(b)
  case b == 0 {
    True -> a
    False -> gcd(b, a % b)
  }
}

fn ceil_abs(n: Int, d: Int) -> Int {
  let an = int.absolute_value(n)
  let ad = int.absolute_value(d)
  case ad == 0 {
    True -> 0
    False -> { an + ad - 1 } / ad
  }
}

fn min_int(a: Int, b: Int) -> Int {
  case a < b {
    True -> a
    False -> b
  }
}

// extract free indices from LB
fn free_indices(flags: LB) -> LI {
  list.index_fold(flags, [], fn(acc, b, i) {
    case b {
      True -> list.append(acc, [i])
      False -> acc
    }
  })
}

fn normalize_rat(r: Rat) -> Rat {
  let #(n, d) = r
  case d == 0 {
    True -> #(0, 1)
    False -> {
      let g = gcd(n, d)
      let sign = case d < 0 {
        True -> -1
        False -> 1
      }
      #(sign * { n / g }, int.absolute_value(d / g))
    }
  }
}

fn rat_from_int(i: Int) -> Rat {
  normalize_rat(#(i, 1))
}

fn rat_zero() -> Rat {
  #(0, 1)
}

fn rat_add(a: Rat, b: Rat) -> Rat {
  let #(an, ad) = a
  let #(bn, bd) = b
  normalize_rat(#(an * bd + bn * ad, ad * bd))
}

fn rat_sub(a: Rat, b: Rat) -> Rat {
  let #(an, ad) = a
  let #(bn, bd) = b
  normalize_rat(#(an * bd - bn * ad, ad * bd))
}

fn rat_mul(a: Rat, b: Rat) -> Rat {
  let #(an, ad) = a
  let #(bn, bd) = b
  normalize_rat(#(an * bn, ad * bd))
}

fn rat_div(a: Rat, b: Rat) -> Rat {
  let #(an, ad) = a
  let #(bn, bd) = b
  case bn == 0 {
    True -> #(0, 1)
    False -> normalize_rat(#(an * bd, ad * bn))
  }
}

fn rat_is_zero(a: Rat) -> Bool {
  let #(n, _) = a
  n == 0
}

fn rat_is_integer(a: Rat) -> Bool {
  let #(n, d) = a
  d != 0 && n % d == 0
}

fn rat_to_int(a: Rat) -> Int {
  let #(n, d) = a
  n / d
}

fn nth_or(xs: List(a), i: Int, default: a) -> a {
  case list.drop(xs, i) {
    [] -> default
    [x, ..] -> x
  }
}

fn replace_elem(xs: List(a), i: Int, v: a) -> List(a) {
  list.index_map(xs, fn(x, idx) {
    case idx == i {
      True -> v
      False -> x
    }
  })
}

fn build_congruences(
  mat: List(List(Rat)),
  free_ixs: LI,
) -> List(#(Int, List(Rat), Int)) {
  let height = list.length(mat)
  let width = case height == 0 {
    True -> 0
    False -> list.length(nth_or(mat, 0, []))
  }

  list.index_map(mat, fn(row, _) {
    let denoms =
      list.index_map(free_ixs, fn(fcol, _) { nth_or(row, fcol, rat_zero()).1 })
      |> list.append([nth_or(row, width - 1, rat_zero()).1])

    let modulus =
      list.fold(denoms, 1, fn(acc, d) {
        case d == 0 {
          True -> acc
          False -> lcm(acc, int.absolute_value(d))
        }
      })

    case modulus == 0 {
      True -> #(0, [], 0)
      False -> {
        let coeffs =
          list.index_map(free_ixs, fn(fcol, k) {
            let #(an, ad) = nth_or(row, fcol, rat_zero())
            let coeff = an * { modulus / ad }
            let coeff_modulus = { { coeff % modulus } + modulus } % modulus
            #(k, coeff_modulus)
          })

        let #(rn, rd) = nth_or(row, width - 1, rat_zero())
        let rhs_int = rn * { modulus / rd }
        let rhs_modulus = { { rhs_int % modulus } + modulus } % modulus

        #(modulus, coeffs, rhs_modulus)
      }
    }
  })
  |> list.filter(fn(c) {
    case c {
      #(0, _, _) -> False
      #(_modulus, coeffs, rhs_modulus) -> {
        let any_nonzero = list.any(coeffs, fn(p) { p.1 != 0 })
        any_nonzero || rhs_modulus != 0
      }
    }
  })
}

fn replace_row_rat(matrix: LLR, r: Int, row: LR) -> LLR {
  list.index_map(matrix, fn(old, i) {
    case i == r {
      True -> row
      False -> old
    }
  })
}

fn build_matrix_rat(target: LI, buttons: LLI) -> LLR {
  let height = list.length(target)
  let width = list.length(buttons) + 1
  let zeros_row = list.repeat(rat_zero(), width)
  let mut_mat = list.repeat(zeros_row, height)

  let with_cols =
    list.index_map(buttons, fn(col, ind) {
      list.map(col, fn(row_i) { #(row_i, ind) })
    })
    |> list.flatten
    |> list.fold(mut_mat, fn(m, pair) {
      let row_i = pair.0
      let col_j = pair.1
      let row = nth_or(m, row_i, zeros_row)
      let new_row = replace_elem(row, col_j, rat_from_int(1))
      replace_row_rat(m, row_i, new_row)
    })

  list.index_map(with_cols, fn(row, i) {
    replace_elem(row, width - 1, rat_from_int(nth_or(target, i, 0)))
  })
}

fn leading_col_rat(row: LR) -> Int {
  let width = list.length(row)
  list.range(0, width - 2)
  |> list.fold(-1, fn(acc, j) {
    case acc {
      -1 ->
        case !rat_is_zero(nth_or(row, j, rat_zero())) {
          True -> j
          False -> -1
        }
      _ -> acc
    }
  })
}

fn normalize_pivot_row(mat: LLR, row: Int, col: Int) -> LLR {
  let row_r = nth_or(mat, row, [])
  let pivot = nth_or(row_r, col, rat_zero())
  case rat_is_zero(pivot) {
    True -> mat
    False -> {
      let norm_row = list.map(row_r, fn(v) { rat_div(v, pivot) })
      replace_row_rat(mat, row, norm_row)
    }
  }
}

fn reduce_row_rat(mat: LLR, height: Int, width: Int, row: Int, col: Int) -> LLR {
  let mat1 = normalize_pivot_row(mat, row, col)
  let norm_row = nth_or(mat1, row, [])
  list.index_map(list.range(0, height - 1), fn(_, i) {
    case i == row {
      True -> norm_row
      False -> {
        let row_i = nth_or(mat1, i, [])
        let factor = nth_or(row_i, col, rat_zero())
        list.index_map(list.range(0, width - 1), fn(j, _) {
          rat_sub(
            nth_or(row_i, j, rat_zero()),
            rat_mul(factor, nth_or(norm_row, j, rat_zero())),
          )
        })
      }
    }
  })
}

fn zero_row_rat(row: LR, width: Int) -> Bool {
  list.range(0, width - 2)
  |> list.all(fn(j) { rat_is_zero(nth_or(row, j, rat_zero())) })
}

fn remove_zero_rows_rat(matrix: LLR, width: Int) -> LLR {
  list.filter(matrix, fn(row) { !zero_row_rat(row, width) })
}

fn row_max_rat(matrix: LLR, start_row: Int, col: Int, height: Int) -> Int {
  list.range(start_row, height - 1)
  |> list.fold(#(-1, rat_zero()), fn(acc, i) {
    let val = nth_or(nth_or(matrix, i, []), col, rat_zero())
    case acc {
      #(_, bv) ->
        case rat_is_zero(bv) {
          True ->
            case !rat_is_zero(val) {
              True -> #(i, val)
              False -> acc
            }
          False -> acc
        }
    }
  })
  |> fn(x) { x.0 }
}

fn gauss_loop_rat(
  m: LLR,
  f: LB,
  row: Int,
  col: Int,
  free: Int,
  height: Int,
  width: Int,
) -> #(LLR, LB, Int, Int) {
  case row < height && col < width - 1 {
    True -> {
      let rm = row_max_rat(m, row, col, height)
      case rm < 0 {
        True ->
          gauss_loop_rat(
            m,
            replace_elem(f, col, True),
            row,
            col + 1,
            free + 1,
            height,
            width,
          )
        False -> {
          // Use the Rat-specific replace_row to swap rows
          let swapped =
            replace_row_rat(
              replace_row_rat(m, row, nth_or(m, rm, [])),
              rm,
              nth_or(m, row, []),
            )
          let reduced = reduce_row_rat(swapped, height, width, row, col)
          gauss_loop_rat(reduced, f, row + 1, col + 1, free, height, width)
        }
      }
    }
    False -> #(m, f, free, col)
  }
}

fn gauss_eliminate_rat(
  matrix: LLR,
  free_cols: LB,
  height: Int,
  width: Int,
) -> #(LLR, LB, Int) {
  let #(m1, f1, _, col_after) =
    gauss_loop_rat(matrix, free_cols, 0, 0, 0, height, width)
  let f2 =
    list.range(col_after, width - 2)
    |> list.fold(f1, fn(f, j) { replace_elem(f, j, True) })
  let free_count2 =
    list.fold(f2, 0, fn(acc, b) {
      case b {
        True -> acc + 1
        False -> acc
      }
    })
  let m2 = remove_zero_rows_rat(m1, width)
  #(m2, f2, free_count2)
}

fn reduced_form_rat(target: LI, buttons: LLI) -> #(LLR, LB) {
  let mat0 = build_matrix_rat(target, buttons)
  let height = list.length(target)
  let width = list.length(buttons) + 1
  let free0 = list.repeat(False, width - 1)
  let #(mat, free_cols, _free_count) =
    gauss_eliminate_rat(mat0, free0, height, width)
  #(mat, free_cols)
}

fn find_lead_rows(mat: LLR) -> LR {
  list.index_map(mat, fn(row, r) {
    let lc = leading_col_rat(row)
    case lc {
      -1 -> []
      _ -> [#(lc, r)]
    }
  })
  |> list.flatten
}

fn row_for_col(lead_rows: LR, col: Int) -> Int {
  list.find(lead_rows, fn(pair) { pair.0 == col })
  |> fn(x) {
    case x {
      Ok(#(_, r)) -> r
      Error(_) -> -1
    }
  }
}

fn free_pos(free_ixs: LI, col: Int) -> Int {
  list.index_fold(free_ixs, 0, fn(acc, x, i) {
    case acc {
      0 ->
        case x == col {
          True -> i
          False -> 0
        }
      _ -> acc
    }
  })
}

fn compute_presses_from_rat(
  mat: LLR,
  free_cols: LB,
  vars: LI,
) -> Result(LI, String) {
  let height = list.length(mat)
  let width = case height == 0 {
    True -> 0
    False -> list.length(nth_or(mat, 0, []))
  }
  let num_buttons = width - 1
  let free_ixs = free_indices(free_cols)
  let lead_rows = find_lead_rows(mat)

  let presses_res =
    list.range(0, num_buttons - 1)
    |> list.index_map(fn(_, col) {
      case nth_or(free_cols, col, False) {
        True -> {
          let pos = free_pos(free_ixs, col)
          Ok(nth_or(vars, pos, 0))
        }
        False -> {
          let r = row_for_col(lead_rows, col)
          case r {
            -1 -> Ok(0)
            _ -> {
              let row = nth_or(mat, r, [])
              let rhs = nth_or(row, width - 1, rat_zero())
              let sub =
                list.index_map(free_ixs, fn(fcol, k) {
                  let a = nth_or(row, fcol, rat_zero())
                  let x = rat_from_int(nth_or(vars, k, 0))
                  rat_mul(a, x)
                })
                |> list.fold(rat_zero(), fn(acc, v) { rat_add(acc, v) })

              let val_rat = rat_sub(rhs, sub)
              let coeff = nth_or(row, col, rat_from_int(1))

              case rat_is_zero(coeff) {
                True ->
                  Error(
                    "zero pivot coefficient for column " <> int.to_string(col),
                  )
                False -> {
                  let solved = rat_div(val_rat, coeff)
                  case rat_is_integer(solved) {
                    True -> Ok(rat_to_int(solved))
                    False -> {
                      let #(n, d) = solved
                      Error(
                        "non-integer dependent variable at col "
                        <> int.to_string(col)
                        <> ": "
                        <> int.to_string(n)
                        <> "/"
                        <> int.to_string(d),
                      )
                    }
                  }
                }
              }
            }
          }
        }
      }
    })

  let found_err =
    list.find(presses_res, fn(r) {
      case r {
        Ok(_) -> False
        Error(_) -> True
      }
    })

  case found_err {
    Ok(err_val) -> {
      case err_val {
        Error(msg) -> {
          echo #("compute_presses_error", msg)
          Error(msg)
        }
        Ok(_) -> Error("unexpected")
      }
    }
    Error(_) -> {
      let presses =
        list.index_map(presses_res, fn(r, _) {
          case r {
            Ok(v) -> v
            Error(_) -> 0
          }
        })
      Ok(presses)
    }
  }
}

fn row_sums_int(buttons: LLI, presses: LI, height: Int) -> LI {
  list.range(0, height - 1)
  |> list.map(fn(r) {
    list.index_map(buttons, fn(brows, j) {
      case list.contains(brows, r) {
        True -> nth_or(presses, j, 0)
        False -> 0
      }
    })
    |> list.fold(0, fn(acc, x) { acc + x })
  })
}

fn verify_solution(buttons: LLI, target: LI, presses: LI) -> Bool {
  let height = list.length(target)
  let sums = row_sums_int(buttons, presses, height)
  let diffs = list.index_map(sums, fn(s, i) { s - nth_or(target, i, 0) })
  let ok = list.all(diffs, fn(d) { d == 0 })
  echo #(
    "verify",
    #("presses", presses),
    #("computed", sums),
    #("target", target),
    #("diffs", diffs),
    #("ok", ok),
  )
  ok
}

fn compute_free_bounds(mat: LLR, free_ixs: LI) -> LR {
  let width = case mat {
    [] -> 0
    _ -> list.length(nth_or(mat, 0, []))
  }

  list.index_map(free_ixs, fn(fcol, _) {
    let max_est =
      list.index_fold(mat, 0, fn(acc, row, _) {
        let #(cn, cd) = nth_or(row, fcol, rat_zero())
        let #(rn, rd) = nth_or(row, width - 1, rat_zero())
        let val = case cn == 0 {
          True -> 0
          False -> ceil_abs(rn * cd, rd * cn)
        }
        case val > acc {
          True -> val
          False -> acc
        }
      })

    let hi_pre = case max_est > 0 {
      True -> max_est
      False -> 100
    }
    let hi = min_int(hi_pre, 200)
    #(0, hi)
  })
}

fn build_cong_index(
  congrs: List(#(Int, LR, Int)),
  free_count: Int,
) -> #(List(TII), LLR) {
  let congs_meta =
    list.index_map(congrs, fn(c, _) {
      let modulus = c.0
      let coeffs = c.1
      let rhs = c.2
      #(modulus, rhs, list.length(coeffs))
    })

  let congs_by_var = list.repeat([], free_count)

  let pairs =
    list.index_map(congrs, fn(c, cong_idx) {
      list.index_map(c.1, fn(p, _) {
        let var_idx = p.0
        let coeff_mod = p.1
        #(var_idx, #(cong_idx, coeff_mod))
      })
    })
    |> list.flatten

  let congs_by_var =
    list.fold(pairs, congs_by_var, fn(acc, pair) {
      let var_idx = pair.0
      let cong_pair = pair.1
      replace_elem(
        acc,
        var_idx,
        list.append(nth_or(acc, var_idx, []), [cong_pair]),
      )
    })

  #(congs_meta, congs_by_var)
}

fn update_congruences(
  val: Int,
  var_idx: Int,
  congs_meta: List(TII),
  congs_by_var: LLR,
  sums: LI,
  counts: LI,
) -> #(LI, LI, Bool) {
  let related = nth_or(congs_by_var, var_idx, [])

  list.fold(related, #(sums, counts, False), fn(acc, pair) {
    let #(sums_acc, counts_acc, fail_acc) = acc

    case fail_acc {
      True -> acc
      False -> {
        let cong_idx = pair.0
        let coeff = pair.1
        let #(modulus, rhs, num_coeffs) =
          nth_or(congs_meta, cong_idx, #(1, 0, 0))

        let new_sum =
          { nth_or(sums_acc, cong_idx, 0) + coeff * { val % modulus } }
          % modulus
        let new_count = nth_or(counts_acc, cong_idx, 0) + 1
        let fail_now = new_count == num_coeffs && new_sum != rhs

        #(
          list.index_map(sums_acc, fn(x, i) {
            case i == cong_idx {
              True -> new_sum
              False -> x
            }
          }),
          list.index_map(counts_acc, fn(x, i) {
            case i == cong_idx {
              True -> new_count
              False -> x
            }
          }),
          fail_now,
        )
      }
    }
  })
}

fn dfs_incremental(
  idx: Int,
  free_count: Int,
  ranges: LLI,
  vars: LI,
  sums: LI,
  counts: LI,
  congs_meta: List(TII),
  congs_by_var: LLR,
  mat: LLR,
  free_cols: LB,
  buttons: LLI,
  target: LI,
  best: Result(#(LI, Int), String),
) -> Result(#(LI, Int), String) {
  case idx == free_count {
    True -> {
      case compute_presses_from_rat(mat, free_cols, vars) {
        Ok(presses) -> {
          case list.all(presses, fn(x) { x >= 0 }) {
            True -> {
              case verify_solution(buttons, target, presses) {
                True -> {
                  let total = list.fold(presses, 0, fn(acc, x) { acc + x })
                  case best {
                    Ok(#(_, bs)) -> {
                      case total < bs {
                        True -> Ok(#(presses, total))
                        False -> best
                      }
                    }
                    Error(_) -> Ok(#(presses, total))
                  }
                }
                False -> best
              }
            }
            False -> best
          }
        }
        Error(_) -> best
      }
    }
    False -> {
      list.fold(nth_or(ranges, idx, []), best, fn(best_acc, val) {
        let new_vars = replace_elem(vars, idx, val)
        let #(new_sums, new_counts, fail) =
          update_congruences(val, idx, congs_meta, congs_by_var, sums, counts)
        case fail {
          True -> best_acc
          False -> {
            dfs_incremental(
              idx + 1,
              free_count,
              ranges,
              new_vars,
              new_sums,
              new_counts,
              congs_meta,
              congs_by_var,
              mat,
              free_cols,
              buttons,
              target,
              best_acc,
            )
          }
        }
      })
    }
  }
}

fn enumerate_feasible_incremental(
  mat: LLR,
  free_cols: LB,
  buttons: LLI,
  target: LI,
) -> LI {
  let free_ixs = free_indices(free_cols)
  case free_ixs {
    [] -> {
      case compute_presses_from_rat(mat, free_cols, []) {
        Ok(p) -> p
        Error(_) -> list.repeat(0, list.length(free_cols))
      }
    }
    _ -> {
      let ranges =
        list.index_map(compute_free_bounds(mat, free_ixs), fn(b, _) {
          let hi_capped = min_int(b.0 + 10_000, b.1)
          list.range(b.0, hi_capped)
        })
      let congrs = build_congruences(mat, free_ixs)
      let #(congs_meta, congs_by_var) =
        build_cong_index(congrs, list.length(free_ixs))
      let vars_init = list.repeat(0, list.length(free_ixs))
      let sums_init = list.repeat(0, list.length(congs_meta))
      let counts_init = list.repeat(0, list.length(congs_meta))
      case
        dfs_incremental(
          0,
          list.length(free_ixs),
          ranges,
          vars_init,
          sums_init,
          counts_init,
          congs_meta,
          congs_by_var,
          mat,
          free_cols,
          buttons,
          target,
          Error("nil"),
        )
      {
        Ok(#(presses, _)) -> presses
        Error(_) -> list.repeat(0, list.length(free_cols))
      }
    }
  }
}

fn parse_input(path: String) -> List(Node) {
  let assert Ok(con) = simplifile.read(path)

  con
  |> string.trim_end
  |> string.split("\r\n")
  |> list.map(fn(line) {
    let assert Ok(#(_, rest)) = string.split_once(line, " ")
    let parts = string.split(rest, " ")
    let assert Ok(volt_str) = list.last(parts)
    let button_strs = list.take(parts, list.length(parts) - 1)
    let buttons = list.map(button_strs, parse_int_list)

    let target =
      volt_str
      |> string.slice(1, string.length(volt_str) - 2)
      |> string.split(",")
      |> list.filter_map(int.parse)

    Node(buttons, target)
  })
}

fn parse_int_list(s: String) -> LI {
  s
  |> string.slice(1, string.length(s) - 2)
  |> string.split(",")
  |> list.filter_map(int.parse)
}

pub fn solution(lst: List(Node)) -> Result(Int, Node) {
  use acc, n <- list.try_fold(lst, 0)
  let #(reduced, free_cols) = reduced_form_rat(n.target, n.buttons)
  let sol =
    enumerate_feasible_incremental(reduced, free_cols, n.buttons, n.target)
  let total = list.fold(sol, 0, fn(acc, x) { acc + x })
  let ok = verify_solution(n.buttons, n.target, sol)
  case ok {
    True -> Ok(acc + total)
    False -> Error(n)
  }
}

// ---------- Example main ----------
pub fn main() {
  let con = parse_input("input/day10.txt")
  echo solution(con)
}

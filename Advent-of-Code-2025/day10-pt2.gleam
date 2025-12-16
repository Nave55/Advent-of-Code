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

pub type Node {
  Node(buttons: LLI, target: LI)
}

// numerator, denominator (normalized, denom > 0)

// ---------- integer helpers ----------
pub fn lcm(a: Int, b: Int) -> Int {
  case a == 0 || b == 0 {
    True -> 0
    False -> int.absolute_value(a * b) / gcd(a, b)
  }
}

pub fn rat_to_nd(r: Rat) -> #(Int, Int) {
  let #(n, d) = r
  #(n, d)
}

// ---------- build congruences from reduced matrix ----------
// Each row yields a modular constraint for integrality of the dependent variable.
// Returned list: #(modulus, coeffs per free index (in free_ixs order), rhs_modulus)
pub fn build_congruences(
  mat: List(List(Rat)),
  free_ixs: LI,
) -> List(#(Int, List(#(Int, Int)), Int)) {
  let height = list.length(mat)
  let width = case height == 0 {
    True -> 0
    False -> list.length(nth_or(mat, 0, []))
  }

  list.index_map(mat, fn(row, _) {
    let denoms =
      list.index_map(free_ixs, fn(fcol, _) {
        rat_to_nd(nth_or(row, fcol, rat_zero())).1
      })
      |> list.append([rat_to_nd(nth_or(row, width - 1, rat_zero())).1])

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
            let #(an, ad) = rat_to_nd(nth_or(row, fcol, rat_zero()))
            let coeff = an * { modulus / ad }
            let coeff_modulus = { { coeff % modulus } + modulus } % modulus
            #(k, coeff_modulus)
          })

        let #(rn, rd) = rat_to_nd(nth_or(row, width - 1, rat_zero()))
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

// ---------- check congruences for a partial assignment ----------
// partial values correspond to free_ixs order: index 0..len(partial)-1
pub fn congruences_hold_partial(
  congrs: List(#(Int, List(#(Int, Int)), Int)),
  partial: LI,
) -> Bool {
  list.all(congrs, fn(c) {
    let modulus = c.0
    let coeffs = c.1
    let rhs_modulus = c.2

    let assigned_sum =
      list.fold(coeffs, 0, fn(acc, p) {
        let idx = p.0
        let coeff_modulus = p.1
        case idx < list.length(partial) {
          True -> {
            let v = nth_or(partial, idx, 0)
            let contrib = { coeff_modulus * { v % modulus } } % modulus
            { { acc + contrib } % modulus + modulus } % modulus
          }
          False -> acc
        }
      })

    let all_assigned = list.all(coeffs, fn(p) { p.0 < list.length(partial) })
    case all_assigned {
      True -> { { assigned_sum % modulus } + modulus } % modulus == rhs_modulus
      False -> True
    }
  })
}

// ---------- Rational helpers ----------
pub fn gcd(a: Int, b: Int) -> Int {
  let a = int.absolute_value(a)
  let b = int.absolute_value(b)
  case b == 0 {
    True -> a
    False -> gcd(b, a % b)
  }
}

pub fn normalize_rat(r: Rat) -> Rat {
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

pub fn rat_from_int(i: Int) -> Rat {
  normalize_rat(#(i, 1))
}

pub fn rat_zero() -> Rat {
  #(0, 1)
}

pub fn rat_add(a: Rat, b: Rat) -> Rat {
  let #(an, ad) = a
  let #(bn, bd) = b
  normalize_rat(#(an * bd + bn * ad, ad * bd))
}

pub fn rat_sub(a: Rat, b: Rat) -> Rat {
  let #(an, ad) = a
  let #(bn, bd) = b
  normalize_rat(#(an * bd - bn * ad, ad * bd))
}

pub fn rat_mul(a: Rat, b: Rat) -> Rat {
  let #(an, ad) = a
  let #(bn, bd) = b
  normalize_rat(#(an * bn, ad * bd))
}

pub fn rat_div(a: Rat, b: Rat) -> Rat {
  let #(an, ad) = a
  let #(bn, bd) = b
  case bn == 0 {
    True -> #(0, 1)
    False -> normalize_rat(#(an * bd, ad * bn))
  }
}

pub fn rat_is_zero(a: Rat) -> Bool {
  let #(n, _) = a
  n == 0
}

pub fn rat_is_integer(a: Rat) -> Bool {
  let #(n, d) = a
  d != 0 && n % d == 0
}

pub fn rat_to_int(a: Rat) -> Int {
  let #(n, d) = a
  n / d
}

// ---------- List helpers ----------
pub fn nth_or(xs: List(a), i: Int, default: a) -> a {
  case list.drop(xs, i) {
    [] -> default
    [x, ..] -> x
  }
}

pub fn replace_elem(xs: List(a), i: Int, v: a) -> List(a) {
  list.index_map(xs, fn(x, idx) {
    case idx == i {
      True -> v
      False -> x
    }
  })
}

pub fn replace_row(matrix: LLI, r: Int, row: LI) -> LLI {
  list.index_map(matrix, fn(old, i) {
    case i == r {
      True -> row
      False -> old
    }
  })
}

// ---------- Matrix builder (Rational) ----------

pub fn replace_row_rat(
  matrix: List(List(Rat)),
  r: Int,
  row: List(Rat),
) -> List(List(Rat)) {
  list.index_map(matrix, fn(old, i) {
    case i == r {
      True -> row
      False -> old
    }
  })
}

pub fn build_matrix_rat(target: LI, buttons: LLI) -> List(List(Rat)) {
  let height = list.length(target)
  let width = list.length(buttons) + 1
  let zeros_row = list.repeat(rat_zero(), width)
  let mut_mat = list.repeat(zeros_row, height)

  let with_cols =
    list.index_map(buttons, fn(col, j) {
      // use list.map here because we only need the element (row_i)
      list.map(col, fn(row_i) { #(row_i, j) })
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

// ---------- Gaussian elimination (exact rationals) ----------
pub fn leading_col_rat(row: List(Rat)) -> Int {
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

pub fn normalize_pivot_row(
  mat: List(List(Rat)),
  row: Int,
  col: Int,
) -> List(List(Rat)) {
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

pub fn reduce_row_rat(
  mat: List(List(Rat)),
  height: Int,
  width: Int,
  row: Int,
  col: Int,
) -> List(List(Rat)) {
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

pub fn zero_row_rat(row: List(Rat), width: Int) -> Bool {
  list.range(0, width - 2)
  |> list.all(fn(j) { rat_is_zero(nth_or(row, j, rat_zero())) })
}

pub fn remove_zero_rows_rat(
  matrix: List(List(Rat)),
  width: Int,
) -> List(List(Rat)) {
  list.filter(matrix, fn(row) { !zero_row_rat(row, width) })
}

pub fn row_max_rat(
  matrix: List(List(Rat)),
  start_row: Int,
  col: Int,
  height: Int,
) -> Int {
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

pub fn gauss_loop_rat(
  m: List(List(Rat)),
  f: LB,
  row: Int,
  col: Int,
  free_count: Int,
  height: Int,
  width: Int,
) -> #(List(List(Rat)), LB, Int, Int) {
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
            free_count + 1,
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
          gauss_loop_rat(
            reduced,
            f,
            row + 1,
            col + 1,
            free_count,
            height,
            width,
          )
        }
      }
    }
    False -> #(m, f, free_count, col)
  }
}

pub fn gauss_eliminate_rat(
  matrix: List(List(Rat)),
  free_cols: LB,
  height: Int,
  width: Int,
) -> #(List(List(Rat)), LB, Int) {
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

// ---------- Build reduced form ----------
pub fn reduced_form_rat(target: LI, buttons: LLI) -> #(List(List(Rat)), LB) {
  let mat0 = build_matrix_rat(target, buttons)
  let height = list.length(target)
  let width = list.length(buttons) + 1
  let free0 = list.repeat(False, width - 1)
  let #(mat, free_cols, _free_count) =
    gauss_eliminate_rat(mat0, free0, height, width)
  #(mat, free_cols)
}

// ---------- Back-substitution and press vector assembly ----------
pub fn find_lead_rows(mat: List(List(Rat))) -> List(#(Int, Int)) {
  list.index_map(mat, fn(row, r) {
    let lc = leading_col_rat(row)
    case lc {
      -1 -> []
      _ -> [#(lc, r)]
    }
  })
  |> list.flatten
}

pub fn row_for_col(lead_rows: List(#(Int, Int)), col: Int) -> Int {
  list.find(lead_rows, fn(pair) { pair.0 == col })
  |> fn(x) {
    case x {
      Ok(#(_, r)) -> r
      Error(_) -> -1
    }
  }
}

pub fn free_pos(free_ixs: LI, col: Int) -> Int {
  // returns the index k such that free_ixs[k] == col, or 0 if not found
  list.index_fold(free_ixs, 0, fn(acc, x, i) {
    case acc {
      // if already found, keep it
      0 ->
        case x == col {
          True -> i
          False -> 0
        }
      _ -> acc
    }
  })
}

pub fn compute_presses_from_rat(
  mat: List(List(Rat)),
  free_cols: LB,
  vars: LI,
) -> Result(LI, String) {
  let height = list.length(mat)
  let width = case height == 0 {
    True -> 0
    False -> list.length(nth_or(mat, 0, []))
  }
  let num_buttons = width - 1

  // indices of free columns
  let free_ixs =
    list.index_map(free_cols, fn(b, i) {
      case b {
        True -> [i]
        False -> []
      }
    })
    |> list.flatten

  let lead_rows = find_lead_rows(mat)

  let presses_res =
    list.range(0, num_buttons - 1)
    |> list.index_map(fn(_, col) {
      case nth_or(free_cols, col, False) {
        True -> {
          // find position of this free column in free_ixs using index_fold
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

              // sum contributions from free variables
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

  // detect any Error(...) inside presses_res
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

// ---------- Verification (integer) ----------
pub fn row_sums_int(buttons: LLI, presses: LI, height: Int) -> LI {
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

pub fn verify_solution(buttons: LLI, target: LI, presses: LI) -> Bool {
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

// ---------- Generate guesses (iterative) ----------

pub fn gen_ranges(max_try: Int) -> LI {
  list.range(0, max_try)
}

pub fn gen_guesses(free_count: Int, max_try: Int) -> List(LI) {
  let base: List(LI) = [[]]
  list.range(0, free_count - 1)
  |> list.fold(base, fn(acc, _) {
    let rng = gen_ranges(max_try)
    list.index_map(rng, fn(v, _) {
      list.index_map(acc, fn(t, _) { list.append([v], t) })
    })
    |> list.flatten
  })
}

// ---------- Minimizer ----------
pub fn minimize_presses_rat(
  mat: List(List(Rat)),
  free_cols: LB,
  max_try: Int,
  buttons: LLI,
  target: LI,
) -> LI {
  let free_ixs =
    list.index_map(free_cols, fn(b, i) {
      case b {
        True -> [i]
        False -> []
      }
    })
    |> list.flatten
  let free_count = list.length(free_ixs)

  let guesses = gen_guesses(free_count, max_try)

  let best =
    list.fold(guesses, Error(Nil), fn(acc, guess) {
      let vars = guess
      let res = compute_presses_from_rat(mat, free_cols, vars)
      case res {
        Ok(presses) -> {
          let nonneg = list.all(presses, fn(x) { x >= 0 })
          case nonneg {
            True -> {
              let ok = verify_solution(buttons, target, presses)
              case ok {
                True -> {
                  let total = list.fold(presses, 0, fn(acc, x) { acc + x })
                  case acc {
                    Ok(#(_best_press, best_sum)) ->
                      case total < best_sum {
                        True -> Ok(#(presses, total))
                        False -> acc
                      }
                    Error(_) -> Ok(#(presses, total))
                  }
                }
                False -> acc
              }
            }
            False -> acc
          }
        }
        Error(_) -> acc
      }
    })

  case best {
    Ok(#(presses, _)) -> presses
    Error(_) -> {
      echo #("no_valid_solution_found")
      list.repeat(0, list.length(free_cols))
    }
  }
}

pub fn matrix_inconsistent(mat: List(List(Rat))) -> Bool {
  let width = case mat {
    [] -> 0
    _ -> list.length(nth_or(mat, 0, []))
  }
  list.any(mat, fn(row) {
    // all coeffs zero but RHS nonzero
    let all_coeffs_zero =
      list.range(0, width - 2)
      |> list.all(fn(j) { rat_is_zero(nth_or(row, j, rat_zero())) })
    all_coeffs_zero && !rat_is_zero(nth_or(row, width - 1, rat_zero()))
  })
}

// ---------- Integer division helpers ----------
pub fn int_abs(x: Int) -> Int {
  int.absolute_value(x)
}

// Floor division (mathematical floor) for integers
pub fn div_floor(n: Int, d: Int) -> Int {
  case d == 0 {
    True -> 0
    False -> {
      case n >= 0 && d > 0 || n <= 0 && d < 0 {
        True -> n / d
        False -> {
          // trunc toward zero gave q = n / d; if remainder != 0, subtract 1
          let q = n / d
          case n % d == 0 {
            True -> q
            False -> q - 1
          }
        }
      }
    }
  }
}

// Ceil division (mathematical ceil) for integers
pub fn div_ceil(n: Int, d: Int) -> Int {
  case d == 0 {
    True -> 0
    False -> {
      let f = div_floor(n, d)
      case f * d == n {
        True -> f
        False -> f + 1
      }
    }
  }
}

pub fn compute_free_bounds(
  mat: List(List(Rat)),
  free_ixs: LI,
) -> List(#(Int, Int)) {
  let width = case mat {
    [] -> 0
    _ -> list.length(nth_or(mat, 0, []))
  }

  // ceil(|n/d|) = (|n| + |d| - 1) / |d|
  let ceil_abs = fn(n: Int, d: Int) {
    let an = int.absolute_value(n)
    let ad = int.absolute_value(d)
    case ad == 0 {
      True -> 0
      False -> { an + ad - 1 } / ad
    }
  }

  list.index_map(free_ixs, fn(fcol, _) {
    // per-row estimate: ceil(|rhs / coeff|)
    let estimates =
      list.map(mat, fn(row) {
        let #(cn, cd) = rat_to_nd(nth_or(row, fcol, rat_zero()))
        let #(rn, rd) = rat_to_nd(nth_or(row, width - 1, rat_zero()))
        case cn == 0 {
          True -> 0
          False -> {
            // rhs/coeff = (rn/rd) / (cn/cd) = (rn * cd) / (rd * cn)
            let num = rn * cd
            let den = rd * cn
            ceil_abs(num, den)
          }
        }
      })

    // take the largest estimate
    let max_est =
      list.fold(estimates, 0, fn(acc, v) {
        case v > acc {
          True -> v
          False -> acc
        }
      })

    // choose upper bound; if all estimates were 0 (e.g., zero RHS),
    // give a small room to explore
    let cap = 10_000
    let hi_pre = case max_est == 0 {
      True -> 100
      False -> max_est
    }
    let hi = case hi_pre > cap {
      True -> cap
      False -> hi_pre
    }

    #(0, hi)
  })
}

// ---------- Enumerate feasible free-variable tuples with pruning ----------

pub fn dfs_enumerate(
  mat: List(List(Rat)),
  free_cols: LB,
  buttons: LLI,
  target: LI,
  ranges: List(List(Int)),
  free_count: Int,
  congrs: List(#(Int, List(#(Int, Int)), Int)),
  idx: Int,
  partial: LI,
  best: Result(#(LI, Int), String),
) -> Result(#(LI, Int), String) {
  case idx == free_count {
    True -> {
      let res = compute_presses_from_rat(mat, free_cols, partial)
      case res {
        Ok(presses) -> {
          let nonneg = list.all(presses, fn(x) { x >= 0 })
          case nonneg {
            True -> {
              let ok = verify_solution(buttons, target, presses)
              case ok {
                True -> {
                  let total = list.fold(presses, 0, fn(acc, x) { acc + x })
                  case best {
                    Ok(#(_, bs)) ->
                      case total < bs {
                        True -> Ok(#(presses, total))
                        False -> best
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
      let rng = nth_or(ranges, idx, [])
      list.fold(rng, best, fn(best_acc, v) {
        let new_partial = list.append(partial, [v])
        case congruences_hold_partial(congrs, new_partial) {
          True ->
            dfs_enumerate(
              mat,
              free_cols,
              buttons,
              target,
              ranges,
              free_count,
              congrs,
              idx + 1,
              new_partial,
              best_acc,
            )
          False -> best_acc
        }
      })
    }
  }
}

pub fn enumerate_feasible_and_minimize(
  mat: List(List(Rat)),
  free_cols: LB,
  buttons: LLI,
  target: LI,
) -> LI {
  let free_ixs =
    list.index_map(free_cols, fn(b, i) {
      case b {
        True -> [i]
        False -> []
      }
    })
    |> list.flatten
  let free_count = list.length(free_ixs)

  case free_count == 0 {
    True ->
      case compute_presses_from_rat(mat, free_cols, []) {
        Ok(p) -> p
        Error(_) -> list.repeat(0, list.length(free_cols))
      }
    False -> {
      let bounds = compute_free_bounds(mat, free_ixs)
      let ranges =
        list.index_map(bounds, fn(b, _) {
          let lo = b.0
          let hi = b.1
          let cap = 10_000
          let hi_capped = case hi - lo > cap {
            True -> lo + cap
            False -> hi
          }
          list.range(lo, hi_capped)
        })

      let congrs = build_congruences(mat, free_ixs)

      // <<< add your debug echoes here >>>
      echo #("bounds", bounds)
      echo #("ranges_len", list.index_map(ranges, fn(r, _) { list.length(r) }))
      echo #("congruences", congrs)
      // <<< end debug echoes >>>

      case
        dfs_enumerate(
          mat,
          free_cols,
          buttons,
          target,
          ranges,
          free_count,
          congrs,
          0,
          [],
          Error("nil"),
        )
      {
        Ok(#(presses, _)) -> presses
        Error(_) -> {
          echo #("no_valid_solution_found")
          list.repeat(0, list.length(free_cols))
        }
      }
    }
  }
}

pub fn parse_input(path: String) -> List(Node) {
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
  use acc, x <- list.try_fold(lst, 0)
  let #(reduced, free_cols) = reduced_form_rat(x.target, x.buttons)
  echo #("inconsistent?", matrix_inconsistent(reduced))
  echo #("free_cols", free_cols)
  echo #("reduced", reduced)
  let sol =
    enumerate_feasible_and_minimize(reduced, free_cols, x.buttons, x.target)
  let total = list.fold(sol, 0, fn(acc, x) { acc + x })
  let ok = verify_solution(x.buttons, x.target, sol)
  case ok {
    True -> Ok(acc + total)
    False -> Error(x)
  }
}

// ---------- Example main ----------
pub fn main() {
  let con = parse_input("input/day10.txt")
  echo solution(con)
}

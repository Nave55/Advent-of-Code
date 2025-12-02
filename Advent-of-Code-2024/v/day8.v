import os
import tools as t
import datatypes as dt

const width := 50
const height := 50

fn main() {
	mat, ants := parse_file()
	slopes := ant_slopes(ants)
	pt1 := solution(mat, slopes)
	pt2 := solution2(slopes)
	println('Part 1: ${pt1}\nPart 2: ${pt2}')
}

fn parse_file() ([][]rune, map[rune][]t.Vec2[int])  {
	lines := os.read_lines('input/day8.txt') or { panic(err) }
	mut arr := [][]rune{len: height, cap: height, init: []rune{len: width, cap: width, init: `.`}}
	mut mp := map[rune][]t.Vec2[int]{}

	mut r_ind := 0
	for r_val in lines {
		for c_ind, c_val in r_val {
			arr[r_ind][c_ind] = c_val
			if c_val != `.` {
				mp[c_val] << t.Vec2[int]{r_ind, c_ind}
			}
		}
		r_ind++
	}
	
	return arr, mp
}

fn ant_slopes(ants map[rune][]t.Vec2[int]) map[string][]t.Vec2[int] {
	mut slopes := map[string][]t.Vec2[int]{}

	for value in ants.values() {
		for i in 0..value.len - 1 {
			for j in i+1..value.len {
				slopes[value[i].to_str()] << value[i] - value[j]
			}
		}
	}

	return slopes
}

fn solution(mat [][]rune, slopes map[string][]t.Vec2[int]) int {
	mut ttl := dt.Set[string]{}

	for key, value in slopes {
		for i in value {
			vec := t.str_to_vec2[int](key)
			symb := t.arr_value(mat, vec)
			pos := vec + i
			neg := vec - (i.mul_by_scalar(2))

			if t.in_bounds(pos, height, width) && t.arr_value(mat, pos) != symb {
				ttl.add(pos.to_str())
			}
			if t.in_bounds(neg, height, width) && t.arr_value(mat, neg) != symb {
				ttl.add(neg.to_str())
			}
		}
	}

	return ttl.size()
}

fn solution2(slopes map[string][]t.Vec2[int]) int {
	mut ttl := dt.Set[string]{};

	for key, value in slopes {
		ttl.add(key)
		for i in value {
			mut val := t.str_to_vec2[int](key)
			for {
				val = val + i
				if t.in_bounds(val, height, width) {
					ttl.add(val.to_str())
				} else {
					val = t.str_to_vec2[int](key)
					break
				}
			}
			for {
				val = val - i
				if t.in_bounds(val, height, width) {
					ttl.add(val.to_str())
				} else {
					break
				}
			}
		}
	}

	return ttl.size()
}

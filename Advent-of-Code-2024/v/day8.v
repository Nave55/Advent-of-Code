import os
import tools as t
import datatypes as dt

const width := 50
const height := 50

type Ants = map[rune][]t.Vec2[int]
type Slopes = map[string][]t.Vec2[int]
type Mat = [][]rune

fn main() {
	mat, ants := parse_file()
	slopes := ant_slopes(ants)
	pt1 := solution(mat, slopes)
	pt2 := solution2(slopes)
	println('Part 1: ${pt1}\nPart 2: ${pt2}')
}

fn parse_file() (Mat, Ants)  {
	lines := os.read_lines('input/day8.txt') or { panic(err) }
	mut arr := Mat{len: height, cap: height, init: []rune{len: width, cap: width, init: `.`}}
	mut mp := Ants{}

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

fn ant_slopes(ants Ants) Slopes {
	mut slopes := Slopes{}

	for value in ants.values() {
		for i in 0..value.len - 1 {
			for j in i+1..value.len {
				slopes[value[i].to_str()] << value[i] - value[j]
			}
		}
	}

	return slopes
}

fn insert_set[T](pos t.Vec2[T], mat Mat, mut set dt.Set[string], symb rune) {
	if t.in_bounds(pos, height, width) && t.arr_value(mat, pos) != symb {
		set.add(pos.to_str())
	}
}

fn solution(mat Mat, slopes Slopes) int {
	mut ttl := dt.Set[string]{}

	for key, value in slopes {
		for i in value {
			vec := t.str_to_vec2[int](key)
			symb := t.arr_value(mat, vec)
			pos := vec + i
			neg := vec - (i.mul_by_scalar(2))
			
			insert_set(pos, mat, mut ttl, symb)
			insert_set(neg, mat, mut ttl, symb)
		}
	}

	return ttl.size()
}

fn walk(start t.Vec2[int], step t.Vec2[int], mut acc dt.Set[string]) {
	mut pos := start
	for {
		pos = pos + step
		if t.in_bounds(pos, height, width) {
			acc.add(pos.to_str())
		} else {
			break
		}
	}
}

fn solution2(slopes Slopes) int {
	mut ttl := dt.Set[string]{};

	for key, value in slopes {
		ttl.add(key)
		for i in value {
			val := t.str_to_vec2[int](key)
			walk(val, i, mut ttl)
			walk(val, i.neg(), mut ttl)
		}
	}

	return ttl.size()
}

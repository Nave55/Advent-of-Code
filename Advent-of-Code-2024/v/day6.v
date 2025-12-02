import os
import tools as t
import datatypes { Set }

type VI = t.Vec2[int]

const rows = 130
const cols = 130
const dirs = [
	VI{-1, 0},
	VI{0, 1},
	VI{1, 0},
	VI{0, -1},
]

fn main() {
	mut mat, mut empty, start := parse_file()!
	pt1, mut visited := solution1(mat, start)
	pt2 := solution2(mut mat, start, mut empty, mut visited)!

	println('Part 1: ${pt1}\nPart 2: ${pt2}')
}

fn parse_file() !([][]rune, map[string]int, VI) {
	lines := os.read_lines('input/day6.txt')!
	mut locs := map[string]int{}
	mut arr := [][]rune{len: rows, cap: rows, init: []rune{len: cols, cap: cols, init: `.`}}
	mut start := VI{}

	for r_ind, r_val in lines {
		for c_ind, c_val in r_val {
			arr[r_ind][c_ind] = lines[r_ind][c_ind]
			if c_val == `^` {
				start = VI{r_ind, c_ind}
			}
			if c_val == `#` {
				locs[r_ind.str() + ',' + c_ind.str()] = 0
			}
		}
	}

	return arr, locs, start
}

fn inbounds(pos VI) bool {
	return pos.x > 0 && pos.x < rows - 1 && pos.y > 0 && pos.y < cols - 1
}

fn solution1(mat [][]rune, start VI) (int, Set[string]) {
	mut facing := 0
	mut pos := start
	mut visited := Set[string]{}

	for inbounds(pos) {
		next_pos := pos + dirs[facing]
		if t.arr_value(mat, next_pos) == `#` {
			facing += 1
			facing = facing % 4
		} else {
			visited.add(pos.to_str())
			pos = next_pos
		}
	}

	visited.add(pos.to_str())

	return visited.size(), visited
}

fn solution2(mut mat [][]rune, start VI, mut locs map[string]int, mut empty Set[string]) !int {
	mut ttl := 0
	for !empty.is_empty() {
		v := string(empty.pop() or { break })
		v_pos := t.str_to_vec2[int](v)
		mut facing := 0
		mut pos := start
		mat[v_pos.x][v_pos.y] = `#`
		locs[v] = 0

		for inbounds(pos) {
			next_pos := pos + dirs[facing]
			if t.arr_value(mat, next_pos) == `#` {
				str_pos := next_pos.to_str()
				facing += 1
				locs[str_pos] += 1
				if locs[str_pos] == 4 {
					ttl++
					break
				}
				facing = facing % 4
			} else {
				pos = next_pos
			}
		}
		mat[v_pos.x][v_pos.y] = `.`
		locs.delete(v)
		for i in locs.keys() {
			locs[i] = 0
		}
	}

	return ttl
}

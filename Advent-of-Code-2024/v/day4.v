import os
import tools as t

fn main() {
	pt1, pt2 := solution()!
	println('Part 1: ${pt1}\nPart 2: ${pt2}')
}

fn solution() !(int, int) {
	lines := os.read_lines('input/day4.txt')!
	mut arr := [][]rune{}

	for v in lines {
		arr << v.runes()
	}

	return check_xmas(arr), check_x(arr)
}

fn check_xmas(mat [][]rune) int {
	width := mat[0].len
	height := mat.len

	dirs := [
		t.Vec2[int]{-3, -3},
		t.Vec2{-2, -2},
		t.Vec2{-1, -1},
		t.Vec2{-3, 3},
		t.Vec2{-2, 2},
		t.Vec2{-1, 1},
		t.Vec2{3, -3},
		t.Vec2{2, -2},
		t.Vec2{1, -1},
		t.Vec2{3, 3},
		t.Vec2{2, 2},
		t.Vec2{1, 1},
		t.Vec2{-3, 0},
		t.Vec2{-2, 0},
		t.Vec2{-1, 0},
		t.Vec2{3, 0},
		t.Vec2{2, 0},
		t.Vec2{1, 0},
		t.Vec2{0, -3},
		t.Vec2{0, -2},
		t.Vec2{0, -1},
		t.Vec2{0, 3},
		t.Vec2{0, 2},
		t.Vec2{0, 1},
	]

	mut ttl := 0
	for r_ind, r_val in mat {
		for c_ind, c_val in r_val {
			if c_val != `X` {
				continue
			}
			mut str := []rune{}
			mut cnt := 0
			for val in dirs {
				cnt++
				tmp := val + t.Vec2{r_ind, c_ind}
				if t.in_bounds(tmp, height, width) {
					str << rune(t.arr_value(mat, tmp))
				}
				if cnt % 3 == 0 {
					str << `X`
					s := str.string()
					if s == 'XMAS' || s == 'SAMX' {
						ttl += 1
					}
					str.clear()
				}
			}
		}
	}

	return ttl
}

fn check_x(mat [][]rune) int {
	mut ttl := int(0)
	for r_ind, r_val in mat {
		for c_ind, c_val in r_val {
			if c_val != `A` {
				continue
			}
			_, vals := t.nbrs(mat, t.Vec2{r_ind, c_ind}, t.Dirs.diags)
			tmp := vals.string()
			if tmp in ['MMSS', 'SSMM', 'SMSM', 'MSMS'] {
				ttl++
			}
		}
	}

	return ttl
}

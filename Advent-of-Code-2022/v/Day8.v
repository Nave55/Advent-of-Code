import os
import arrays { max }

fn main() {
	lines := os.read_lines('input/Day8_2022.txt')!
	solution(lines)!
}

fn solution(s []string) ! {
	mut count := int((s.len * 4) - 4)
	mut scores := []int{}

	for rows in 1 .. s.len - 1 {
		for cols in 1 .. s.len - 1 {
			pos := u8(s[rows][cols])
			mut left := []u8{}
			mut right := []u8{}
			mut top := []u8{}
			mut bottom := []u8{}

			for i in 1 .. cols + 1 {
				left << s[rows][cols - i]
			}
			for i in 1 .. s.len - cols {
				right << s[rows][cols + i]
			}
			for i in 1 .. rows + 1 {
				top << s[rows - i][cols]
			}
			for i in 1 .. s.len - rows {
				bottom << s[rows + i][cols]
			}

			if max(left)! < pos || max(right)! < pos || max(top)! < pos || max(bottom)! < pos {
				count++
			}

			mut score := 1
			for lst in [left, right, top, bottom] {
				mut tracker := 0
				for i in 0 .. lst.len {
					if lst[i] < pos {
						tracker += 1
					} else if lst[i] == pos {
						tracker += 1
						break
					} else {
						break
					}
				}

				score *= tracker
				scores << score
			}
		}
	}
	println('Part 1: ${count}\nPart 2: ${max(scores)!}')
}

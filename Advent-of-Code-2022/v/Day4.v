import os
import tools

fn main() {
	mut arr := [][]int{}
	mut lines := os.read_lines('input/Day4_2022.txt')!
	for i in 0 .. lines.len {
		lines[i] = lines[i].replace('-', ',')
		arr << lines[i].split(',').map(it.int())
	}
	mut ttl1 := 0
	mut ttl2 := 0

	for i in arr {
		mut set1 := tools.Set{[]int{len: i[1] - i[0] + 1, cap: i[1] - i[0] + 1, init: index + i[0]}}
		mut set2 := tools.Set{[]int{len: i[3] - i[2] + 1, cap: i[3] - i[2] + 1, init: index + i[2]}}

		s_len := int((set1 * set2).len)
		if s_len == set1.arr.len || s_len == set2.arr.len {
			ttl1++
		}
		if s_len > 0 {
			ttl2++
		}
	}

	println('Part 1: ${ttl1}\nPart 2: ${ttl2}')
}

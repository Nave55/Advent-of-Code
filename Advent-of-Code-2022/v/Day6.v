import os
import arrays

fn main() {
	input := os.read_lines('input/Day6_2022.txt')![0].split('')
	pt1 := solution(4, input)!
	pt2 := solution(14, input)!
	println('Part 1: ${pt1}\nPart 2: ${pt2}')
}

fn solution(window int, input []string) !int {
	for i in 0 .. input.len - window - 1 {
		if arrays.distinct(input[i..i + window]).len == window {
			return i + window
		}
	}
	return error('No solution found')
}

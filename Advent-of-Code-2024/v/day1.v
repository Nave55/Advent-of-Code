import os
import math

fn main() {
	a, b := parse_file()!
	pt1, pt2 := solution(a, b)
	println('Part 1: ${pt1}\nPart 2: ${pt2}')
}

fn parse_file() !([]int, []int) {
	lines := os.read_lines('input/day1.txt')!
	mut left := []int{len: lines.len, cap: lines.len, init: 0}
	mut right := []int{len: lines.len, cap: lines.len, init: 0}

	for i, v in lines {
		tmp := v.split('   ').map(it.int())
		left[i] = tmp[0]
		right[i] = tmp[1]
	}

	left.sort(a < b)
	right.sort(a < b)

	return left, right
}

fn solution(left []int, right []int) (int, int) {
	mut sum := 0
	mut sum2 := 0
	mut l_map := map[int]int{}

	for i in left {
		l_map[i] = 0
	}

	for i in 0 .. left.len {
		sum += math.abs(left[i] - right[i])
		if right[i] in l_map {
			sum2 += right[i]
		}
	}

	return sum, sum2
}

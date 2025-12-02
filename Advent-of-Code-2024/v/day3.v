import os
import regex

fn main() {
	solution(parse_file()!)
}

fn parse_file() ![][]int {
	mut re := regex.regex_opt(r"(mul\((\d+),(\d+)\))|(do(n't)?\(\))")!
	file := os.read_file('input/day3.txt')!
	res := re
		.find_all_str(file)
		.join('|')
		.replace('mul', '')
		.replace('do()', '1')
		.replace("don't()", '0')
		.replace('(', '')
		.replace(')', '')
		.split('|')
		.map(it.split(',').map(it.int()))

	return res
}

fn solution(arr [][]int) {
	mut mul := true
	mut pt1 := 0
	mut pt2 := 0

	for i in arr {
		if i.len == 1 {
			mul = if i[0] == 1 { true } else { false }
		} else {
			pt1 += i[0] * i[1]
			if mul {
				pt2 += i[0] * i[1]
			}
		}
	}
	println('Part 1: ${pt1}\nPart 2: ${pt2}')
}
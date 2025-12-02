import os

struct FileInfo {
mut:
	val  int
	pos  int
	size int
}

type AI = []int
type AFI = []FileInfo

fn main() {
	mut arr, mut filled, mut empty := parse_file()
	pt1 := solution(mut arr)
	pt2 := solution_two(mut filled, mut empty)
	println('Part 1: ${pt1}\nPart 2: ${pt2}')
}

fn parse_file() (AI, AFI, AFI) {
	mut lines := os.read_file('input/day9.txt') or { panic(err) }
	mut arr, mut filled, mut empty := AI{}, AFI{}, AFI{}
	mut pos, mut idx := 0, 0

	for ind, ch in lines {
		times := int(ch - `0`)
		if ind % 2 == 0 {
			for _ in 0 .. times {
				arr << pos
			}
			if times > 0 {
				filled << FileInfo{pos, idx, times}
				pos++
			}
		} else {
			for _ in 0 .. times {
				arr << -1
			}
			if times > 0 {
				empty << FileInfo{-1, idx, times}
			}
		}
		idx += times
	}

	return arr, filled, empty
}

fn solution(mut arr AI) i64 {
	mut ttl := i64(0)
	mut j := arr.len - 1

	for i in 0 .. arr.len {
		if arr[i] == -1 {
			for j > i && arr[j] < 0 {
				j--
			}
			if j <= i {
				break
			}
			arr[i] = arr[j]
			arr[j] = -1
		}
		if arr[i] >= 0 { 
			ttl += i64(i) * i64(arr[i]) 
		}
	}
	return ttl
}

fn solution_two(mut filled AFI, mut empty AFI) i64 {
	mut ttl := i64(0)
	
	for i := filled.len - 1; i > 0; i-- {
		for mut e_val in empty {
			if filled[i].pos <= e_val.pos {
				break
			}
			if filled[i].size <= e_val.size {
				filled[i].pos = e_val.pos
				e_val.size -= filled[i].size
				e_val.pos += filled[i].size
				break
			}
		}
	}

	for i in filled {
		for ind in i.pos .. i.pos + i.size {
			ttl += i.val * ind
		}
	}

	return ttl
}

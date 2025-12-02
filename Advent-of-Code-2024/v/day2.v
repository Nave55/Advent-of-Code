import os

fn main() {
	pt1, pt2 := solution()!
	println('Part 1: ${pt1}\nPart 2: ${pt2}')
}

fn solver(arr []int, n int, pt1 bool) int {
	if n == arr.len {
		return 0
	}

	mut tmp := arr.clone()
	if !pt1 {
		tmp.delete(n)
	}
	p := if tmp.len > 1 { tmp[0] - tmp[1] } else { 0 }
	for j in 1 .. tmp.len {
		dist := tmp[j - 1] - tmp[j]
		if p >= 0 {
			if dist > 3 || dist <= 0 {
				if pt1 {
					return 0
				}
				break
			}
			if j == tmp.len - 1 {
				return 1
			}
		} else if p <= 0 {
			if dist < -3 || dist >= 0 {
				if pt1 {
					return 0
				}
				break
			}
			if j == tmp.len - 1 {
				return 1
			}
		} 
	}

	return solver(arr, n + 1, false)
}

fn solution() !(int, int) {
	lines := os.read_lines('input/day2.txt')!
	mut sum1 := 0
	mut sum2 := 0

	for v in lines {
		tmp := v.split(' ').map(it.int())

		sum1 += solver(tmp, 0, true)
		sum2 += solver(tmp, 0, false)
	}

	return sum1, sum2
}

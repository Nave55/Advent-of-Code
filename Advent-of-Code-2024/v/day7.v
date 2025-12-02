import os

fn main() {
	targets, nums := parse_file()
	pt1, pt2 := solution(targets, nums)
	println('Part 1: ${pt1}\nPart 2: ${pt2}')
}

fn parse_file() ([]i64, [][]i64) {
	lines := os.read_lines('input/day7.txt') or { panic(err) }
	mut targets := []i64{len: 850, cap: 850, init: 0}
	mut nums := [][]i64{len: 850, cap: 850, init: []i64{len: 0, cap: 12}} 

	mut ind := 0
	for i in lines {
		tmp := i.replace(" ", ",").split(":,")
		targets[ind] = tmp[0].i64()
		nums[ind] = tmp[1].split(",").map(it.i64())

		ind++
	}

	return targets, nums
}

fn concat(a i64, b i64) i64 {
	return "${a}${b}".i64()
}

fn evaluate(nums []i64, target i64, index i64, currentVal i64, pt1 bool) bool {
	if index == 0 {
		return evaluate(nums, target, index + 1, nums[0], pt1)
	}

	if index == nums.len {
		return currentVal == target
	}

	num := nums[index]

	if evaluate(nums, target, index + 1, currentVal + num, pt1) {
		return true
	}
	if evaluate(nums, target, index + 1, currentVal * num, pt1) {
		return true
	}
	if !pt1 && evaluate(nums, target, index + 1, concat(currentVal, num), pt1) {
		return true
	}
	return false
}

fn solution(a []i64, b [][]i64) (i64, i64) {
	mut ttl := i64(0)
	mut ttl2 := i64(0)

	for ind, vals in b {
		if evaluate(vals, a[ind], 0, 0, true) {
			ttl += a[ind]
		}
		if evaluate(vals, a[ind], 0, 0, false) {
			ttl2 += a[ind]
		}
	}
	return ttl, ttl2
}

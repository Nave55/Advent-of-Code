import os

fn main() {
	pt1, pt2 := solution()
	println('Part 1: ${pt1}\nPart 2: ${pt2}')
}

fn parse_file() ([][]int, map[int][]int) {
	lines := os.read_lines('input/day5.txt') or { panic(err) }
	mut arr := [][]int{}
	mut mp := map[int][]int{}

	for i in lines {
		if i.len > 0 {
			if i.contains("|") {
				tmp := i.split("|").map(it.int())
				mp[tmp[0]] << tmp[1]
			}
			if i.contains(",") {
				tmp := i.split(",").map(it.int())
				arr << tmp
			}
		}
	}
	
	return arr, mp
}

fn sort_arr(mut arr []int, mp map[int][]int) ([]int, bool) {
	mut sorted := false
	mut no_changes := true

	for !sorted {
		sorted = true
		for i in arr {
			for k in mp[i] {
				i_pos := arr.index(i)
				k_pos := arr.index(k)
				if k_pos != -1 && i_pos > k_pos {
					tmp := arr[i_pos]
					arr[i_pos] = arr[k_pos]
					arr[k_pos] = tmp
					sorted = false
					no_changes = false
				}
			}
		}
	}
	return arr, no_changes
}

fn solution() (int, int) {
	mut mat, mp := parse_file()
	mut pt1 := 0
	mut pt2 := 0

	for mut i in mat {
		vals, is_sorted := sort_arr(mut i, mp)
		n := int((vals.len - 1) / 2)
		if is_sorted {
			pt1 += vals[n]
		} else {
			pt2 += vals[n]
		}
	}

	return pt1, pt2
}


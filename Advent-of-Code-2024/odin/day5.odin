package AoC

import "../Tools"
import sa "core:container/small_array"
import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

mp: map[int][dynamic]int
arr: [dynamic][]int

main :: proc() {
	defer {
		for i in arr do delete(i)
		for i, k in mp do delete(k)
		delete(mp)
		delete(arr)
	}
	parseInput("input/day5.txt")
	pt1, pt2 := solution()
	fmt.printfln("Part 1: %v\nPart 2: %v", pt1, pt2)

}

parseInput :: proc(filepath: string) {
	data, ok := os.read_entire_file(filepath)
	if !ok do return
	it := string(data)
	defer delete(data)

	for line in strings.split_lines_iterator(&it) {
		using strconv
		defer free_all(context.temp_allocator)
		if line != "" && strings.contains(line, "|") {
			split := strings.split(line, "|", context.temp_allocator)
			left, right := atoi(split[0]), atoi(split[1])
			if len(mp[left]) == 0 do mp[left] = {}
			append(&mp[left], right)
		}
		if line != "" && strings.contains(line, ",") {
			tmp_arr: sa.Small_Array(25, int)
			split := strings.split(line, ",", context.temp_allocator)
			for i in split do sa.append(&tmp_arr, atoi(i))
			l := slice.clone(sa.slice(&tmp_arr))
			append(&arr, l)
		}
	}
}

sortArr :: proc(sli: []int) -> (current: []int, no_changes: bool = true) {
	sorted := false
	current = sli

	for !sorted {
		sorted = true
		for i in current {
			if i in mp {
				for k in mp[i] {
					i_pos, _ := slice.linear_search(current[:], i)
					k_pos, _ := slice.linear_search(current[:], k)
					if k_pos != -1 && i_pos > k_pos {
						current[i_pos], current[k_pos] = current[k_pos], current[i_pos]
						sorted = false
						no_changes = false
					}
				}
			}
		}
	}
	return
}

solution :: proc() -> (pt1: int, pt2: int) {
	for i in arr {
		tmp, sorted := sortArr(i)
		n := int((len(tmp) - 1) / 2)
		if sorted do pt1 += tmp[n]
		else do pt2 += tmp[n]
	}
	return
}


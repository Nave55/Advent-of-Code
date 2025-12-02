package main

import sa "core:container/small_array"
import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

main :: proc() {
	pt1, pt2 := solution("input/day2.txt")
	fmt.printf("Part 1 = %v\nPart 2 = %v\n", pt1, pt2)
}

check_safety :: proc(arr: sa.Small_Array(10, int)) -> bool {
	n := sa.len(arr)
	if n <= 1 do return true

	is_inc_safe, is_dec_safe := true, true
	for i in 0 ..< n - 1 {
		if !is_inc_safe && !is_dec_safe do break
		val := sa.get(arr, i) - sa.get(arr, i + 1)
		if is_inc_safe do is_inc_safe = val >= 1 && val <= 3
		if is_dec_safe do is_dec_safe = val <= -1 && val >= -3
	}

	return is_dec_safe || is_inc_safe
}

check_safety_two :: proc(arr: sa.Small_Array(10, int)) -> bool {
	if check_safety(arr) do return true

	for i in 0 ..< sa.len(arr) {
		tmp := arr
		sa.ordered_remove(&tmp, i)
		if check_safety(tmp) do return true
	}

	return false
}

solution :: proc(filepath: string) -> (pt1, pt2: int) {
	free_all(context.temp_allocator)
	data, ok := os.read_entire_file(filepath, context.temp_allocator)
	if !ok do return
	it := string(data)

	for line in strings.split_lines_iterator(&it) {
		s_arr: sa.Small_Array(10, int)
		tmp := strings.split(line, " ", context.temp_allocator)
		for i in tmp do sa.append(&s_arr, strconv.atoi(i))

		if check_safety(s_arr) do pt1 += 1
		if check_safety_two(s_arr) do pt2 += 1
	}

	return
}


package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

Set :: bit_set[0 ..= 99]

main :: proc() {
	solution("input/Day4_2022.txt")
}

solution :: proc(filepath: string) {
	data, ok := os.read_entire_file_from_path(filepath, context.temp_allocator)
	if ok != nil do return

	it := string(data)
	it, _ = strings.replace_all(it, "-", ",", context.temp_allocator)
	arr := make([dynamic][]string, context.temp_allocator)

	for line in strings.split_lines_iterator(&it) {
		sp, _ := strings.split(line, ",", context.temp_allocator)
		append(&arr, sp)
	}

	ttl1, ttl2: int

	for i in arr {
		set1, set2: Set
		zero, _ := strconv.parse_int(i[0])
		one, _ := strconv.parse_int(i[1])
		two, _ := strconv.parse_int(i[2])
		three, _ := strconv.parse_int(i[3])

		for j in zero ..= one do set1 += {j}
		for j in two ..= three do set2 += {j}
		iset := set1 + set2
		if iset == set1 || iset == set2 do ttl1 += 1
		if card(set1 & set2) > 0 do ttl2 += 1
	}
	fmt.printf("Part 1: %v\nPart 2: %v\n", ttl1, ttl2)
}

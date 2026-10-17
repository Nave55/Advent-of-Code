package AoC

import "../Tools"
import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

main :: proc() {
	solution("input/day3.txt")
}

solution :: proc(filepath: string) {
	RE :: "mul\\((\\d+,\\d+)\\)|don't\\(\\)|do\\(\\)"
	data, ok := os.read_entire_file(filepath, context.temp_allocator)
	if ok != nil do return

	it := string(data)
	pt1, pt2, mul := 0, 0, true
	arr, _ := Tools.regexFindAll(it, RE)

	for i in &arr {
		if rune(i[0]) == 'd' do mul = i == "do()" ? true : false
		else {
			tmp := strings.split(i[4:len(i) - 1], ",", context.temp_allocator)
			parsed: [2]int = {strconv.parse_int(tmp[0]) or_break, strconv.parse_int(tmp[1]) or_break}
			pt1 += parsed.x * parsed.y
			if mul do pt2 += parsed.x * parsed.y
		}
	}

	fmt.printfln("Part 1: %v\nPart 2: %v", pt1, pt2)
}

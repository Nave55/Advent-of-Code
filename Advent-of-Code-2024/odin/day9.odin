package day9

import "core:fmt"
import "core:os"

file_info :: struct {
	val:  int,
	pos:  int,
	size: int,
}

main :: proc() {
	data, filled, empty := parse_file("input/day9.txt")
	pt1 := solve(&data)
	pt2 := solveTwo(&filled, &empty)
	fmt.printfln("Part 1: %v\nPart 2: %v", pt1, pt2)
}

parse_file :: proc(
	filepath: string,
) -> (
	arr: [dynamic]int,
	filled: [dynamic]file_info,
	empty: [dynamic]file_info,
) {
	data := os.read_entire_file(filepath, context.temp_allocator) or_else panic("Failed to Read File")
	it := string(data)

	filled = make([dynamic]file_info, context.temp_allocator)
	empty = make([dynamic]file_info, context.temp_allocator)

	pos, idx := 0, 0
	for i, ind in it {
		times := int(i) - int('0')
		if ind % 2 == 0 {
			for _ in 0 ..< times do append(&arr, pos)
			if times > 0 {
				append(&filled, file_info{pos, idx, times})
				pos += 1
			}
		} else {
			for _ in 0 ..< times do append(&arr, -1)
			if times > 0 {
				append(&empty, file_info{-1, idx, times})
			}
		}
		idx += times
	}

	return
}

solve :: proc(arr: ^[dynamic]int) -> (ttl: int) {
	j := len(arr) - 1

	for i in 0 ..< len(arr) {
		if arr[i] == -1 {
			for j > i && arr[j] < 0 do j -= 1
			if j <= i do break
			arr[i], arr[j] = arr[j], arr[i]
		}
		if arr[i] >= 0 do ttl += i * arr[i]
	}

	return ttl
}

solveTwo :: proc(
	filled: ^[dynamic]file_info,
	empty: ^[dynamic]file_info,
) -> (
	ttl: int,
) {
	#reverse for &f_val in filled {
		for &e_val in empty {
			if f_val.pos <= e_val.pos do break
			if f_val.size <= e_val.size {
				f_val.pos = e_val.pos
				e_val.size -= f_val.size
				e_val.pos += f_val.size
				break
			}
		}
	}

	for &i in filled {
		for ind in i.pos ..< i.pos + i.size {
			ttl += i.val * ind
		}
	}

	return ttl
}


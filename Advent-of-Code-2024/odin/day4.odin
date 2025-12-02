package AoC

import "../Tools"
import sa "core:container/small_array"
import "core:fmt"
import "core:mem"
import vm "core:mem/virtual"
import "core:os"
import "core:strings"
import "core:unicode/utf8"

main :: proc() {
	arena: vm.Arena
	err := vm.arena_init_static(&arena, 5 * mem.Megabyte)
	assert(err == .None)
	arena_allocator := vm.arena_allocator(&arena)
	context.allocator = arena_allocator
	defer vm.arena_destroy(&arena)

	pt1, pt2, ok := solution("input/day4.txt")
	if ok do fmt.printfln("Part 1: %v\nPart 2: %v", pt1, pt2)
	else do fmt.println("Bad File Path")
}

DIRS: [][2]int : {
	{-3, -3},
	{-2, -2},
	{-1, -1},
	{-3, 3},
	{-2, 2},
	{-1, 1},
	{3, -3},
	{2, -2},
	{1, -1},
	{3, 3},
	{2, 2},
	{1, 1},
	{-3, 0},
	{-2, 0},
	{-1, 0},
	{3, 0},
	{2, 0},
	{1, 0},
	{0, -3},
	{0, -2},
	{0, -1},
	{0, 3},
	{0, 2},
	{0, 1},
}

solution :: proc(filepath: string) -> (pt1, pt2: u32, ok: bool) {
	data := os.read_entire_file(filepath) or_return
	it := string(data)

	arr: [140][]rune
	ind := 0
	for line in strings.split_lines_iterator(&it) {
		tmp := utf8.string_to_runes(line)
		arr[ind] = tmp
		ind += 1
	}

	return checkXmas(arr[:]), checkX(arr[:]), true
}

checkXmas :: proc(mat: [][]rune) -> (ttl: u32) {
	width, height := len(mat[0]), len(mat)

	for r_val, r_ind in mat {
		for c_val, c_ind in r_val {
			if c_val != 'X' do continue
			str: sa.Small_Array(4, rune)
			group := 0
			for val in DIRS {
				tmp: [2]int = {val.x, val.y} + {r_ind, c_ind}
				if (tmp.x >= 0 && tmp.x < height) &&
				   (tmp.y >= 0 && tmp.y < width) {
					sa.append(&str, rune(mat[tmp.x][tmp.y]))
				}
				group += 1
				if group == 3 {
					sa.append(&str, 'X')
					s := utf8.runes_to_string(sa.slice(&str))
					if s == "XMAS" || s == "SAMX" do ttl += 1
					sa.clear(&str)
					group = 0
				}
			}
		}
	}

	return
}

checkX :: proc(mat: [][]rune) -> (ttl: u32) {
	for r_val, r_ind in mat {
		for c_val, c_ind in r_val {
			if c_val != 'A' do continue
			_, vals := Tools.nbrs(mat, [2]int{r_ind, c_ind}, .Diags)
			tmp := utf8.runes_to_string(sa.slice(&vals))
			if tmp == "MMSS" || tmp == "SSMM" || tmp == "SMSM" || tmp == "MSMS" do ttl += 1
		}
	}
	return
}


package tools

import sa "core:container/small_array"
import "core:text/regex"

Dirs :: enum {
	Udlr,
	Diags,
	All,
}

inboundsSlice :: proc(mat: [][]$T, pos: [2]int) -> bool {
	return pos.x >= 0 && pos.x < len(mat) && pos.y >= 0 && pos.y < len(mat[0])
}

inboundsFixed :: proc(mat: [$N][$M]$T, pos: [2]int) -> bool {
	return pos.x >= 0 && pos.x < len(mat) && pos.y >= 0 && pos.y < len(mat[0])
}

inboundsWH :: proc(pos: [2]$T, width, height: T) -> bool {
	return pos.x >= 0 && pos.x < height && pos.y >= 0 && pos.y < width
}

inbounds :: proc {
	inboundsFixed,
	inboundsSlice,
	inboundsWH,
}

arrValueSlice :: proc(mat: [][]$T, pos: [2]int) -> T {
	return mat[pos.x][pos.y]
}

arrValueFixed :: proc(mat: [$N][$M]$T, pos: [2]int) -> T {
	return mat[pos.x][pos.y]
}

arrValue :: proc {
	arrValueFixed,
	arrValueSlice,
}

getDirsSlice :: proc(
	mat: [][]$T,
	arr: [][2]int,
	pos: [2]int,
) -> (
	inds: sa.Small_Array(8, [2]int),
	vals: sa.Small_Array(8, T),
) {

	for i in arr {
		n_pos := i + pos
		if inbounds(mat, n_pos) {
			sa.append(&inds, n_pos)
			sa.append(&vals, arrValue(mat, n_pos))
		}
	}

	return
}

getDirsFixed :: proc(
	mat: [$N][$M]$T,
	arr: [][2]int,
	pos: [2]int,
) -> (
	inds: sa.Small_Array(8, [2]int),
	vals: sa.Small_Array(8, T),
) {

	for i in arr {
		n_pos := i + pos
		if inbounds(mat, n_pos) {
			sa.append(&inds, n_pos)
			sa.append(&vals, arrValue(mat, n_pos))
		}
	}

	return
}

getDirs :: proc {
	getDirsFixed,
	getDirsSlice,
}

nbrsSlice :: proc(
	mat: [][]$T,
	pos: [2]int,
	dirs: Dirs,
) -> (
	inds: sa.Small_Array(8, [2]int),
	vals: sa.Small_Array(8, T),
) {
	udlr := [][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
	diags := [][2]int{{-1, -1}, {-1, 1}, {1, -1}, {1, 1}}
	all := [][2]int {
		{-1, -1},
		{-1, 0},
		{-1, 1},
		{0, -1},
		{0, 1},
		{1, -1},
		{1, 0},
		{1, 1},
	}

	switch dirs {
	case .All:
		return getDirs(mat, all[:], pos)
	case .Udlr:
		return getDirs(mat, udlr[:], pos)
	case .Diags:
		return getDirs(mat, diags[:], pos)
	}

	return
}

nbrsFixed :: proc(
	mat: [$N][$M]$T,
	pos: [2]int,
	dirs: Dirs,
) -> (
	inds: sa.Small_Array(8, [2]int),
	vals: sa.Small_Array(8, T),
) {
	udlr := [][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
	diags := [][2]int{{-1, -1}, {-1, 1}, {1, -1}, {1, 1}}
	all := [][2]int {
		{-1, -1},
		{-1, 0},
		{-1, 1},
		{0, -1},
		{0, 1},
		{1, -1},
		{1, 0},
		{1, 1},
	}

	switch dirs {
	case .All:
		return getDirs(mat, all[:], pos)
	case .Udlr:
		return getDirs(mat, udlr[:], pos)
	case .Diags:
		return getDirs(mat, diags[:], pos)
	}

	return
}

nbrs :: proc {
	nbrsFixed,
	nbrsSlice,
}

regexFindAll :: proc(str, pattern: string) -> (arr: [dynamic]string) {
	re, _ := regex.create(pattern, {}, context.temp_allocator)

	iterator, err := regex.create_iterator(str, pattern)
	defer regex.destroy_iterator(iterator)

	if err != nil do return

	numbers := make([dynamic]int)

	for {
		capture, _ := regex.match_iterator(&iterator) or_break
		append(&arr, capture.groups[0])
	}

	return
}

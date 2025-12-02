package day9

import tl "../Tools"
import sa "core:container/small_array"
import "core:fmt"
import "core:mem"
import vm "core:mem/virtual"
import "core:os"
import "core:strings"

ROWS :: 50
COLS :: 50

main :: proc() {
	arena: vm.Arena
	err := vm.arena_init_static(&arena, 5 * mem.Megabyte)
	assert(err == .None)
	arena_allocator := vm.arena_allocator(&arena)
	context.allocator = arena_allocator
	defer vm.arena_destroy(&arena)

	arr, ok := parse_file("input/day10.txt")
	assert(ok)
	pt1, pt2 := solution(arr)
	fmt.printfln("Part 1: %v\nPart 2: %v", pt1, pt2)
}

parse_file :: proc(
	filepath: string,
) -> (
	arr: [ROWS][COLS]int,
	ok: bool = true,
) {
	data := os.read_entire_file(filepath) or_return
	it := string(data)

	r_ind := 0
	for row in strings.split_lines_iterator(&it) {
		for col, c_ind in row {
			arr[r_ind][c_ind] = int(rune(col) - '0')
		}
		r_ind += 1
	}

	return
}

bfs :: proc(
	mat: [ROWS][COLS]int,
	pos: [2]int,
	visited: ^map[[2]int]struct {},
	target: int,
) -> (
	ttl: int,
) {
	defer free_all(context.temp_allocator)
	l_visited := make(map[[2]int]struct {}, context.temp_allocator)
	queue := make([dynamic][2]int, context.temp_allocator)
	append(&queue, pos)

	visited[pos] = {}
	l_visited[pos] = {}

	for len(queue) > 0 {
		current := pop(&queue)
		if tl.arrValue(mat, current) == target do ttl += 1

		locs, nums := tl.nbrsFixed(mat, current, .Udlr)
		for val, ind in sa.slice(&locs) {
			if (sa.get(nums, ind) == tl.arrValueFixed(mat, current) + 1) &&
			   !(val in l_visited) {
				append(&queue, val)
				l_visited[val] = {}
				visited[val] = {}

			}
		}
	}

	return
}

dfs :: proc(
	mat: [ROWS][COLS]int,
	pos: [2]int,
	visited: ^map[[2]int]struct {},
	target: int,
) -> (
	ttl: int,
) {
	if tl.arrValue(mat, pos) == target do return 1

	visited[pos] = {}
	locs, _ := tl.nbrsFixed(mat, pos, .Udlr)
	for n in sa.slice(&locs) {
		if !(n in visited) &&
		   tl.arrValue(mat, n) == tl.arrValue(mat, pos) + 1 {
			ttl += dfs(mat, n, visited, 9)
		}
		delete_key(visited, pos)
	}

	return
}

solution :: proc(mat: [ROWS][COLS]int) -> (pt1, pt2: int) {
	pt1_visited := make(map[[2]int]struct {})
	pt2_visited := make(map[[2]int]struct {})

	for r_val, r_ind in mat {
		for c_val, c_ind in r_val {
			if c_val == 0 {
				tmp := [2]int{r_ind, c_ind}
				if tmp in pt1_visited == false {
					pt1 += bfs(mat, tmp, &pt1_visited, 9)
				}
				pt2 += dfs(mat, tmp, &pt2_visited, 9)
			}
		}
	}

	return pt1, pt2
}


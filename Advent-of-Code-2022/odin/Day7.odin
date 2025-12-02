package AoC

import "core:fmt"
import "core:math"
import "core:mem"
import vm "core:mem/virtual"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

Directory :: struct {
	path: string,
	size: int,
}

main :: proc() {
	arena: vm.Arena
	err := vm.arena_init_static(&arena, 1 * mem.Megabyte)
	assert(err == .None)
	arena_allocator := vm.arena_allocator(&arena)
	defer vm.arena_destroy(&arena)

	a, b, ok := solution("AoC Files/Day7_2022.txt", arena_allocator)
	assert(ok, "Bad File Path")

	fmt.printf("Part 1: %v\nPart 2: %v\n", a, b)
}

solution :: proc(
	filepath: string,
	arena_allocator: mem.Allocator,
	loc := #caller_location,
) -> (
	ans1, ans2: int,
	ok: bool,
) {
	data := os.read_entire_file(filepath, arena_allocator) or_return
	it := string(data)

	tmp := make([dynamic]string, arena_allocator, loc)
	uniq_dir_names := make([dynamic]string, arena_allocator, loc)
	dir := make([dynamic]Directory, arena_allocator, loc)

	for line in strings.split_lines_iterator(&it) {
		if line[0:4] == "$ cd" && line[5] != '.' {
			append(&tmp, line[5:])
			append(&uniq_dir_names, strings.join(tmp[:], "-", arena_allocator, loc))
		}

		if len(line) >= 6 && line[5] == '.' do pop(&tmp)

		if line[0] >= 48 && line[0] <= 57 {
			p := strings.join(tmp[:], "-", arena_allocator, loc)
			s := strconv.atoi(line[:strings.index(line, " ")])
			append(&dir, Directory{path = p, size = s})
		}
	}

	ttl := make([dynamic]int, arena_allocator, loc)

	for i in uniq_dir_names {
		t_sum := 0
		for j in dir {
			if strings.contains(j.path, i) do t_sum += j.size
		}
		append(&ttl, t_sum)
	}

	ans1 = math.sum(
		slice.filter(ttl[:], proc(item: int) -> bool {return item <= 100_000}, arena_allocator),
	)

	ans2 = slice.min(
		slice.filter(
			ttl[:],
			proc(item: int) -> bool {return item >= 41_609_574 - 40_000_000},
			arena_allocator,
		),
	)

	return ans1, ans2, true
}

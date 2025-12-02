package day8

import "core:fmt"
import "core:os"
import "core:strings"
import "core:mem"
import vm "core:mem/virtual"
import t "../Tools"

ROWS :: 50
COLS :: 50

main :: proc() {
    arena: vm.Arena
    err := vm.arena_init_growing(&arena, 5 * mem.Megabyte)
    assert(err == .None)
    arena_allocator := vm.arena_allocator(&arena)
    context.allocator = arena_allocator
    defer vm.arena_destroy(&arena)

    arr, ants := parse_file("input/day8.txt")
    slopes := antSlopes(ants)
    pt1 := solution(arr, slopes)
    pt2 := solution2(slopes)

    fmt.printfln("Part 1: %v\nPart 2: %v", pt1, pt2)
}

parse_file :: proc(filepath: string) -> (arr: [ROWS][COLS]rune, ants: map[rune][dynamic][2]int) {
	data, ok := os.read_entire_file(filepath)
	if !ok do return
	it := string(data)
	
    r_ind := 0
	for line in strings.split_lines_iterator(&it) {
        for c_val, c_ind in line {
            arr[r_ind][c_ind] = c_val
            if c_val != '.' {
                if c_val in ants == false do ants[c_val] = {}
                append(&ants[c_val], [2]int{r_ind, c_ind})
            }
        }
        r_ind += 1
    }

    return
}

antSlopes :: proc(ants: map[rune][dynamic][2]int) -> (slopes: map[[2]int][dynamic][2]int) {
    for _, value in ants {
		for i in 0..<(len(value) - 1) {
			for j in (i+1)..<len(value) {
                if value[i] in slopes == false do slopes[value[i]] = {}
			    append(&slopes[value[i]], value[i] - value[j]) 
			}
		}
	}

    return
}

solution :: proc(mat: [ROWS][COLS]rune, slopes: map[[2]int][dynamic][2]int) -> int {
	ttl: map[[2]int]struct{}

	for key, value in slopes {
		for i in value {
			symb := mat[key.x][key.y]
			pos := key + i
			neg := key - (i * {2, 2})

			if t.inbounds(pos, ROWS, COLS) && mat[pos.x][pos.y] != symb {
				ttl[pos] = {}
			}
			if t.inbounds(neg, ROWS, COLS) && mat[neg.x][neg.y] != symb {
				ttl[neg] = {}
			}
		}
	}
	return len(ttl)
}

solution2 :: proc(slopes: map[[2]int][dynamic][2]int) -> int {
    ttl: map[[2]int]struct{}

    for key, value in slopes {
        ttl[key] = {}
        for i in value {
            val := key
            for {
                val = val + i
                if t.inbounds(val, ROWS, COLS) do ttl[val] = {}
                else {
                    val = key
                    break
                }
            }
            for {
                val = val - i;
                if t.inbounds(val, ROWS, COLS) do ttl[val] = {}
                else do break;
            }
        }
    }
    
    return len(ttl)
}

package AoC

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:mem"
import "../Tools"

Arena: mem.Dynamic_Arena

main :: proc() {
    mem.dynamic_arena_init(&Arena)
    arena_allocator := mem.dynamic_arena_allocator(&Arena)
    context.allocator = arena_allocator
    defer mem.dynamic_arena_destroy(&Arena)
    
    solution("input/day3.txt")
}

solution :: proc(filepath: string) {
    RE :: "mul\\((\\d+,\\d+)\\)|don't\\(\\)|do\\(\\)"
    data, ok := os.read_entire_file(filepath)
    if !ok do return 
    it := string(data)
    pt1, pt2, mul := 0, 0, true
    arr := Tools.regexFind(it, RE, 23)
    
    for i in &arr {
        defer free_all(context.temp_allocator)
        if len(i.groups) == 1 do mul = i.groups[0] == "do()" ? true : false
        else {
                tmp := strings.split(i.groups[1], ",", context.temp_allocator)
                parsed: [2]int = {strconv.atoi(tmp[0]), strconv.atoi(tmp[1])};
                pt1 += parsed.x * parsed.y
                if mul do pt2 += parsed.x * parsed.y
            }
        }
    
    fmt.printfln("Part 1: %v\nPart 2: %v", pt1, pt2)
}

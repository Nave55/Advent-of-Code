package main

import "core:fmt"
import "core:strings"
import "core:os"
import "core:strconv"

Set :: bit_set[0..=99]

main :: proc() {
    solution("./AoC Files/Day4_2022.txt")
}

solution :: proc(filepath: string) {
    using strconv
    data, ok := os.read_entire_file(filepath)
    if !ok do return 
    defer delete(data)  
    defer free_all(context.temp_allocator)

    it := string(data)
    it, _ = strings.replace_all(it, "-", ",", context.temp_allocator)
    arr: [dynamic][]string; defer delete(arr)
   
    for line in strings.split_lines_iterator(&it) {
        append_elems(&arr, strings.split(line, ",", context.temp_allocator))
    }

    ttl1, ttl2: int

    for i in arr {
        set1, set2: Set
        for j in atoi(i[0])..=atoi(i[1]) do set1 += {j}
        for j in atoi(i[2])..=atoi(i[3]) do set2 += {j}
        iset := set1 + set2
        if iset == set1 || iset == set2 do ttl1 += 1
        if card(set1 & set2) > 0 do ttl2 += 1
    }
    fmt.printf("Part 1: %v\nPart 2: %v\n", ttl1, ttl2)
}

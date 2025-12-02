package main

import "core:fmt"
import "core:strings"
import "core:os"
import "core:strconv"
import "core:slice"

main :: proc() {
    solution("./AoC Files/Day1_2022.txt")
}

solution :: proc(filepath: string) {
    data, ok := os.read_entire_file(filepath, context.allocator)
    if !ok do return 
    defer delete(data, context.allocator)  

    sum := 0
    best: [dynamic]int
    it := string(data)
    defer delete(best)

    for line in strings.split_lines_iterator(&it) {
        if line != "" do sum += strconv.atoi(line)
        else {
            append_elem(&best, sum)
            sum = 0
        }
    }
    
    sum = 0
    slice.reverse_sort(best[:])
    for i in best[:3] do sum += i
    
    fmt.printf("Answer 1 = {:v}\nAnswer 2 = {:v}", best[0], sum)
}

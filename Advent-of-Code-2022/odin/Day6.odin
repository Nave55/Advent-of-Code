package main

import "core:fmt"
import "core:os"

main :: proc() {
    a := solution(4)
    b := solution(14)
    fmt.printf("Part 1: {:v}\nPart 2: {:v}\n", a, b)
}

solution :: proc(i_size: int) -> int {
    data, ok := os.read_entire_file("./AoC Files/Day6_2022.txt", context.allocator)
    defer delete(data, context.allocator)  

    it := string(data)
    Letters :: bit_set['A'..='z']

    for i in 1..<len(it) { 
        set1: Letters
        for j in i..=i+(i_size-1) do set1 += {rune(it[j])}
        if card(set1) == i_size {
            return i + i_size
        }        
    }
    return -1
}

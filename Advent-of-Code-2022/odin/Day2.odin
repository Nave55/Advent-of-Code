package main

import "core:fmt"
import "core:strings"
import "core:os"
import "core:strconv"
import "core:slice"

main :: proc() {
    solution("./AoC Files/Day2_2022.txt")
}

solution :: proc(filepath: string) {
    data, ok := os.read_entire_file(filepath, context.allocator)
    if !ok do return
    defer delete(data, context.allocator)
    it := string(data)

    mp := map[string]int {
        "AX" = 4, "AY" = 8, "AZ" = 3,
        "BX" = 1, "BY" = 5, "BZ" = 9,
        "CX" = 7, "CY" = 2, "CZ" = 6,
    }
    defer delete(mp)

    mp2 := map[string]string {
        "AX" = "AZ", "AY" = "AX", "AZ" = "AY",
        "BX" = "BX", "BY" = "BY", "BZ" = "BZ",   
        "CX" = "CY", "CY" = "CZ", "CZ" = "CX",
    }
    defer delete (mp2)

    sum, sum2 := 0, 0
    for line in strings.split_lines_iterator(&it) {
        ln,truth := strings.replace(line, " ", "", 1)
        sum += mp[ln]
        sum2 += mp[mp2[ln]]
    }
    fmt.printf("Part 1: {:v}\nPart 2: {:v}", sum, sum2)
}

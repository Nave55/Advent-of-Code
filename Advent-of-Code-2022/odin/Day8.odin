package AoC

import "core:fmt"
import "core:strings"
import "core:os"
import "core:slice"

main :: proc() {
    data, ok := os.read_entire_file("./AoC Files/Day8_2022.txt", context.allocator)
    if !ok do return 
    defer delete(data, context.allocator)  

    it := string(data)
    s: [dynamic]string; defer delete(s)
    for line in strings.split_lines_iterator(&it) do append(&s, line)

    solution(&s)
}

solution :: proc(s: ^[dynamic]string) {
    count := (len(s) * 4) - 4
    scores: [dynamic]int; defer delete(scores) 

    for rows in 1..<len(s) - 1 {
        for cols in 1..<len(s) - 1 {
            pos := (s[rows][cols])
            
            left, right, bottom, top: [dynamic]u8; 
            defer {delete(left); delete(right); delete(top); delete(bottom)}
            for i in 1..<cols + 1        do append(&left,   s[rows][cols - i])
            for i in 1..<len(s) - cols   do append(&right,  s[rows][cols + i])
            for i in 1..<rows + 1        do append(&top,    s[rows - i][cols])
            for i in 1..<len(s) - rows   do append(&bottom, s[rows + i][cols + 1])

            if (slice.max(left[:]) < pos || slice.max(right[:]) < pos || slice.max(top[:]) < pos || slice.max(bottom[:]) < pos) do count += 1
            
            score := 1
            for lst in ([4][]u8)({left[:], right[:], top[:], bottom[:]}) {
                tracker := 0
                for i in 0..<len(lst) {
                    if lst[i] < pos do tracker += 1
					else if lst[i] == pos {
						tracker += 1
						break
					}
					else do break
				}
                
                score *= tracker
                append(&scores, score)
            }   
        }
    }
    fmt.printfln("Part 1: %v\nPart 2: %v", count, slice.max(scores[:]))
}

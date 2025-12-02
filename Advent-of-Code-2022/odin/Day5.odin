package AoC

import "core:fmt"
import "core:strings"
import "core:os"
import "core:strconv"
import "core:container/queue"
import "core:unicode/utf8"

main :: proc() {
    instructions, crates, crates2 := parsefile()
    part1, part2 := solution(instructions, crates, crates2) 
    fmt.printf("Part 1: {:v}\nPart 2: {:v}", part1, part2)
}

parsefile :: proc() -> (instructions: string, crates, crates2: [9]queue.Queue(rune)) {
    data, ok := os.read_entire_file("./AoC Files/Day5_2022.txt", context.allocator) 
    defer delete(data, context.allocator)  

    it := string(data)
    it, _ = strings.replace_all(it, " 1   2   3   4   5   6   7   8   9", "")
    it, _ = strings.replace_all(it, "move", "")
    it, _ = strings.replace_all(it, "from", ",")
    it, _ = strings.replace_all(it, "to", ",")
    it, _ = strings.replace_all(it, "[", "")
    it, _ = strings.replace_all(it, "]", "")
    it, _ = strings.replace_all(it, "    ", "0")
    it, _ = strings.replace_all(it, " ", "")

    cnt := 0
    for line in strings.split_lines_iterator(&it) {
        if line == "" do break
        if cnt < 9 {
            for val, ind in line {
                if val != '0' {
                    queue.push_back(&crates[ind], val)
                    queue.push_back(&crates2[ind], val)
                }
            }
        }
        cnt += 1
    }

    for line in strings.split_lines_iterator(&it) {
        if line != "" {
            instructions = strings.concatenate({instructions, line})
            instructions = strings.concatenate({instructions, ","})
        }
    }
    return instructions, crates, crates2
}

solution :: proc(instructions:string, crates, crates2: [9]queue.Queue(rune)) -> (string, string) {
    crates, crates2 := crates, crates2
    instructions := strings.split(instructions, ",")
    instructions = instructions[:len(instructions) - 1]
    cnt, num_of_pops, from := 0, 0, 0

    for i in instructions {
        num := strconv.atoi(i)
        if cnt == 0 do num_of_pops = num
        else if cnt == 1 do from = num
        else {
            tmp : [1]queue.Queue(rune)
            for j in 0..<num_of_pops {
                queue.push_front(&crates[num-1], queue.pop_front(&crates[from-1]))
                queue.push_back(&tmp[0], queue.pop_front(&crates2[from-1]))
            }
            for j in 0..<num_of_pops {
                queue.push_front(&crates2[num-1], queue.pop_back(&tmp[0]))
            }
            cnt = -1
        }
        cnt += 1 
    }
    
    out, out2: [dynamic]rune
    for i in 0..=8 {
        append_elem(&out, queue.front(&crates[i]))
        append_elem(&out2, queue.front(&crates2[i]))
    }

    return utf8.runes_to_string(out[:]), utf8.runes_to_string(out2[:])
}

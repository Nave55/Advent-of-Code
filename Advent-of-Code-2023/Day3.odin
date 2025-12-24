package AoC_2023

import "core:fmt"
import "core:strings"
import "core:os"
import "core:strconv"
import "core:slice"
import "core:math"
import "core:unicode/utf8"
import "core:unicode"

Directory :: struct {
    num, x, y : int,
    rng : []int
}

main :: proc() {
    solution("./AoC Files/Day3.txt")
}

solution :: proc(filepath: string) {
    data, ok := os.read_entire_file(filepath)
    if !ok do return 
    
    it := string(data)
    arr:  [dynamic]string
    for line in strings.split_lines_iterator(&it) do append(&arr,line)
    
    sym_dir: [dynamic]Directory
    num_dir: [dynamic]Directory
    
    for i in 0..<len(arr) {
        tmp_num: [dynamic]rune
        tmp_rng: [dynamic]int
        
        for j in 0..<len(arr) {
            if rune(arr[i][j]) != '.' && ! unicode.is_digit(rune(arr[i][j])) {
                append(&sym_dir, Directory{x = j, y = i})
            } 
            if unicode.is_digit(rune(arr[i][j])) {
                append(&tmp_num,rune(arr[i][j]))
                append(&tmp_rng, j)
            }
            if (!unicode.is_digit(rune(arr[i][j])) || j == len(arr) - 1 ) && len(tmp_num) > 0 {
                tmp := utf8.runes_to_string(tmp_num[:])
                append(&num_dir, Directory{num = strconv.atoi(tmp), x = j-1, y = i, rng = slice.clone(tmp_rng[:])})
                clear(&tmp_num); clear(&tmp_rng)
            }
        }
    }

    pt1, pt2 := 0, 0
    for i in sym_dir {
        tmp : [dynamic]int
        for j in num_dir {
            if slice.contains(j.rng,i.x) && (j.y == i.y+1 || j.y == i.y-1) ||
               slice.contains(j.rng,i.x+1) && (j.y == i.y || j.y == i.y-1 || j.y == i.y+1) ||
               slice.contains(j.rng,i.x-1) && (j.y == i.y+1 || j.y == i.y || j.y == i.y-1) {
                pt1 += j.num
                append(&tmp,j.num)
            }
        }   
        if len(tmp) == 2 do pt2 += math.prod(tmp[:])
    }

    fmt.printf("Part 1: %v\nPart 2: %v\n", pt1, pt2)
}



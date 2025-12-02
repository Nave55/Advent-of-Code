package main

import "core:fmt"
import "core:strings"
import "core:os"

main :: proc() {
    data, ok := os.read_entire_file("./AoC Files/Day3_2022.txt", context.allocator)
    if !ok do return 
    defer delete(data, context.allocator)  

    mp := make(map[rune]int)
    for i in 'a'..='z' do mp[i] = int(i-96)
    for i in 'A'..='Z' do mp[i] = int(i-38)
    defer delete(mp)

    fmt.printf("Part 1: {:v}\n", solution1(string(data), mp))
    fmt.printf("Part 2: {:v}\n", solution2(string(data), mp))}

solution1 :: proc (it: string, mapper: map[rune]int) -> (ttl: int) {
    Letters :: bit_set['A'..='z']
    it := it
    
    for line in strings.split_lines_iterator(&it) {
        a, b: Letters
        left, right := line[:len(line)/2], line[len(line)/2:]
        for i in left do a += {i}
        for i in right do b += {i}
        for i in 65..=122 {
            if rune(i) in (a & b) do ttl += mapper[rune(i)]
        }
    }
    return ttl
}

solution2 :: proc (it: string, mapper: map[rune]int) -> (ttl: int) {
    Letters :: bit_set['A'..='z']
    it := it
    
    for first in strings.split_lines_iterator(&it) {
        second, _ := strings.split_lines_iterator(&it);
        third, _ := strings.split_lines_iterator(&it);
        a, b, c: Letters
        for i in first do a += {i}
        for i in second do b += {i}
        for i in third do c += {i}
        for i in 65..=122 {
            if rune(i) in (a & b & c) do ttl += mapper[rune(i)]
        }
    }
    return ttl
}

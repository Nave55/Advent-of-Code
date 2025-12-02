import os

fn main() {
	lines := os.read_lines('input/Day3_2022.txt')!
	mut alphabet := map[rune]int{}
	for i in 1 .. 27 {
		alphabet[u8(i + 64)] = i + 26
		alphabet[u8(i + 96)] = i
	}

	ttl := solution1(lines, alphabet)
	ttl2 := solution2(lines, alphabet)
	println('Part 1: ${ttl}\nPart 2: ${ttl2}')
}

fn solution1(lines []string, alphabet map[rune]int) int {
	mut ttl := 0

	for i in lines {
		length := i.len
		arr1 := i.substr(0, (length / 2))
		arr2 := i.substr(length / 2, length)
		for j in arr1 {
			if arr2.contains_any(rune(j).str()) {
				ttl += alphabet[rune(j)]
				break
			}
		}
	}
	return ttl
}

fn solution2(lines []string, alphabet map[rune]int) int {
	mut ttl2 := 0

	for i in 0 .. lines.len / 3 {
		line1 := lines[(i * 3)]
		line2 := lines[(i * 3) + 1]
		line3 := lines[(i * 3 + 2)]
		for j in line1 {
			if line2.contains_any(rune(j).str()) && line3.contains_any(rune(j).str()) {
				ttl2 += alphabet[rune(j)]
				break
			}
		}
	}
	return ttl2
}

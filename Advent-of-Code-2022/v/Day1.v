import os
import arrays

fn main() {
	mut ttl := 0
	mut arr := []int{}
	lines := os.read_lines("input/Day1_2022.txt")!
	for i in lines {
		if i.int() != 0 {
			ttl += i.int()
		}
		else {
			arr << ttl 
			ttl = 0
		}
	}
	arr.sort(b < a)
	println("Part 1: ${arr[0]}\nPart 2: ${arrays.sum[int](arr[0..3])!}")	
}

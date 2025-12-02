import os

fn main() {
	mut arr := []string{}
	lines := os.read_lines("input/Day2_2022.txt")!
	for i in lines {arr << i}

	mut pt1, mut pt2 := 0, 0

	map1 := {"A X": 4, "A Y": 8, "A Z": 3,
        	 "B X": 1, "B Y": 5, "B Z": 9,
		 "C X": 7, "C Y": 2, "C Z": 6}
	
	map2 := {"A X": "A Z", "A Y": "A X", "A Z": "A Y",
        	 "B X": "B X", "B Y": "B Y", "B Z": "B Z",   
                 "C X": "C Y", "C Y": "C Z", "C Z": "C X"}

	for i in arr {
		pt1 += map1[i]
		pt2 += map1[map2[i]]
	}
	
	println("Part 1: ${pt1}\nPart 2: ${pt2}")	
}

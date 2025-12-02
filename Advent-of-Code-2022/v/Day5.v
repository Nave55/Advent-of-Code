import os

fn main() {
	crates, instructions := parse_file()!
	pt1 := solution1(crates, instructions)
	pt2 := solution2(crates, instructions)
	println('Part 1: ${pt1}\nPart 2: ${pt2}')
}

fn parse_file() !([][]rune, [][]int) {
	mut crates := [][]rune{len: 9}
	mut instructions := [][]int{}
	lines := os.read_lines('input/Day5_2022.txt')!
	for i in 0 .. lines.len {
		if i < 8 {
			crate := lines[i].replace('[', '').replace(']', '').replace('    ', '0').replace(' ',
				'')
			for j in 0 .. crate.len {
				if rune(crate[j]) != `0` {
					crates[j].insert(0, rune(crate[j]))
				}
			}
		}
		if i > 9 {
			instructions << lines[i].replace('move ', '').replace(' from ', ',').replace(' to ',
				',').split(',').map(it.int())
		}
	}
	return crates, instructions
}

fn solution1(cr [][]rune, instructions [][]int) string {
	mut crates := cr.clone()
	for i in instructions {
		for _ in 0 .. i[0] {
			crates[i[2] - 1] << crates[i[1] - 1].pop()
		}
	}
	mut tmp := []string{}
	for i in crates {
		tmp << i#[-1..].string()
	}
	return tmp.join('')
}

fn solution2(cr [][]rune, instructions [][]int) string {
	mut crates := cr.clone()
	for i in instructions {
		crates[i[2] - 1] << crates[i[1] - 1]#[-i[0]..]
		crates[i[1] - 1] = crates[i[1] - 1]#[..-i[0]]
	}
	mut tmp := []string{}
	for i in crates {
		tmp << i#[-1..].string()
	}
	return tmp.join('')
}

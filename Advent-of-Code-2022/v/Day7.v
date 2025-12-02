import os
import arrays

struct Directory {
	path string
	size int
}

fn main() {
	lines := os.read_lines('input/Day7_2022.txt')!

	mut tmp := []string{}
	mut uniq_dir_names := []string{}
	mut dir := []Directory{}

	for line in lines[0..] {
		if line[0..4] == '$ cd' && line[5] != `.` {
			if line[5] == `/` {
				tmp << 'root'
			} else {
				tmp << line[5..]
			}
			uniq_dir_names << tmp.join('/')
		}
		if line.len >= 6 && line[5] == `.` {
			tmp.pop()
		}
		if line[0] >= 48 && line[0] <= 57 {
			p := tmp.join('/')
			s := int(line[..line.index(' ')?].int())
			dir << Directory{
				path: p
				size: s
			}
		}
	}

	mut ttl := []int{}
	for i in uniq_dir_names {
		mut t_sum := 0
		for j in dir {
			if j.path.contains(i) {
				t_sum += j.size
			}
		}
		ttl << t_sum
	}

	pt1 := int(arrays.sum(ttl.filter(it <= 100_000))!)
	pt2 := arrays.min(ttl.filter(it >= ttl[0] - 40_000_000))!
	println('Part 1: ${pt1}\nPart 2: ${pt2}')
}

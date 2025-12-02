import os
import tools as t
import datatypes as dt

const rows := 50
const cols := 50

fn main() {
	arr := parse_file()
	pt1, pt2 := solution(arr)
	println('Part 1: ${pt1}\nPart 2: ${pt2}')
}

fn parse_file() [][]int {
	lines := os.read_lines('input/day10.txt') or { panic(err) }
	mut arr := [][]int{len: rows, cap: rows, init: []int{len: cols, cap: cols, init: 0}}

	mut r_ind := 0 
	for row in lines {
		for c_ind, col in row {
			arr[r_ind][c_ind] = int(rune(col) - `0`)
		}
		r_ind++
	}
	
	return arr
}

fn bfs(mat [][]int, pos t.Vec2[int], mut visited dt.Set[string], target int) int {
	mut l_visited := dt.Set[string]{}
	mut queue := []t.Vec2[int]{}
	mut ttl := 0
	queue << pos
	visited.add(pos.to_str())
	l_visited.add(pos.to_str())

	for queue.len > 0 {
		current := queue.pop()
		if t.arr_value(mat, current) == target {
			ttl++
		}
		locs, nums := t.nbrs(mat, current, `n`) 
		for ind, val in locs {
			val_str := val.to_str()
			if (nums[ind] == t.arr_value(mat, current) + 1) && ! l_visited.exists(val_str) {
				queue << val
				l_visited.add(val_str)
				visited.add(val_str)
			}	 	
		}
	}

	return ttl 
}

fn dfs(mat [][]int, pos t.Vec2[int], mut visited dt.Set[string], target int) int {
        mut result := 0
        if t.arr_value(mat, pos) == target {
			return 1
		}

        visited.add(pos.to_str())
        locs, _ := t.nbrs(mat, pos,`n`);
        for neighbor in locs { 
            if !visited.exists(neighbor.to_str()) && t.arr_value(mat, neighbor) ==  t.arr_value(mat, pos) + 1 {
                result += dfs(mat, neighbor, mut visited, 9);
            }
            visited.remove(pos.to_str())
        }

        return result
    }

fn solution(mat [][]int) (int, int) {
	mut pt1 := 0
	mut pt2 := 0
	mut pt1_visited := dt.Set[string]{}
	mut pt2_visited := dt.Set[string]{}

	for r_ind, r_val in mat {
		for c_ind, c_val in r_val {
			if c_val == 0 {
				tmp := t.Vec2[int]{r_ind, c_ind}
				if ! pt1_visited.exists(tmp.to_str()) {
					pt1 += bfs(mat, tmp, mut pt1_visited, 9)	
				}
				pt2 += dfs(mat, tmp, mut pt2_visited, 9)
			}
		}
	}
	
	return pt1, pt2
}

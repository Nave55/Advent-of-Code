package day7

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import sa "core:container/small_array"

main :: proc() {
	targets, nums := parse_file("input/day7.txt")
	pt1, pt2 := solution(targets[:], nums[:])

	fmt.printfln("Part 1: %v\nPart 2: %v", pt1, pt2)
}

parse_file :: proc(filepath: string) -> (targets: [850]int, nums: [850]sa.Small_Array(12, int)) {
	data, ok := os.read_entire_file(filepath, context.temp_allocator)
	if !ok do return
    	defer free_all(context.temp_allocator)
	
	it := string(data)
   	 ind := 0

	for line in strings.split_lines_iterator(&it) {
        	tmp_arr := strings.split(line, ": ", context.temp_allocator)
        	targets[ind] = strconv.atoi(tmp_arr[0])
        	tmp_nums: sa.Small_Array(12, int) 

        for val, ind in strings.split(tmp_arr[1], " ", context.temp_allocator) {
        	sa.append(&tmp_nums, strconv.atoi(val))
        }

        nums[ind] = tmp_nums

        ind += 1
    }

    return
}

concat :: proc(a, b: int) -> int {
	return strconv.atoi(fmt.tprintf("%v%v", a, b))
}

evaluate :: proc(nums: []int, target, index, currentVal: int, pt1: bool) -> bool {
	if index == 0 do return evaluate(nums, target, index + 1, nums[0], pt1)
	if index == len(nums) do return currentVal == target
	
	num := nums[index]
	if evaluate(nums, target, index + 1, currentVal + num, pt1) do return true
	if evaluate(nums, target, index + 1, currentVal * num, pt1) do return true
	if !pt1 && evaluate(nums, target, index + 1, concat(currentVal, num), pt1) do return true
	
	return false
}

solution :: proc (a: []int, b: []sa.Small_Array(12, int)) -> (ttl, ttl2: int) {
	for _, ind in b {
        	sli := sa.slice(&b[ind])
		if evaluate(sli, a[ind], 0, 0, true) do ttl += a[ind]
		if evaluate(sli, a[ind], 0, 0, false) do ttl2 += a[ind]
	}
    
	return ttl, ttl2
}

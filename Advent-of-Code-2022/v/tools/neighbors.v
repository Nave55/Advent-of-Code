module tools

pub fn add_arrs[T](arr []T, arr2 []T) []T {
	mut n := []T{}
	for i in 0..arr.len {
		n << arr[i] + arr2[i]
	}
	return n
}

pub fn arr_value[T](arr [][]T, arr2 []int) T {
	return arr[arr2[0]][arr2[1]]
}


pub fn nbrs[T](arr [][]T, loc []int, diag bool) ([][]int, []T) {
	mut dir := [][]int{}
    if !diag {
		dir = [[-1, 0], [0, -1], [0, 1], [1, 0]]
	} else {
		dir = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
	}
    mut indices := [][]int{}
    mut vals := []T{}
    for i in dir {
        tmp := add_arrs(loc, i)
        if tmp[0] != -1 && tmp[1] != -1 && tmp[0] != arr.len && tmp[1] != arr[0].len {
            indices << tmp
            vals << arr_value(arr, tmp);
        }
    }
	return indices, vals
}
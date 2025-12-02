package tools

import "core:fmt"
import "core:slice"

arrValue :: proc(arr: [$A][$B]$T, arr2: [2]int) -> T {
    return arr[arr2[0]][arr2[1]]
}

nbrs :: proc(arr: [$A][$B]$T, loc: [2]int, $N: int) -> (indices: [N][2]int, vals: [N]T) {
    assert(N == 4 || N == 8, "N must be 4 or 8")

    dir: [N][2]int
    when N == 4 do dir = {{-1, 0}, {0, -1}, {0, 1}, {1, 0}}
    when N == 8 do dir = {{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}}

    for i, ind in dir {
        tmp := loc + i
        if tmp[0] != -1 && tmp[1] != -1 && tmp[0] != len(arr) && tmp[1] != len(arr[0]) {
            indices[ind] = tmp
            vals[ind] = arrValue(arr, tmp)
        }
    }
    return
}
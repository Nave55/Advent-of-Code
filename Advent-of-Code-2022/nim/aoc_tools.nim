proc addArrs*[T](arr1: seq[T], arr2: seq[T]): seq[T] = 
    var sol: seq[int]
    for i in 0..<len(arr1):
        sol.add(arr1[i] + arr2[i])

    return sol
    
proc arrValue*[T](arr: seq[seq[T]], ind: seq[int]): T =
    return arr[ind[0]][ind[1]]

proc nbrs*[T](arr: seq[seq[T]], loc: seq[int], diag: bool = false): (seq[seq[int]], seq[T]) =
    var dir: seq[seq[int]]
    if (not diag): dir = @[@[-1, 0], @[0, -1], @[0, 1], @[1, 0]]
    else: dir = @[@[-1, -1], @[-1, 0], @[-1, 1], @[0, -1], @[0, 1], @[1, -1], @[1, 0], @[1, 1]]
    var indices: seq[seq[int]]
    var vals: seq[T]
    for i in dir:
        let tmp = addArrs(loc, i)
        if (tmp[0] != -1 and tmp[1] != -1 and tmp[0] <= arr.high and tmp[1] <= arr[0].high):
            indices &= tmp
            vals &= arrValue(arr, tmp)
        
    
    return (indices, vals)
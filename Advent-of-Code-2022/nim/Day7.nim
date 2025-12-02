import strutils, sugar, sequtils, strformat, math

type
    Directory = ref object
        path: string
        size: int

proc solution =
    var
        unique_names, tmp: seq[string]
        dir: seq[Directory]

    let file = open("input/Day7.txt");
    defer: file.close()

    for i in file.lines():
        if i[2] == 'c' and i[5] != '.':
            tmp.add(i[5..^1])
            unique_names.add(tmp.join("-"))
        elif i[2] == 'c' and i[5] == '.':
            discard tmp.pop()
        elif i[0].isDigit():
            let 
                p = tmp.join("-")
                s = parseInt(i[0..<i.find(' ')])
            dir.add(Directory(path: p, size: s))
    
    var arr_sum: seq[int]

    for i in unique_names:
        var sum = 0
        for j in dir:
            if j.path.contains(i):
                sum += j.size
        arr_sum.add(sum)

    let 
        pt1 = arr_sum.filter(item => item <= 100_000).sum()
        pt2 = arr_sum.filter(item => item >= arr_sum[0] - 40_000_000).min()

    echo &"Solution 1: {pt1}\nSolution 2: {pt2}"

solution()

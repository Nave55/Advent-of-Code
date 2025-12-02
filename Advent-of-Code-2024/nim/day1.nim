import strutils, strformat, algorithm, sequtils, sets, sugar

proc readInput(): (seq[int], seq[int]) =
    let file = open("input/Day1.txt")
    defer: file.close()

    for i in file.lines():
        let lr = i.split("   ").map(item => parseInt(item))

        result[0] &= lr[0]
        result[1] &= lr[1]

    result[0].sort()
    result[1].sort()

proc solution(): (int, int) =    
    let (l, r) = readInput()
    let left = l.toHashSet()

    for i in 0..<r.len:
        result[0] += abs(l[i] - r[i])
        if left.contains(r[i]):
            result[1] += r[i]

let (sum1, sum2) = solution()
echo &"Part 1: {sum1}\nPart 2: {sum2}"

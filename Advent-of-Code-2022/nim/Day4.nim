import sets, strformat, strutils, sequtils, sugar

proc readInput(): seq[seq[int]] =
    let file = open("input/Day4.txt");
    defer: file.close()

    var arr: seq[seq[int]]

    for i in file.lines():
        arr.add(i.replace("-",",").split(",").map(item => parseInt(item)))

    return arr

let arr = readInput()

var 
    ttl1 = 0
    ttl2 = 0

for i in arr:
    let s1 = toHashSet(toSeq(i[0]..i[1]))
    let s2 = toHashSet(toSeq(i[2]..i[3]))
    let s3 = s1 * s2

    if s1 == s3 or s2 == s3:
        inc ttl1
    if s4.len > 0:
        inc ttl2    

echo &"Solution 1: {ttl1}\nSolution 2: {ttl2}"

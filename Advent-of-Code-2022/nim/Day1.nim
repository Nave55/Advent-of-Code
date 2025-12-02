import strutils, strformat, math, algorithm

proc readInput(): seq[int] =
    var 
        tmp = 0
        arr: seq[int]
        
    let file = open("input/Day1.txt");
    defer: file.close()

    for i in file.lines():
        if i != "":
            tmp += parseInt(i)
        else:
            arr.add(tmp)
            tmp = 0

    return arr

var sumArr = readInput()
sort(sumArr)

echo fmt"Solution 1: {sumArr[^1]}{'\n'}Solution 2: {sum(sumArr[^3..^1])}"

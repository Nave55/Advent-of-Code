import strutils, tables, strformat

proc readInput(): seq[string] =
    let file = open("input/Day2.txt");
    defer: file.close()

    var arr: seq[string]

    for i in file.lines():
        arr.add(i.replace(" ", ""))
    
    return arr

let arr = readInput()
var 
    map1 = {
        "AX": 4, "AY": 8, "AZ": 3,
        "BX": 1, "BY": 5, "BZ": 9,
        "CX": 7, "CY": 2, "CZ": 6,
    }.toTable
    map2 = {
        "AX": "AZ", "AY": "AX", "AZ": "AY",
        "BX": "BX", "BY": "BY", "BZ": "BZ",   
        "CX": "CY", "CY": "CZ", "CZ": "CX",
    }.toTable
    ttl1 = 0
    ttl2 = 0

for i in arr:
    ttl1 += map1[i]
    ttl2 += map1[map2[i]]

echo fmt"Solution 1: {ttl1}{'\n'}Solution 2: {ttl2}"
import sets, tables, strformat

proc readInput(): seq[string] =
    let file = open("input/Day3.txt");
    defer: file.close()

    var arr: seq[string]

    for i in file.lines():
        arr.add(i)

    return arr

let arr = readInput()

var 
    map: Table[char, int]
    ttl1 = 0
    ttl2 = 0
    iter = 0

for i in 1..26:
    map[char(i + 96)] = i
    map[char(i + 64)] = i + 26

for i in arr:
    for i in (toHashSet(i[0..<int(len(i) / 2)]) * toHashSet(i[int(len(i) / 2)..<len(i)])):
        ttl1 += map[i]

while iter < len(arr) - 2:
    for j in (toHashSet(arr[iter]) * toHashSet(arr[iter + 1]) * toHashSet(arr[iter + 2])):
        ttl2 += map[j] 
    iter += 3

echo &"Solution 1: {ttl1}\nSolution 2: {ttl2}"

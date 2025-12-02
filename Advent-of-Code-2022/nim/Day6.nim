import sets, strformat

proc solution(window: int): int =
    let file = open("input/Day6.txt");
    defer: file.close()

    for i in file.lines():
        for j in 0..<len(i) - window - 1:
            if len(i[j..<j + window].toHashSet()) == window:
                return j + window
let 
    ttl1 = solution(4)
    ttl2 = solution(14)

echo &"Solution 1: {ttl1}\nSolution 2: {ttl2}"

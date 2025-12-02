import strformat

proc readInput(): seq[string] =
    var s: seq[string]
    let file = open("input/Day8.txt");
    defer: file.close()

    for i in file.lines():
        s.add(i)
    
    return s
        
block:
    let s = readInput()
    var
        count = (len(s) * 4) - 4
        scores: seq[int]

    for rows in 1..<len(s) - 1:
        for cols in 1..<len(s) - 1:
            var pos = s[rows][cols]

            var
                left: seq[char]
                right: seq[char]
                top: seq[char]
                bottom: seq[char] 

            for i in 1..<cols + 1:      left.add((s[rows][cols - i]))
            for i in 1..<len(s) - cols: right.add((s[rows][cols + i]))
            for i in 1..<rows + 1:      top.add((s[rows - i][cols]))
            for i in 1..<len(s) - rows: bottom.add((s[rows + i][cols]))

            if max(left) < pos or max(right) < pos or max(top) < pos or max(bottom) < pos:
                count += 1

            var score = 1
            for lst in [left, right, top, bottom]:
                var tracker = 0
                for i in 0..<len(lst):
                    if lst[i] < pos:
                        tracker += 1
                    elif lst[i] == pos:
                        tracker += 1
                        break
                    else:
                        break
            
                score *= tracker
                scores.add(score)
    
    echo &"Solution 1: {count}\nSolution 2: {max(scores)}"

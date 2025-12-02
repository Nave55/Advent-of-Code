import strutils, sugar, sequtils, algorithm, strformat

proc readInput(): (seq[seq[char]], seq[seq[int]]) =
    var 
        crates = newSeq[seq[char]](9)
        instructions: seq[seq[int]]
        cnt = 0
        
    let file = open("input/Day5.txt");
    defer: file.close()

    for i in file.lines():
        if cnt < 8:
            var tmp = i.replace("[", "")
                       .replace("]","")
                       .replace("    ", "0")
                       .replace(" ", "")
                       .toSeq()

            for j in 0..<len(tmp):
                if tmp[j] != '0':
                    crates[j].insert(tmp[j], 0)

        elif cnt > 9:
            instructions.add(i.replace("move ", "")
                              .replace("from ", ",")
                              .replace("to ", ",")
                              .replace(" ", "")
                              .split(",")
                              .map(item => parseInt(item))
                            )
        inc cnt

    return (crates, instructions)

let data = readInput()

proc solutionOne(cra: seq[seq[char]], instr: seq[seq[int]]): string =
    var 
        cra = cra
        str: string
    for i in instr:
        for j in 0..<i[0]:
            cra[i[2] - 1].add(cra[i[1] - 1].pop)

    for i in cra:
        str.add(i[^1])

    return str


proc solutionTwo(cra: seq[seq[char]], instr: seq[seq[int]]): string =
    var 
        cra = cra
        str: string

    for i in instr:
        var tmp: seq[char]
        for j in 0..<i[0]:
            tmp.add(cra[i[1] - 1].pop)
        tmp.reverse()
        cra[i[2] - 1] = cra[i[2] - 1].concat(tmp)

    for i in cra:
        str.add(i[^1])

    return str

let
    pt1 = solutionOne(data[0], data[1])
    pt2 =solutionTwo(data[0], data[1])

echo &"Solution 1: {pt1}\nSolution 2: {pt2}"
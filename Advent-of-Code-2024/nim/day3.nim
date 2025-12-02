import strutils, strformat, sequtils, sugar, re

type IntSeq = seq[int]

proc readInput(): seq[IntSeq] =
    let
      pattern = re"mul\(\d+,\d+\)|do(n't)?\(\)"
      replacements = @[
        ("mul", ""),
        ("(", ""),
        (")", ""),
        ("do()", "1"),
        ("don't()", "0")
      ]

    result = readFile("input/day3.txt")
            .findAll(pattern)
            .join(" ")
            .multiReplace(replacements)
            .split(" ")
            .map(item => item.split(",").map(item => item.parseInt()))    
    
proc solution(): (int, int) =
  let m1 = readInput()
  var mul = true
  
  for i in m1:
    if i.len() == 1:
      mul = if i[0] == 1: true else: false
    else:
      result[0] += i[0] * i[1]
      if mul:
        result[1] += i[0] * i[1]
       
let (pt1, pt2) = solution()
echo &"Part 1: {pt1}\nPart 2: {pt2}"  




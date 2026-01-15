import sequtils, strformat, tables, sets, tools

type 
  Ants = Table[char, seq[TI]]
  Slopes = Table[TI, seq[TI]]
  Mat = seq[seq[char]]

const 
  width = 50
  height = 50

proc readInput(): (Ants, Mat) =
  let file = open("input/day8.txt", fmRead);
  defer: file.close()

  for i in file.lines():
    result[1] &= i.toSeq()

  for r_ind, r_val in result[1]:
    for c_ind, c_val in r_val:
      if c_val != '.':
        discard result[0].hasKeyOrPut(c_val, @[])
        result[0][c_val] &= (r_ind, c_ind)
         
func antSlopes(ants: Ants): Slopes =
  for value in ants.values():
    for i in 0..<value.len() - 1:
      for j in i+1..<value.len():
        discard result.hasKeyOrPut(value[i], @[])
        result[value[i]] &= value[i] - value[j]

func insert_set(pos: var TI, mat: Mat, set: var HashSet[string], symb: char) =
  if inBounds(pos, width, height) and fetchVal(mat, pos) != symb:
    set.incl(pos.tupToStr())

func solution(mat: Mat, slopes: Slopes): int =
  var ttl = initHashSet[string]()
  for key, value in slopes:
    for i in value:
      var 
        symb = fetchVal(mat, key)
        pos = key + i
        neg = key - (i * 2)
      insert_set(pos, mat, ttl, symb)
      insert_set(neg, mat, ttl, symb)
        
  return ttl.len()

func walk(start: TI, step: TI, set: var HashSet[string]) =
  var pos = start
  while true:
    pos = pos + step
    if pos.inBounds(width, height):
      set.incl(pos.tupToStr())
    else:
      break
        
func solution2(slopes: Slopes): int =
  var ttl = initHashSet[string]()
  
  for key, value in slopes:
    ttl.incl(key.tupToStr())
    for i in value:
      var val = key
      walk(val, i, ttl)
      walk(val, i.neg(), ttl)
        
  return ttl.len()
    
let 
  (ants, mat) = readInput()
  slopes = antSlopes(ants)
  pt1 = solution(mat, slopes)
  pt2 = solution2(slopes)
echo &"Solution 1: {pt1}\nSolution 2: {pt2}"

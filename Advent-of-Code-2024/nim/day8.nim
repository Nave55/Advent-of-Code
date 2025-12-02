import sequtils, strformat, tables, sets, tools

type 
    TI = tuple[x, y: int]
    HTSTI = Table[TI, seq[TI]]
    HCSTI = Table[char, seq[TI]]
    SC = seq[char]
    SSC = seq[SC]

const 
    width = 50
    height = 50

proc readInput(): (HCSTI, SSC) =
  let file = open("input/day8.txt", fmRead);
  defer: file.close()

  for i in file.lines():
    result[1] &= i.toSeq()

  for r_ind, r_val in result[1]:
    for c_ind, c_val in r_val:
      if c_val != '.':
        discard result[0].hasKeyOrPut(c_val, @[])
        result[0][c_val] &= (r_ind, c_ind)
         
func antSlopes(ants: HCSTI): HTSTI =
  for value in ants.values():
    for i in 0..<value.len() - 1:
      for j in i+1..<value.len():
        discard result.hasKeyOrPut(value[i], @[])
        result[value[i]] &= value[i] - value[j]

func solution(mat: SSC, slopes: HTSTI): int =
  var ttl = initHashSet[string]()
  for key, value in slopes:
    for i in value:
      var 
        symb = fetchVal(mat, key)
        pos = key + i
        neg = key - (i * 2)
      if inBounds(pos, width, height) and fetchVal(mat, pos) != symb:
        ttl.incl(pos.tupToStr())
      if inBounds(neg, width, height) and fetchVal(mat, neg) != symb:
        ttl.incl(neg.tupToStr())
        
  return ttl.len()
        
func solution2(slopes: HTSTI): int =
  var ttl = initHashSet[string]()
  for key, value in slopes:
    ttl.incl(key.tupToStr())
    for i in value:
      var val = key
      while true:
        val = val + i
        if inBounds(val, width, height):
          ttl.incl(val.tupToStr())
        else:
          val = key
          break
      while true:
        val = val - i
        if inBounds(val, width, height):
          ttl.incl(val.tupToStr())
        else: 
          break
  return ttl.len()
    
let 
  (ants, mat) = readInput()
  slopes = antSlopes(ants)
  pt1 = solution(mat, slopes)
  pt2 = solution2(slopes)
echo &"Solution 1: {pt1}\nSolution 2: {pt2}"

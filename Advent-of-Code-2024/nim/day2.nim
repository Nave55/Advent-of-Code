import strutils, strformat, sequtils, sugar

type IntSeq = seq[int]

proc readInput(): seq[IntSeq] =
  let file = open("input/day2.txt")
  defer: file.close()

  for i in file.lines():
    result &= i.splitWhitespace().map(item => parseInt(item))
         
func checkSafety(arr: IntSeq): bool =
  if arr.len <= 1:
    return true

  var
    is_inc_safe = true
    is_dec_safe = true

  for i in 0..<arr.len - 1:
    if not is_dec_safe and not is_inc_safe:
      break
    let val = arr[i] - arr[i + 1]
    if is_inc_safe:
      is_inc_safe = val >= 1 and val <= 3
    if is_dec_safe:
      is_dec_safe = val <= -1 and val >= -3

  return is_inc_safe or is_dec_safe

func checkSafetyTwo(arr: IntSeq): bool =
  if checkSafety(arr):
    return true

  for ind, _ in arr:
    var tmp = arr
    tmp.delete(ind)
    if checkSafety(tmp):
      return true


  return false

proc solution(): (int, int) =    
  let con = readInput()

  for i in con:
    if checkSafety(i):
      inc result[0]
    if checkSafetyTwo(i):
      inc result[1]

let (pt1, pt2) = solution()
echo &"Part 1: {pt1}\nPart 2: {pt2}"

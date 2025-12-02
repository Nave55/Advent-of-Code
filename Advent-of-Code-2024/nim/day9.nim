import strutils, strformat

type
  FileInfo = ref object
    val: int
    pos: int
    size: int
  SI = seq[int]
  SFI = seq[FileInfo]

proc readInput: (SI, SFI, SFI) =
  var
    f_val = 0
    idx = 0

  for ind, i in readFile("input/day9.txt").strip():
    let times = ord(i) - ord('0')
    if ind mod 2 == 0:
      for _ in 0 ..< times:
        result[0] &= f_val
      if times > 0:
        result[1] &= FileInfo(val: f_val, pos: idx, size: times)
        inc f_val
    else:
      for _ in 0 ..< times:
        result[0] &= -1
      if times > 0:
        result[2] &= FileInfo(val: -1, pos: idx, size: times)
    idx += times

proc solution(arr: var SI): int =
  var j = arr.len - 1

  for i in 0 ..< arr.len:
    if arr[i] == -1:
      while j > i and arr[j] < 0:
        dec j
      if j <= i:
        break
      arr[i] = arr[j]
      arr[j] = -1
    if arr[i] >= 0:
      result += i * arr[i]

proc solutionTwo(filled: var SFI, empty: var SFI): int =
  for i in countdown(filled.high, 0):
    for j in 0 ..< empty.len:
      if filled[i].pos <= empty[j].pos:
        break
      if filled[i].size <= empty[j].size:
        filled[i].pos = empty[j].pos
        empty[j].size -= filled[i].size
        empty[j].pos += filled[i].size
        break

  for i in filled:
    for ind in i.pos ..< i.pos + i.size:
      result += i.val * ind  

var (arr, filled, empty) = readInput()
let
  pt1 = solution(arr)
  pt2 = solutionTwo(filled, empty)

echo &"Part 1: {pt1}\nPart 2: {pt2}"

import sequtils, strutils, sugar, strformat, tables

type 
    SI = seq[int]
    SSI = seq[SI]
    HISI = Table[int, SI]
    
proc readInput(): (SSI, HISI) =
    let file = open("input/day5.txt", fmRead);
    defer: file.close()
  
    for i in file.lines():
      var t_map: SI = @[]
      if i != "" and i.contains("|"):
        t_map = i.split("|").map(item => item.parseInt())
        discard result[1].hasKeyOrPut(tmap[0], @[])
        result[1][t_map[0]] &= tmap[1]
      if i != "" and i.contains(","):
        result[0] &= i.split(",").map(item => item.parseInt())

proc sortArr(arr: SI, tab: HISI): (SI, bool) =
  var 
    sorted = false
    currentArr = arr
    no_changes = true

  while not sorted:
    sorted = true
    for i in currentArr:
      for k in tab.getOrDefault(i, @[]):
        let
          i_pos = currentArr.find(i)
          k_pos = currentArr.find(k)
        if k_pos != -1 and i_pos > k_pos:
          (currentArr[i_pos], currentArr[k_pos]) = (currentArr[k_pos], currentArr[i_pos])
          sorted = false
          no_changes = false

  return (currentArr, no_changes)

proc solution(mat: SSI, tab: HISI): (int, int) =
  for i in mat:
      let 
         (arr, sorted) = sortArr(i, tab)
         n = ((arr.len() - 1) / 2).int()
      if sorted: 
        result[0] += arr[n]
      else:          
        result[1] += arr[n]

let 
  (mat, tab) = readInput()
  (pt1, pt2) = solution(mat, tab)

echo &"Solution 1: {pt1}\nSolution 2: {pt2}"

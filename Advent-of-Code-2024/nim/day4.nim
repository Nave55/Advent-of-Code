import strutils, sequtils, strformat, tools

type SC = seq[seq[char]]
    
proc readInput(): SC =
  let file = open("input/day4.txt");
  defer: file.close()

  for i in file.lines():
      result &= i.toSeq()
    
proc checkXmas(matrix: SC): int =
  let
    width = matrix[0].len()
    height = matrix.len()
    dirs = [ 
      (-3, -3), (-2, -2), (-1, -1), (-3, 3), (-2, 2), (-1, 1), 
      (3, -3),  (2, -2),  (1, -1),  (3, 3),  (2, 2),  (1, 1), 
      (-3, 0),  (-2, 0),  (-1, 0),  (3, 0),  (2, 0),  (1, 0), 
      (0, -3),  (0, -2),  (0, -1),  (0, 3),  (0, 2),  (0, 1) 
    ]

  for r_ind, r_val in matrix:
    for c_ind, c_val in r_val:
      if c_val != 'X':
        continue
      var str = ""
      var cnt = 0
      for (x, y) in dirs:
        inc cnt
        let tmp = (x, y) + (r_ind, c_ind)
        if (tmp[0] >= 0 and tmp[0] < height) and (tmp[1] >= 0 and tmp[1] < width):
          str = str & arrValue(matrix, tmp)
        if cnt mod 3 == 0:
          str &= "X"
          if str == "XMAS" or str == "SAMX":
            inc result     
          str = ""

proc checkX(matrix: SC): int =
    for r_ind, r_val in matrix:
      for c_ind, c_val in r_val:
        if c_val != 'A':
          continue
        let tmp = nbrs(matrix, (r_ind, c_ind), diags)[1].join("")
        if tmp in ["MMSS", "SSMM", "SMSM", "MSMS"]:
          inc result

let hori = readInput()
let (pt1 , pt2) = (checkXmas(hori), checkX(hori))

echo &"Solution 1: {pt1}\nSolution 2: {pt2}"

import strformat, tools, tables, sets

type 
    AAC = array[130, array[130, char]]
    TI = tuple[x, y: int]
    TSI = Table[TI, int]
    HSI = HashSet[TI]
    
proc readInput(): (AAC, TI, TSI) =
    let file = open("input/day6.txt");
    defer: file.close()   

    var r_ind = 0
    for r_val in file.lines():
      var c_ind = 0
      for c_val in r_val:
        result[0][r_ind][c_ind] = c_val
        if c_val == '^':
          result[1] = (r_ind, c_ind)
        if c_val == '#':
          result[2][(r_ind, c_ind)] = 0
        inc c_ind
      inc r_ind 

var (mat, start, locs) = readInput()
let
  width = mat[0].len() - 1
  height = mat.len() - 1 
  dirs = [(-1, 0), (0, 1), (1, 0), (0, -1)]
  
proc pt1(mat: AAC, start: TI): (int, HSI) =
  var 
    facing = 0
    pos = start
  
  while (pos[0] in 1..<height) and (pos[1] in 1..<width):
    let next_pos = pos + dirs[facing] 
    if mat[next_pos.x][next_pos.y] == '#':
      inc facing
      facing = facing mod 4
    else:
      result[1].incl(pos)
      pos = next_pos
      
  result[1].incl(pos)
  result[0] = result[1].len()

proc pt2(mat: var AAC, start: TI, empty: HSI, locs: var TSI): int =
  for i in empty:
  
    var
      facing = 0
      pos = start
    mat[i.x][i.y] = '#'
    locs[i] = 0
      
    while (pos[0] in 1..<height) and (pos[1] in 1..<width):
      let next_pos = pos + dirs[facing]
      if mat[next_pos.x][next_pos.y] == '#':
        inc facing 
        inc locs[next_pos]
        if locs[next_pos] == 5:
          inc result
          break
        facing = facing mod 4
      else:
        pos = next_pos
        
    mat[i.x][i.y] = '.'
    for key in locs.keys:
      locs[key] = 0
    locs.del(i)

let 
  (p1, empty) = pt1(mat, start)
  p2 = pt2(mat, start, empty, locs)
echo &"Solution 1: {p1}\nSolution 2: {p2}"

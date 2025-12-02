import sequtils, strformat, sugar, tools, sets

type 
  TI = tuple[x, y: int]
  SI = seq[int]
  SSI = seq[SI]
  Visited = HashSet[TI]

proc readInput(filename: string): SSI =
  let file = open(filename, fmRead)
  defer: file.close()

  result = collect:
    for line in file.lines():
      line.toSeq().map(item => ord(item) - ord('0'))

func bfs(mat: SSI, pos: TI, visited: var Visited, target: int = 9): int =
  var localVisited = Visited()
  var queue: seq[TI]
  queue &= pos
  visited.incl(pos)
  localVisited.incl(pos)

  while queue.len() > 0:
    let current = queue.pop()
    if mat.fetchVal(current) == target:
      result += 1

    let (locs, nums) = nbrs(mat, current, udlr)
    for ind, val in locs:
      if nums[ind] == mat.fetchVal(current) + 1 and not localVisited.contains(val):
        queue &= val
        localVisited.incl(val)
        visited.incl(val)

func dfs(mat: SSI, pos: TI, visited: var Visited, targetHeight: int = 9): int =
  if mat.fetchVal(pos) == targetHeight:
    return 1

  visited.incl(pos)
  let (neighbors, _) = nbrs(mat, pos, udlr)
  for neighbor in neighbors:
    if neighbor notin visited and mat.fetchVal(neighbor) == mat.fetchVal(pos) + 1:
      result += dfs(mat, neighbor, visited)
  visited.excl(pos)
  
func solution(mat: SSI): (int, int) =
  var pt1_visited: Visited
  var pt2_visited: Visited

  for r_ind, r_val in mat:
    for c_ind, c_val in r_val:
      if c_val == 0: 
        if not pt1_visited.contains((r_ind, c_ind)):
          result[0] += bfs(mat, (r_ind, c_ind), pt1_visited)
        result[1] += dfs(mat, (r_ind, c_ind), pt2_visited)

let 
  mat = readInput("input/day10.txt")
  (pt1, pt2) = solution(mat)
echo &"Part 1: {pt1}\nPart 2: {pt2}"

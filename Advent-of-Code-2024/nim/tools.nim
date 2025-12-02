import Tables, strformat, strutils, sequtils

type 
    TI = tuple[x, y: int]
    # HTSTI = Table[TI, seq[TI]]
    # HCSTI = Table[char, seq[TI]]
    # SC = seq[char]
    # SSC = seq[SC]

func `+`* [T](a: seq[T], b: seq[T]): seq[T] =
    var c: seq[T] = @[];
    for i in 0..<a.len(): 
        c.add(a[i] + b[i])
    return c
    
func arrValue*[T](arr: seq[seq[T]], pos: TI): T =
    return arr[pos.x][pos.y]

func `+`* (a, b: TI): TI =
  return (a.x + b.x, a.y + b.y) 

func `-`* (a, b: TI): TI =
  return (a.x - b.x, a.y - b.y)

func `*`* (a: TI, num: int): TI =
  return (a.x * 2, a.y * 2) 

func `*`* (a, b: TI): TI =
  return (a.x * b.x, a.y * b.y)

func tupToStr*(tup: TI): string =
    return &"{tup.x},{tup.y}"

func strToTup*(str: string): TI =
    let tmp = str.split(",").mapIt(parseInt(it))
    return (tmp[0], tmp[1])

type Dirs* = enum
  diags, all, udlr

func inBounds*(tup: TI, width, height: int): bool =
  return (tup.x >= 0 and tup.x < height) and (tup.y >= 0 and tup.y < width)  

func fetchVal*[T](mat: seq[seq[T]], tup: TI): T =
  return mat[tup.x][tup.y]

func nbrs*[T](arr: seq[seq[T]], loc: TI, md: Dirs): (seq[TI], seq[T]) =
    var dir: seq[TI]
    if md == udlr: dir = @[(-1, 0), (1, 0), (0, -1), (0, 1)]
    elif md == all: dir = @[(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
    elif md == diags: dir = @[(-1, -1), (-1, 1), (1, -1), (1, 1)]
    for i in dir:
        let tmp = loc + i
        if inBounds(tmp, arr[0].len(), arr.len()):
            result[0] &= tmp
            result[1] &= fetchVal(arr, tmp)
    
proc getDiagonals*[T](matrix: seq[seq[T]]): seq[seq[T]] =
    let rows = matrix.len
    let cols = if rows > 0: matrix[0].len else: 0

    for k in 0..<rows:
        var diagonal: seq[T] = @[]
        for i in 0..min(rows - k, cols) - 1:
            diagonal &= (matrix[k + i][i])
        if diagonal.len > 0:
            result &= (diagonal)

    for k in 1..<cols:
        var diagonal: seq[T] = @[]
        for i in 0..min(rows, cols - k) - 1:
            diagonal &= (matrix[i][k + i])
        if diagonal.len > 0:
            result &= (diagonal)

    for k in 0..<rows:
        var diagonal: seq[T] = @[]
        for i in 0..min(rows - k, cols) - 1:
            diagonal &= (matrix[k + i][cols - 1 - i])
        if diagonal.len > 0:
            result &= (diagonal)

    for k in 1..<cols:
        var diagonal: seq[T] = @[]
        for i in 0..min(rows, cols - k) - 1:
            diagonal &= (matrix[i][cols - 1 - (k + i)])
        if diagonal.len > 0:
            result &= (diagonal)

proc getCols*[T](matrix: seq[seq[T]]): seq[seq[T]] =
    for c_ind, c_val in matrix:
        var tmp: seq[T] = @[]
        for r_ind, _ in c_val:
            tmp &= matrix[r_ind][c_ind]
        result &= tmp

proc findMatches*[T](matrix: seq[seq[T]], pattern: string, rev: bool): int =
    let window = pattern.len() - 1
    for c_ind, cval in matrix:
        let r_cval = c_val.reversed()
        for j in 0..<cval.len() - window:
            if cval[j..j+window].join("") == pattern:
                inc result
            if rev:
                if r_cval[j..j+window].join("") == "XMAS":
                    inc result

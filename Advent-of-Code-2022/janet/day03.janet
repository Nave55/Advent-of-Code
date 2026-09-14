(defn priority [x]
  (cond
    (and (>= x 65) (<= x 90)) (- x 38)
    (and (>= x 97) (<= x 122)) (- x 96)))

(defn sol [line]
  (let [len (/ (length line) 2)
        a @{}
        b @{}]

    (loop [i :in (string/slice line 0 len)] (put a i {}))
    (loop [i :in (string/slice line len)] (put b i {}))

    (label escape
      (loop [i :keys a]
        (when (b i)
          (return escape (priority i)))))))

(defn sol2 [lines]
  (let [a @{}
        b @{}
        c @{}]

    (loop [i :in (get lines 0)] (put a i {}))
    (loop [i :in (get lines 1)] (put b i {}))
    (loop [i :in (get lines 2)] (put c i {}))

    (label escape
      (loop [x :keys a]
        (when (and (b x) (c x))
          (return escape (priority x)))))))

(defn main [&]
  (with [fl (file/open "input/day3.txt")]
    (var pt1 0)
    (var pt2 0)
    (def arr @[])
    (loop [raw :iterate (file/read fl :line)
           :let [line (string/trimr raw)]]
      (array/push arr line)

      (+= pt1 (sol line))
      (when (= (length arr) 3)
        (+= pt2 (sol2 arr))
        (array/clear arr)))

    (print "Part 1: " pt1)
    (print "Part 2: " pt2)))

(defn parse-file [&]
  (with [fl (file/open "input/day5.txt")]
    (var ind 0)
    (let [inst @[]
          crates @[@[] @[] @[] @[] @[] @[] @[] @[] @[]]]

      (loop [raw :iterate (file/read fl :line)
             :let [line (string/trimr raw)]]

        (when (< ind 8)
          (def line (string/replace-all "[" "" line))
          (def line (string/replace-all "]" "" line))
          (def line (string/replace-all "    " "0" line))
          (def line (string/replace-all " " "" line))
          (loop [j :range [0 (length line)]]
            (def c (string/format "%c" (get line j)))
            (if (not= c "0")
              (array/insert (get crates j) 0 c))))

        (when (> ind 9)
          (def line (string/replace-all "move " "" line))
          (def line (string/replace-all " from " "," line))
          (def line (string/replace-all " to " "," line))
          (array/push inst (map scan-number (string/split "," line))))
        (+= ind 1))
      [inst crates])))

(defn ret [arr arr2 i] (get arr (- (get arr2 i) 1)))
(defn buffer-reduce [s v] (buffer/push s (get v (- (length v) 1))))

(defn solution [inst crates]
  (loop [i :in inst]
    (loop [j :range [0 (get i 0)]]
      (array/push (ret crates i 2) (array/pop (ret crates i 1)))))

  (reduce buffer-reduce @"" crates))

(defn solution2 [inst crates]
  (loop [i :in inst :let [from @[]]]
    (loop [j :range [0 (get i 0)]]
      (array/push from (array/pop (ret crates i 1))))
    (set
      (crates (- (get i 2) 1))
      (array/concat (ret crates i 2) (reverse from))))

  (reduce buffer-reduce @"" crates))

(defn main [&]
  (let [[inst crates] (parse-file)
        pt1 (solution inst crates)
        [inst crates] (parse-file)
        pt2 (solution2 inst crates)]
    (print "Part 1: " pt1)
    (print "Part 2: " pt2)))

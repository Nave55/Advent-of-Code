(defn day1 [&]
  (def arr @[])
  (with [fl (file/open "input/day1.txt")]
    (var tmp 0)
    (loop [raw :iterate (file/read fl :line)
           :let [line (string/trimr raw)]]
      (if (not= line "")
        (+= tmp (scan-number line))
        (do
          (array/push arr tmp)
          (set tmp 0))))
    (array/push arr tmp))

  (sort arr >)
  (let [pt1 (get arr 0)
        pt2 (sum (array/slice arr 0 3))]
    (print "Part 1: " pt1)
    (print "Part 2: " pt2)))

(defn main [&] (day1))

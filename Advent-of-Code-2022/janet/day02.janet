(defn day2 [&]
  (def win-lose
    @{["A" "X"] [4 3]
      ["B" "X"] [1 1]
      ["C" "X"] [7 2]
      ["A" "Y"] [8 4]
      ["B" "Y"] [5 5]
      ["C" "Y"] [2 6]
      ["A" "Z"] [3 8]
      ["B" "Z"] [9 9]
      ["C" "Z"] [6 7]})

  (var pt1 0)
  (var pt2 0)
  (with [fl (file/open "input/day2.txt")]
    (loop [raw :iterate (file/read fl :line)
           :let [line (string/trimr raw)]]
      (var you (string/slice line 0 1))
      (var me (string/slice line 2 3))
      (+= pt1 (get (win-lose [you me]) 0))
      (+= pt2 (get (win-lose [you me]) 1))))

  (print "Part 1: " pt1)
  (print "Part 2: " pt2))

(defn main [&] (day2))

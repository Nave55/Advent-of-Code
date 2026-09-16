(defn solution [str n]
  (label outer
    (loop [i :range-to [0 (- (length str) n)]
           :let [sli (string/slice str i (+ i n))
                 mp @{}]]

      (loop [j :in sli] (put mp j {}))
      (if (= (length mp) n)
        (return outer (+ i n))))))

(defn main [&]
  (def fl (string/trimr (slurp "input/day6.txt")))
  (print "Part 1: " (solution fl 4))
  (print "Part 2: " (solution fl 14)))

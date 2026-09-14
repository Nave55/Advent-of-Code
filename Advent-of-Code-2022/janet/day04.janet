(defn intersection [a b]
  (def c @[])
  (loop [key :keys a]
    (if (b key) (array/push c key)))
  c)

(defn day4 [&]
  (let [arr @[]]
    (with [fl (file/open "input/day4.txt")]
      (loop [raw :iterate (file/read fl :line)
             :let [line (string/replace-all "-" "," (string/trimr raw))]]
        (def tmp (map scan-number (string/split "," line)))
        (array/push arr tmp)))
    (var ttl1 0)
    (var ttl2 0)
    (loop [i :in arr
           :let [[a b c d] i]]
      (let [set1 @{}
            set2 @{}]
        (loop [j :range-to [a b]] (put set1 j {}))
        (loop [j :range-to [c d]] (put set2 j {}))
        (let [uset (merge set1 set2)
              iset (intersection set1 set2)]
          (if (or (deep= uset set1) (deep= uset set2)) (+= ttl1 1))
          (if (> (length iset) 0) (+= ttl2 1)))))

    (print "Part 1: " ttl1)
    (print "Part 2: " ttl2)))

(defn main [&] (day4))

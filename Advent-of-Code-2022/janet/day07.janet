(def peg
  ~{:main (split "\r\n" (+ :cd :size :other))
    :cd (* "$ " (capture (* "cd " (to -1))))
    :size (capture :d+)
    :other (* 1)})

(defn parse-file [&]
  (def arr (peg/match peg (slurp "input/day7.txt")))
  (let [dir @[]
        tmp_dir @[]
        dir_names @{}]
    (loop [i :in arr]
      (if (= (string/slice i 0 2) "cd")
        (do
          (if (not= (string/slice i 3 4) ".")
            (do
              (array/push tmp_dir (string/slice i 3))
              (put dir_names (string/join tmp_dir "-") {}))
            (array/pop tmp_dir)))
        (array/push dir [(string/join tmp_dir "-") (scan-number i)])))
    [dir dir_names]))

(defn main [&]
  (let [[dir dir_names] (parse-file)
        ttl (reduce
              (fn [acc key]
                (array/push
                  acc
                  (reduce
                    (fn [acc2 [l r]]
                      (if (< (string/find key l) (length l))
                        (+ acc2 r)
                        acc2))
                    0
                    dir))
                acc)
              @[]
              (keys dir_names))]

    (each i dir (pp i))

    (let [pt1 (sum (filter |(< $ 100_000) ttl))
          f |(>= $ (- (get (sort ttl >) 0) 40_000_000))
          pt2 (min ;(filter f ttl))]
      (print "Part 1: " pt1)
      (print "Part 2: " pt2))))

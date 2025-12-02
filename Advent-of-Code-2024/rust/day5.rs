use std::collections::HashMap;

type VI = Vec<i32>;
type VVI = Vec<VI>;
type HIVI = HashMap<i32, VI>;

fn main() {
    let (mp, mat) = parse_file();
    let (pt1, pt2) = solution(&mat, &mp);
    println!("Part 1: {pt1}\nPart 2: {pt2}")
}

fn parse_file() -> (HIVI, VVI) {
    let con = std::fs::read_to_string("../inputs/day5.txt").unwrap();
    let mut mp: HIVI = HashMap::new();
    let mut mat: VVI = Vec::new();
    for i in con.lines() {
        if i != "" {
            if i.contains("|") {
                let tmp: Vec<i32> = i.split("|").map(|s| s.parse::<i32>().unwrap()).collect();
                mp.entry(tmp[0]).or_insert_with(Vec::new).extend(&tmp[1..]);
            }
            if i.contains(",") {
                let tmp: Vec<i32> = i.split(",").map(|s| s.parse::<i32>().unwrap()).collect();
                mat.push(tmp);
            }
        }
    }
    (mp, mat)
}

fn sort_arr(arr: &VI, tab: &HIVI) -> (VI, bool) {
    let mut sorted = false;
    let mut current_arr = arr.clone();
    let mut no_changes = true;

    while !sorted {
        sorted = true;
        for i in 0..current_arr.len() {
            let value_i = current_arr[i];
            if let Some(keys) = tab.get(&value_i) {
                for &k in keys {
                    if let Some(k_pos) = current_arr.iter().position(|&x| x == k) {
                        if i > k_pos {
                            current_arr.swap(i, k_pos);
                            sorted = false;
                            no_changes = false;
                        }
                    }
                }
            }
        }
    }
    (current_arr, no_changes)
}

fn solution(mat: &VVI, tab: &HIVI) -> (i32, i32) {
    let mut pt1 = 0;
    let mut pt2 = 0;
    for i in mat {
        let (arr, sorted) = sort_arr(i, tab);
        let n = ((arr.len() - 1) / 2) as usize;
        if sorted {
            pt1 += arr[n];
        } else {
            pt2 += arr[n];
        }
    }

    (pt1, pt2)
}

use std::collections::{HashMap, HashSet};
use std::ops::{Add, Neg, Sub};

const WIDTH: usize = 50;
const HEIGHT: usize = 50;

type Ants = HashMap<char, Vec<Tup>>;
type Slope = HashMap<Tup, Vec<Tup>>;
type Mat = [[char; HEIGHT]; WIDTH];

#[derive(Debug, PartialEq, Eq, Hash, Clone, Copy)]
struct Tup {
    x: isize,
    y: isize,
}

fn main() {
    let (mat, ants) = parse_file();
    let slopes = ant_slopes(&ants);
    let pt1 = solution(&mat, &slopes);
    let pt2 = solution2(&slopes);
    println!("Part 1: {}\nPart 2: {}", pt1, pt2)
}

fn parse_file() -> (Mat, Ants) {
    let content = std::fs::read_to_string("inputs/day8.txt").expect("Failed to open file");
    let mut mp: Ants = HashMap::new();
    let mut arr = [['.'; HEIGHT]; WIDTH];

    for (r_ind, r_val) in content.lines().enumerate() {
        for (c_ind, c_val) in r_val.chars().enumerate() {
            arr[r_ind][c_ind] = c_val;
            if c_val != '.' {
                mp.entry(c_val).or_insert_with(Vec::new).push(Tup {
                    x: r_ind as isize,
                    y: c_ind as isize,
                });
            }
        }
    }

    (arr, mp)
}

impl Add for Tup {
    type Output = Tup;

    fn add(self, other: Tup) -> Tup {
        Tup {
            x: self.x + other.x,
            y: self.y + other.y,
        }
    }
}

impl Sub for Tup {
    type Output = Tup;

    fn sub(self, other: Tup) -> Tup {
        Tup {
            x: self.x - other.x,
            y: self.y - other.y,
        }
    }
}

impl Neg for Tup {
    type Output = Tup;

    fn neg(self) -> Tup {
        Tup {
            x: -self.x,
            y: -self.y,
        }
    }
}

impl Tup {
    fn mul_by_scalar(&self, s: isize) -> Tup {
        Tup {
            x: self.x * s,
            y: self.y * s,
        }
    }

    fn in_bounds(&self) -> bool {
        self.x >= 0 && self.x < HEIGHT as isize && self.y >= 0 && self.y < WIDTH as isize
    }

    fn arr_value(&self, mat: &Mat) -> char {
        mat[self.x as usize][self.y as usize]
    }

    fn insert_to_set(&self, mat: &Mat, symb: char, acc: &mut HashSet<Tup>) {
        if self.in_bounds() && self.arr_value(mat) != symb {
            acc.insert(*self);
        }
    }
}

fn ant_slopes(ants: &Ants) -> Slope {
    let mut slopes: Slope = HashMap::new();

    for value in ants.values() {
        for i in 0..value.len() - 1 {
            for j in (i + 1)..value.len() {
                slopes
                    .entry(value[i])
                    .or_insert_with(Vec::new)
                    .push(value[i] - value[j]);
            }
        }
    }

    slopes
}

fn solution(mat: &Mat, slopes: &Slope) -> usize {
    slopes
        .iter()
        .fold(HashSet::<Tup>::new(), |mut acc, (key, value)| {
            for i in value {
                let symb = key.arr_value(mat);
                let pos = *key + *i;
                let neg = *key - i.mul_by_scalar(2);

                pos.insert_to_set(mat, symb, &mut acc);
                neg.insert_to_set(mat, symb, &mut acc);
            }
            acc
        })
        .len()
}

fn walk(mut pos: Tup, step: Tup, acc: &mut HashSet<Tup>) {
    loop {
        pos = pos + step;
        if pos.in_bounds() {
            acc.insert(pos);
        } else {
            break;
        }
    }
}

fn solution2(slopes: &Slope) -> usize {
    slopes
        .iter()
        .fold(HashSet::<Tup>::new(), |mut acc, (key, value)| {
            acc.insert(*key);

            for i in value {
                walk(*key, *i, &mut acc);
                walk(*key, -*i, &mut acc);
            }

            acc
        })
        .len()
}

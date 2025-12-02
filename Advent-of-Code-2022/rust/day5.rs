fn main() {
    let (crates, inst) = parse_input();
    let pt1 = solution(&crates, &inst);
    let pt2 = solution2(&crates, &inst);
    println!("Part 1: {}\nPart 2: {}", pt1, pt2)
}

fn parse_input() -> (Vec<Vec<char>>, Vec<Vec<usize>>) {
    let input = std::fs::read_to_string("../inputs/day5.txt")
        .expect("Failed to read the file")
        .split("\r\n\r\n")
        .flat_map(|s| s.lines())
        .map(|line| {
            line.replace("[", "")
                .replace("]", "")
                .replace("    ", "0")
                .replace(" ", "")
                .replace("move", "")
                .replace("from", ",")
                .replace("to", ",")
        })
        .collect::<Vec<String>>();

    let mut crates = vec![Vec::new(); 9];

    for line in input.iter().take(8).cloned().collect::<Vec<String>>() {
        for (i, c) in line.chars().enumerate() {
            if c != '0' {
                crates[i].insert(0, c);
            }
        }
    }

    let instructions: Vec<Vec<usize>> = input
        .iter()
        .skip(9)
        .cloned()
        .collect::<Vec<String>>()
        .iter()
        .map(|s| {
            s.split(',')
                .map(|num| num.trim().parse::<usize>().unwrap())
                .collect()
        })
        .collect();

    (crates, instructions)
}

fn solution(crates: &Vec<Vec<char>>, inst: &Vec<Vec<usize>>) -> String {
    let mut arr = crates.clone();
    for i in inst {
        for _ in 0..i[0] {
            let tmp = arr[i[1] - 1].pop().unwrap();
            arr[i[2] - 1].push(tmp);
        }
    }

    arr.iter().map(|s| s.last().unwrap()).collect::<String>()
}

fn solution2(crates: &Vec<Vec<char>>, inst: &Vec<Vec<usize>>) -> String {
    let mut arr = crates.clone();
    for i in inst {
        let tmp = arr[i[1] - 1].len();
        let x = arr[i[1] - 1].split_off(tmp.saturating_sub(i[0]));
        arr[i[2] - 1].extend(x);
    }
    arr.iter().map(|s| s.last().unwrap()).collect::<String>()
}

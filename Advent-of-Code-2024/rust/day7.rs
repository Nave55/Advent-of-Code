type VI = Vec<i64>;
type VVI = Vec<VI>;

fn main() {
    let (nums, targets) = parse_file();
    let (pt1, pt2) = solution(&targets, &nums);
    println!("Part 1: {}\nPart 2: {}", pt1, pt2)
}

fn parse_file() -> (VVI, VI) {
    let content = std::fs::read_to_string("../inputs/day7.txt").expect("Failed to open file");

    let (nums, targets): (VVI, VI) = content
        .lines()
        .map(|line| {
            let mut items = line.split(": ").flat_map(|part| {
                part.split_whitespace()
                    .map(|item| item.parse::<i64>().unwrap())
            });

            let target = items.next().unwrap();
            let numbers = items.collect();
            (numbers, target)
        })
        .unzip();

    (nums, targets)
}

fn concat(a: i64, b: i64) -> i64 {
    format!("{}{}", a, b).parse::<i64>().unwrap()
}

fn evaluate(nums: &[i64], target: i64, index: usize, current_val: i64, pt1: bool) -> bool {
    if index == 0 {
        return evaluate(nums, target, index + 1, nums[0], pt1);
    }

    if index == nums.len() {
        return current_val == target;
    }

    let num = nums[index];

    if evaluate(nums, target, index + 1, current_val + num, pt1) {
        return true;
    }

    if evaluate(nums, target, index + 1, current_val * num, pt1) {
        return true;
    }

    if !pt1 && evaluate(nums, target, index + 1, concat(current_val, num), pt1) {
        return true;
    }

    false
}

fn solution(a: &VI, b: &VVI) -> (i64, i64) {
    let mut ttl: i64 = 0;
    let mut ttl2: i64 = 0;

    for (ind, vals) in b.iter().enumerate() {
        if evaluate(&vals[0..], a[ind], 0, 0, true) {
            ttl += a[ind]
        }
        if evaluate(&vals[0..], a[ind], 0, 0, false) {
            ttl2 += a[ind]
        }
    }

    return (ttl, ttl2);
}

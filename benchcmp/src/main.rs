#![feature(test)]

//learn from https://medium.com/@james_32022/unit-tests-and-benchmarks-in-rust-f5de0a0ea19a

extern crate test;
use rand::{thread_rng, Rng};
use test::Bencher;

pub fn random_vector(i: i32) -> Vec<i32> {
    let mut numbers: Vec<i32> = Vec::new();
    let mut rng = rand::thread_rng();
    for i in 0..i {
        numbers.push(rng.gen());
    }
    return numbers;
}

pub fn swap(numbers: &mut Vec<i32>, i: usize, j: usize) {
    let temp = numbers[i];
    numbers[i] = numbers[j];
    numbers[j] = temp;
}

pub fn insertion_sorter(numbers: &mut Vec<i32>) {
    for i in 1..numbers.len() {
        let mut j = i;
        while j > 0 && numbers[j - 1] > numbers[j] {
            swap(numbers, j, j - 1);
            j = j - 1;
        }
    }
}

#[bench]
fn bench_insertion_sort_100_ints(b: &mut Bencher) {
    b.iter(|| {
        let mut numbers: Vec<i32> = random_vector(100);
        insertion_sorter(&mut numbers)
    });
}

fn main() {}

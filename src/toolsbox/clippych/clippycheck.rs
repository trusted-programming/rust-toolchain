//#![deny(clippy::all)]
//#![warn(clippy::all)]
//#![allow(clippy::all)]
#![allow(dead_code)]

// Checks for comparisons where one side of the relation is either the
// minimum or maximum value for its type and warns if it involves a
// case that is always true or always false. Only integer and boolean types are checked.
#[rustfmt::skip]
#[warn(clippy::absurd_extreme_comparisons)]
fn absurd_extreme_comparisons() {
    let vec: Vec<isize> = Vec::new();
    if vec.len() <= 0 {}
    if 100 > i32::MAX {}
}

// Checks for foo = bar; bar = foo sequences.
#[rustfmt::skip]
#[warn(clippy::almost_swapped)]
fn almost_swapped() {
    let mut a = 1;
    let mut b = 2;
    a = b;
    b = a;
}

// Checks for floating point literals that
// approximate constants which are defined in std::f32::consts
// or std::f64::consts, respectively, suggesting to use the predefined constant.
#[rustfmt::skip]
#[warn(clippy::approx_constant)]
fn approx_constant() {
    let x = 3.14;
    let y = 1_f64 / x;
}

// Checks for usage of as conversions.
#[rustfmt::skip]
#[warn(clippy::as_conversions)]
fn as_conversions() {
    fn f(a: i16) {
        let _s = a;
    }
    let a: i32 = i32::MAX;
    f(a as i16);
}

// Checks for assert!(true) and assert!(false) calls.
#[rustfmt::skip]
#[warn(clippy::assertions_on_constants)]
fn assertions_on_constants() {
    assert!(false);
    assert!(true);
    const B: bool = false;
    assert!(B)
}

// Checks for a = a op b or a = b commutative_op a patterns.
#[rustfmt::skip]
#[warn(clippy::assign_op_pattern)]
fn assign_op_pattern() {
    let mut a = 5;
    let b = 0;

    // Bad
    a = a + b;

    // Good
    a += b;
}

// Checks for async blocks that yield values of types that can themselves be awaited.
#[rustfmt::skip]
#[warn(clippy::async_yields_async)]
fn async_yields_async() {
    async fn foo() {}

    fn bar() {
        let x = async { foo() };
    }
}

// Checks for calls to await while holding a non-async-aware MutexGuard.
#[rustfmt::skip]
#[warn(clippy::await_holding_lock)]
fn await_holding_lock() {
    use std::sync::Mutex;
    async fn bad(x: &Mutex<u32>) -> u32 {
        let guard = x.lock().unwrap();
        baz().await
    }
    async fn good(x: &Mutex<u32>) -> u32 {
        {
            let guard = x.lock().unwrap();
            let y = *guard + 1;
        }
        baz().await;
        let guard = x.lock().unwrap();
        47
    }
    async fn baz() -> u32 {
        42
    }
}

// Checks for calls to await while holding a RefCell Ref or RefMut.
#[rustfmt::skip]
#[warn(clippy::await_holding_refcell_ref)]
fn await_holding_refcell_ref() {
    use std::cell::RefCell;
    async fn bad(x: &RefCell<u32>) -> u32 {
        let b = x.borrow();
        baz().await
    }
    async fn bad_mut(x: &RefCell<u32>) -> u32 {
        let b = x.borrow_mut();
        baz().await
    }
    async fn baz() -> u32 {
        42
    }
}

#[warn(clippy::bad_bit_mask)]
#[allow(
    clippy::ineffective_bit_mask,
    clippy::identity_op,
    clippy::no_effect,
    clippy::unnecessary_operation,
    clippy::erasing_op,
)]
#[rustfmt::skip]
fn bad_bit_mask() {
    let x = 5;

    x & 0 == 0;
    x & 1 == 1; //ok, distinguishes bit 0
    x & 1 == 0; //ok, compared with zero
    x & 2 == 1;
    x | 0 == 0; //ok, equals x == 0 (maybe warn?)
    x | 1 == 3; //ok, equals x == 2 || x == 3
    x | 3 == 3; //ok, equals x <= 3
    x | 3 == 2;
}

#[rustfmt::skip]
#[warn(clippy::bind_instead_of_map)]
fn bind_instead_of_map() {
    let x = Some(5);
    let _ = x.and_then(Some);
    let _ = x.and_then(|o| Some(o + 1));
}

#[allow(
    clippy::similar_names,
    clippy::single_match,
    clippy::toplevel_ref_arg,
    unused_mut,
    unused_variables
)]
#[rustfmt::skip]
#[warn(clippy::blacklisted_name)]
fn blacklisted_name() {
    let foo = 3.16;
}

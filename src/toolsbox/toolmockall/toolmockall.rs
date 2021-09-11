#[allow(dead_code)]
#[cfg(test)]
use mockall::{automock, predicate::*};
#[cfg_attr(test, automock)]
trait MyTrait {
    fn foo(&self, x: u32) -> u32;
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn mytest() {
        let mut mock = MockMyTrait::new();
        mock.expect_foo().with(eq(4)).times(1).returning(|x| x + 1);
        assert_eq!(5, mock.foo(4));
    }
}

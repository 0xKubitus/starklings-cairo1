// move_semantics5.cairo

// Make me compile only by reordering the lines in `main()`,
// but without adding, changing or removing any of them.

// Execute `starklings hint move_semantics5` or use the `hint` watch subcommand for a hint.


use array::ArrayTrait;

#[test]
fn main() {
    let mut a = ArrayTrait::new();

    pass_by_ref(ref a); // here, pass_by_ref() uses mutable referencing -> it returns ownership to the calling context at the end of its execution.

    pass_by_snapshot(@a); // here, pass_by_snapshot() uses only a snapshot of `a` (an immutable view of a value at a certain point in time) -> the ownership of `a` remains in the main() function.

    let mut b = pass_by_value(a); // now, pass_by_value() does take ownership of `a` or "moves a". -> after this function is executed, `a` can't be accessed anymore (it is "dropped" out of the scope).

    pass_by_ref(ref b);
}

fn pass_by_value(mut arr: Array<felt252>) -> Array<felt252> {
    arr
}

fn pass_by_ref(ref arr: Array<felt252>) {}

fn pass_by_snapshot(x: @Array<felt252>) {}

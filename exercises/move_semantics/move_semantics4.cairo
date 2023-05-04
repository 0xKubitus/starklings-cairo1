// move_semantics4.cairo

// Refactor this code so that instead of passing `arr0` into the `fill_arr` function,
// the Array gets created in the function itself and passed back to the main function.

// Execute `starklings hint move_semantics4` or use the `hint` watch subcommand for a hint.



use array::ArrayTrait;
use array::ArrayTCloneImpl;
use array::SpanTrait;
use clone::Clone;
use debug::PrintTrait;

fn main() {

    let mut arr1 = fill_arr();

    // arr1.print(); // <= obviously this won't work...
    arr1.clone().print(); // ... but this will! ;)

    arr1.append(88);

    arr1.clone().print();
}


fn fill_arr() -> Array<felt252> {
    let mut arr = ArrayTrait::<felt252>::new();

    arr.append(22);
    arr.append(44);
    arr.append(66);

    arr
}

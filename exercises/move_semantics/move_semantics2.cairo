// move_semantics2.cairo

///////////////////////////////////////////////////////////////////////////////
// In Cairo, when an argument is passed to a function and it's not explicitly returned, you can't use the original variable anymore.
// We call this "moving" a variable.
// Variables that are moved into a function (or block scope) and aren't explicitly returned get "dropped" at the end of that function.
// This is also what happens here.

// There are 3 ways to fix this:
// 1. Make another, separate version of the data that's in `arr0` and pass that to `fill_array()` instead.

// 2. Make `fill_array()` *mutably* borrow a reference to its argument (which will need to be mutable)
// with the `ref` keyword, modify it directly, then not return anything.
// Then you can get rid of `arr1` entirely -- note that this will change what gets printed by the first `print`.

// 3. Make `fill_array()` borrow an immutable view of its argument instead of taking ownership by using the snapshot operator `@`,
// and then copy the data within the function in order to return an owned `Array<felt>`.
// This requires an explicit clone of the array and should generally be avoided in Cairo, 
// as the memory is write-once and cloning can be expensive.
// To clone an object, you will need to import the trait `clone::Clone`,
// as well as the implementation of the Clone trait for the array located in `array::ArrayTCloneImpl`
///////////////////////////////////////////////////////////////////////////////

// // INITIAL SITUATION 

// use array::ArrayTrait;
// use debug::PrintTrait;


// fn main() {
//     let arr0 = ArrayTrait::new();

//     // In the below line, `arr0` is passed into the `fill_array()` function as an argument => this will trigger an error!
//     let mut arr1 = fill_array(arr0);

//     // Do not change the following line!
//     arr0.print();
// }

// fn fill_array(arr: Array<felt252>) -> Array<felt252> {
//     let mut arr = arr;

//     arr.append(22);
//     arr.append(44);
//     arr.append(66);

//     arr
// }

///////////////////////////////////////////////////////////////////////////////
// SOLUTION 1: Create a clone of the original array (https://cairo-book.github.io/ch03-01-what-is-ownership.html#copy-array-data-with-clone)

// use array::ArrayTrait;
// use debug::PrintTrait;
// use clone::Clone; // new method to import
// use array::ArrayTCloneImpl; // new method to import

// fn main() {
//    let arr0 = ArrayTrait::new();

//    let mut solution1 = arr0.clone();
//    let mut arr1 = fill_array(solution1);

//     arr0.print();
// }

// fn fill_array(arr: Array<felt252>) -> Array<felt252> {
//     let mut arr = arr;

//     arr.append(22);
//     arr.append(44);
//     arr.append(66);

//     arr
// }
///////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////
// SOLUTION 2: Using a "Mutable Reference" of the original array (https://cairo-book.github.io/ch03-02-references-and-snapshots.html#mutable-references)

// use array::ArrayTrait;
// use debug::PrintTrait;

// fn main() {
//     let mut arr0 = ArrayTrait::new(); // here 'arr0' needs to be mutable...

//     fill_array(ref arr0); // ...because we're using it here as a mutable reference!

//     arr0.print();
// }

// fn fill_array(ref arr: Array<felt252>) {
//     arr.append(22);
//     arr.append(44);
//     arr.append(66);

//     // no need to return anything here =>
//     // "using mutable references allows you to mutate the value passed while keeping ownership of it by returning it automatically at the end of the execution" -> cairo-books.github.io
// }
///////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////
// SOLUTION 3: Using a "Span" (https://cairo-book.github.io/ch02-06-common-collections.html?highlight=span#span),
// which is a "Snapshot" of the original array (https://cairo-book.github.io/ch03-02-references-and-snapshots.html#snapshots)

use array::ArrayTrait;
use debug::PrintTrait;
use clone::Clone; // new method to import
use array::ArrayTCloneImpl; // new method to import
use array::SpanTrait; // new method to import

fn main() {
    let arr0 = ArrayTrait::new();

    let mut arr1 = fill_array(arr0.span().snapshot.clone());

    arr0.print();

    arr1.append(88);

    arr1.span().snapshot.clone().print();
}

fn fill_array(arr: Array<felt252>) -> Array<felt252> {
    let mut arr = arr;

    arr.append(22);
    arr.append(44);
    arr.append(66);

    arr
}
///////////////////////////////////////////////////////////////////////////////

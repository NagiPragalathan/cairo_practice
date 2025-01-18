use core::nullable::NullableTrait;
use core::dict::{Felt252Dict, Felt252DictEntryTrait};

fn append_value(ref dict: Felt252Dict<Nullable<Array<u8>>>, index: felt252, value: u8) {
    let (entry, arr) = dict.entry(index);
    let mut unboxed_val = arr.deref_or(array![]);
    unboxed_val.append(value);
    dict = entry.finalize(NullableTrait::new(unboxed_val));
}

fn get_array_entry(ref dict: Felt252Dict<Nullable<Array<u8>>>, index: felt252) -> Span<u8> {
    let (entry, _arr) = dict.entry(index);
    let mut arr = _arr.deref_or(array![]);
    let span = arr.span();
    dict = entry.finalize(NullableTrait::new(arr));
    span
}

fn main() {
    let mut arr = array![20, 19, 26];
    arr.append(30); 
    let mut dict: Felt252Dict<Nullable<Array<u8>>> = Default::default();
    dict.insert(0, NullableTrait::new(arr));
    println!("Before insertion: {:?}", get_array_entry(ref dict, 0));

    append_value(ref dict, 0, 30);

    println!("After insertion: {:?}", get_array_entry(ref dict, 0));
}

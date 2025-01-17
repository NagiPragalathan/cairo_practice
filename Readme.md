Documentation: https://book.cairo-lang.org/ch02-01-variables-and-mutability.html#shadowing

create project  
scarb new my_project

build project
scarb build

run project
scarb run

test project
scarb test


it will automaticaly run the src/lib.cairo file
scarb cairo-run




-----------------------------------------
    /*
    Cairo has three primary scalar types: felts, integers, and booleans

    ...  Integer Types in Cairo  ...
    Length	Unsigned
    8-bit	u8
    16-bit	u16
    32-bit	u32
    64-bit	u64
    128-bit	u128
    256-bit	u256
    32-bit	usize
    ...                          ...

    Boolean Types in Cairo
    ...
    let f: bool = false; // also can use int 0
    let t: bool = true; // also can use int 1
    ...

    ByteArray Types in Cairo:
    the type for handling strings and byte sequences longer than short strings...
    ByteArray strings can contain more than 31 characters and are written using double quotes:
    */
    // ByteArray
-----------------------------------------
Documentation: https://book.cairo-lang.org/ch02-01-variables-and-mutability.html#shadowing

Before run the project, you need to start the katana server
katana --dev --dev.no-fee --http.cors_origins '*'


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


to generate the type script file for the contract



torii -w 0x0525177c8afe8680d7ad1da30ca183e482cfcd6404c1e09d83fd3fa2994fd4b8 --http.cors_origins '*'
0x0525177c8afe8680d7ad1da30ca183e482cfcd6404c1e09d83fd3fa2994fd4b8

DOJO_MANIFEST_PATH="../Scarb.toml" sozo build --typescript --bindings-output ./src/dojo/


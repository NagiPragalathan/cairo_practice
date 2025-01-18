/// for single line comment use //
/// for item level line comment use ///
/// for module level comment use //! 
/// 
/// example:
/// 
//! This is a module level comment.
/// mod main() {
/// }



fn variables() {
    // two types of variables => mut: it's mention that the variable is modifiable. else we cant change the value of variable
    let a = 10;
    let b = 20;
    let mut c = 30;
    // the scope of the variable is limited to the block of code. *variable Shadowing*
    {
        let a = a + 5;
        println!("{}", a);
    }
    // the format string is must to print the values. the string should be exist ! 
    println!("before: {}", a + b + c);
    c = 40;
    println!("after: {}", a + b + c);
}


///     Cairo has three primary scalar types: felts, integers, and booleans
///     ...  Integer Types in Cairo  ...
///     Length	Unsigned
///     8-bit	u8
///     16-bit	u16
///     32-bit	u32
///     64-bit	u64
///     128-bit	u128
///     256-bit	u256
///     32-bit	usize
///     ...                          ...
///     Boolean Types in Cairo
///     ...
///     let f: bool = false; // also can use int 0
///     let t: bool = true; // also can use int 1
///     ...
///     ByteArray Types in Cairo:
///     the type for handling strings and byte sequences longer than short strings...
///     ByteArray strings can contain more than 31 characters and are written using double quotes:
///     ...
/// 
///     compound Types:
///     ...
///     
/// 
fn data_type(){

    let sample_name: ByteArray = "John";
    println!("{}", sample_name);

    // Tuples
    let tup = (1, 'hi', true);
    let (a, b, c) = tup;
    println!("{}", c);
    // tuple with types
    let tup: (bool, u8, u8) = (true, 1, 2);
    // tuple type assignment
    let (a, b, c): (bool, ByteArray, u8) = (true, "tup", 3);
    println!("{}", b);

}

fn arrays_practice(){
    let arr: [u8; 5] = [1, 2, 3, 4, 5];
    let months = [
        'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September',
        'October', 'November', 'December',
    ];
    let a = [3; 5];
    let index_span = months.span();
    println!("{}", index_span[0]);
}

fn data_type_conversion_practice(){
    //  when the source type is smaller than the destination type. we can use the into() method to convert the type.
    let mut a: u8 = 10;
    let b: u16 = a.into();
    println!("{}", b);

    // when the source type is larger than the destination type. we can use the try_into() method to convert the type.
    let mut a: u16 = 10;
    let b: u8 = a.try_into().unwrap();
    println!("{}", b);
}

fn main() {
    // variables();
    // data_type();
    // arrays_practice();
    data_type_conversion_practice();
}

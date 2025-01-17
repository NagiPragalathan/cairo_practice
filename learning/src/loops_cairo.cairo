// increament i += 1
// decreament i -= 1

fn print_tables(a: u8){
    let mut i: u8 = 0;
    loop{
        if i > 10{
            break;
        }
        println!("{} x {} = {}", a, i, a*i);
        i = i + 1;
    }
}

fn while_print_tables(a: u8){
    let mut i: u8 = 0;
    while i < 10{
        println!("{} x {} = {}", a, i, a*i);
        i = i + 1;
    }
}

fn for_print_tables(a: u8){
    for i in 0..a{
        println!("{} x {} = {}", a, i, a*i);
    }
}

fn for_array_print(a: [u8; 10]){
    let index_span = a.span();
    for i in index_span{
        println!("{}", i);
    }
}

fn main(){
    let a: u8 = 10;
    // loop{
    //     println!("again !");
    // }
    // print_tables(a);
    // while_print_tables(a);
    // for_print_tables(a);
    for_array_print([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
}
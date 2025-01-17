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

fn main(){
    let a: u8 = 10;
    // loop{
    //     println!("again !");
    // }
    // print_tables(a);
    while_print_tables(a);
}
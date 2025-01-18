
fn simple_if(a: u8, b: u8){
    if a < b{
        println!("a is greater than b");
    }
}


fn var_check(a: u8, b: u8){
    let out: u8 = if a > b{
        a
    }
    else{
        b
    };
    println!("{}", out);
}

fn main(){
    let a: u8 = 10;
    let b: u8 = 20;
    simple_if(a, b);
    var_check(a, b);
}

// functions calls


fn add(a: u8, b: u8) -> u8{
    return a + b;
}
fn sub(sub_a: u8, sub_b: u8) -> u8{
    return sub_a - sub_b;
}

fn scope_fun_ex(x: u8){
    let a: u8 = {
        let b: u8 = x;
        b
    };
    println!("{}", a);
}

fn internal_scope_fun_ex(x: u8){
    let a: u8 = x;
    {
        let a: u8 = a + 20;
        println!("{}", a);
    }
    println!("{}", a);
}

fn main(){
    scope_fun_ex(10);
    internal_scope_fun_ex(10); // Expected output: 30, 10
    // let a:u8 = 20;
    // let b:u8 = 20; 
    // println!("{}", add(:a, :b));
    // println!("{}", sub(sub_a:a, sub_b:b));
}
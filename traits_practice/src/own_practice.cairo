#[derive(Drop)]
struct Square{
    pub side: u32
}

pub trait Area<T>{
    fn calculate_area(self: @T) -> u32;
}

impl AreaFunctions of Area<Square>{
    fn calculate_area(self: @Square) -> u32{
        *self.side * *self.side
    }
}

fn main(){
    let create_square = Square{side: 10};
    println!("{}", create_square.calculate_area());
}
// fn calculate_area(square: Square) -> u32{
//     *square.side * *square.side
// }


use starknet::{ContractAddress};

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct Settings {
    #[key]
    pub player: ContractAddress,
    pub mode: u32,
    pub difficulty: u32,
    pub number_of_blocks: u32
}

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct PlayerPosition {
    #[key]
    pub player: ContractAddress,
    pub x_position: u64,
    pub y_position: u64,    
    pub z_position: u64
}

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct GameScore {
    #[key]
    pub player: ContractAddress,
    pub score: u64,
    pub high_score: u64
}


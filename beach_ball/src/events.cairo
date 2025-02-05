use starknet::{ContractAddress};

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::event]
pub struct UpdatedGameScore {
    #[key]
    pub player: ContractAddress,    
    pub score: u64,
    pub high_score: u64
}

#[derive(Copy, Drop, Serde)]
#[dojo::event]
pub struct UpdatedSettings {
    #[key]
    pub player: ContractAddress,
    pub mode: u32,
    pub difficulty: u32,
    pub number_of_blocks: u32
}

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::event]
pub struct HistoryPlayerPosition {
    #[key]
    pub player: ContractAddress,
    pub x_position: u64,
    pub y_position: u64,    
    pub z_position: u64
}

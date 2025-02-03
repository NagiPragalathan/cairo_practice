use starknet::{ContractAddress};

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct Player {
    #[key]
    pub player: ContractAddress,
    pub name: felt252, // using felt252 instead of String
    pub health: u32,
    pub tool: felt252
}


// player model
// tile model

use starknet::ContractAddress;

const TIME_BETWEEN_ACTIONS: u64 = 120;

#[drive(Copy, Drop, Serde)]
#[dojo::model]
struct Player {
    #[key]
    address: starknet::ContractAddress,
    player: u32,
    last_action: u64
}

#[derive(Copy, Drop, Serde)]
#[dojo::model]
struct Tile {
    #[key]
    x: u16,
    #[key]
    y: u16,
    color: felt252
}


#[generate_trait]
impl Player of PlayerTrait {
    fn check_can_place(self: Player){
        if starknet::get_block_timestamp() - self.last_action > TIME_BETWEEN_ACTIONS {
            panic!("Player cannot place");
        }
    }
}

// systems
// start by defining the dojo interface

#[starknet::interface]
trait IActions{
    fn spawn();
    fn paint(x: u16, y: u16, color: felt252);
}


#[dojo::contract]
mod actions {
    use super::IActions;
    use starknet::{ContractAddress, get_caller_address, get_block_timestamp};
    use super::{tile::Tile, player::Player};

    #[abi(embed_v0)] // going to implement our functions here

    impl IActionsImpl of IActions<ContractState>{
        fn spawn(world: IWorldDispatcher){
            let address = get_caller_address();
            let player = world.uuid();
            let existing_player = get!(world, [address], Player);

            assert(existing_player.last_action == 0, "Player Already Exists");

            let last_action = get_block_timestamp();

            set!(world, Player{
                address,
                player,
                last_action
            });
        }

        fn paint(world: IWorldDispatcher, x: u16, y:u16, color: felt252){
            let address = get_caller_address();
            let player = get!(world, [address], Player);
            assert(player.address == get_caller_address(), "Action: not a player");
            set!(world, Tile{x, y, color});
        }
    }

} 
 
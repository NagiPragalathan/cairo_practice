use dojo_starter::models::{Player};
use starknet::{ContractAddress, get_caller_address};

// define the interface
#[starknet::interface]
pub trait IActions<T> {
    fn add_player(ref self: T);
    fn update_player(ref self: T,  health: u32, tool: felt252);
}

// dojo decorator
#[dojo::contract]
pub mod actions {
    use super::{IActions, Player};
    use starknet::{ContractAddress, get_caller_address};

    use dojo::model::{ModelStorage};
    use dojo::event::EventStorage;

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct UpdatedPlayer {
        #[key]
        pub player: ContractAddress,
        pub health: u32,
        pub tool: felt252
    }

    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn add_player(ref self: ContractState) {
            // Get the default world.
            let mut world = self.world_default();

            // Get the address of the current caller, possibly the player's address.
            let player = get_caller_address();

            //msg.sender
            // Retrieve the player's current position from the world.
            let newplayer = Player{player: player, name: 'John', health: 100, tool: 'Sword'};


            // Write the new position to the world.
            world.write_model(@newplayer);

        }

       

        // Implementation of the move function for the ContractState struct.
        fn update_player(ref self: ContractState,  health: u32, tool: felt252) {
            // Get the address of the current caller, possibly the player's address.

            let mut world = self.world_default();

            let playerAddress = get_caller_address();

            let mut player: Player = world.read_model(playerAddress);
            player.health = health;
            player.tool = tool;
            world.write_model(@player);

       
            // if player hasn't spawn, read returns model default values. This leads to sub overflow
            // afterwards.
            // Plus it's generally considered as a good pratice to fast-return on matching
    

            // Emit an event to the world to notify about the player's move.
            world.emit_event(@UpdatedPlayer { player: playerAddress, health, tool });
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        /// Use the default namespace "dojo_starter". This function is handy since the ByteArray
        /// can't be const.
        fn world_default(self: @ContractState) -> dojo::world::WorldStorage {
            self.world(@"dojo_starter")
        }
    }
}


// creating a model for the player
#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Player{
    #[key]
    pub player_id: u32,
    pub name: felt252, // using felt252 instead of String
    pub health: u32,
    pub tool: felt252
}

// creating a trait for the actions
#[starknet::interface]
trait IActions<T> {
    fn add_player(ref self: T);
    fn update_player(ref self: T, player_id: u32, health: u32, tool: felt252);
    fn get_player(ref self: T, player_id: u32) -> Player;
}

// creating a contract for the actions
#[dojo::contract]
pub mod actions {
    use super::{IActions, Player};
    use starknet::{ContractAddress, get_caller_address};

    use dojo::model::{ModelStorage, ModelValueStorage}; // ModelStorage is used to store the models we should import it from dojo
    use dojo::event::EventStorage;
    
    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn add_player(ref self: ContractState) {
            let mut world = self.world_default();
            let player = Player{player_id: 1, name: 'John', health: 100, tool: 'Sword'};
            world.write_model(@player);
        }
        fn update_player(ref self: ContractState, player_id: u32, health: u32, tool: felt252) {
            let mut world = self.world_default();
            let mut player: Player = world.read_model(player_id);
            player.health = health;
            player.tool = tool;
            world.write_model(@player);
        }
        fn get_player(ref self: ContractState, player_id: u32) -> Player {
            let mut world = self.world_default();
            let player: Player = world.read_model(player_id);
            return player;
        }
    }
    
    // here we are declaring the trait for the world storage [creating world storage]
    #[generate_trait]
    impl InternalImpl of InternalTrait {
        /// Use the default namespace "dojo_starter". This function is handy since the ByteArray
        /// can't be const.
        fn world_default(self: @ContractState) -> dojo::world::WorldStorage {
            self.world(@"dojo_starter")
        }
    }
}

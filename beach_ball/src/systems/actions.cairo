use crate::models::{Settings, PlayerPosition, GameScore};
use starknet::{ContractAddress, get_caller_address};
use crate::events::{UpdatedSettings, HistoryPlayerPosition, UpdatedGameScore};

#[starknet::interface]
pub trait IActions<T> {
    // settings functions
    fn add_settings(ref self: T);
    fn update_settings(ref self: T, mode: u32, difficulty: u32, number_of_blocks: u32);

    // player position functions
    fn player_position(ref self: T, x_position: u64, y_position: u64, z_position: u64);

    // game score functions
    fn add_game_score(ref self: T, score: u64, high_score: u64);
}

#[dojo::contract]
pub mod actions {
    use super::{IActions, Settings, PlayerPosition, UpdatedSettings, GameScore, HistoryPlayerPosition, UpdatedGameScore};
    use starknet::{ContractAddress, get_caller_address};
    use dojo::model::{ModelStorage};
    use dojo::event::EventStorage;

    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        // settings functions
        fn add_settings(ref self: ContractState) {
            let mut world = self.world_default();
            let player = get_caller_address();
            let newplayer = Settings{player: player, mode: 1, difficulty: 1, number_of_blocks: 1};

            world.write_model(@newplayer);
        }

        fn update_settings(ref self: ContractState, mode: u32, difficulty: u32, number_of_blocks: u32) {
            let mut world = self.world_default();
            let playerAddress = get_caller_address();
            let mut player: Settings = world.read_model(playerAddress);

            player.mode = mode;
            player.difficulty = difficulty;
            player.number_of_blocks = number_of_blocks;

            world.write_model(@player);
            world.emit_event(@UpdatedSettings { player: playerAddress, mode, difficulty, number_of_blocks });
        }

        // player position functions
        fn player_position(ref self: ContractState, x_position: u64, y_position: u64, z_position: u64) {
            let mut world = self.world_default();
            let playerAddress = get_caller_address();
            let newplayer = PlayerPosition{player: playerAddress, x_position, y_position, z_position};

            world.write_model(@newplayer);
            world.emit_event(@HistoryPlayerPosition { player: playerAddress, x_position, y_position, z_position });
        }

        // game score functions
        fn add_game_score(ref self: ContractState, score: u64, high_score: u64) {
            let mut world = self.world_default();
            let playerAddress = get_caller_address();
            let newplayer = GameScore{player: playerAddress, score, high_score};

            world.write_model(@newplayer);
            world.emit_event(@UpdatedGameScore { player: playerAddress, score, high_score });
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn world_default(self: @ContractState) -> dojo::world::WorldStorage {
            self.world(@"beach_ball")
        }
    }
}

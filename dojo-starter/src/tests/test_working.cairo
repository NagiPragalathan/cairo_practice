use starknet::ContractAddress;  

#[derive(Drop, Serde)]
#[dojo::model]
struct Moves {
    #[key]
    player: ContractAddress,
    remaining: u8,
}

// ---- Working ----


#[derive(Copy, Drop, Serde)]
#[dojo::model]
struct Resource {
    #[key] 
    player: ContractAddress,
    #[key] 
    location: ContractAddress,
    balance: u8,
}

const GAME_SETTINGS_ID: u32 = 999;
 
#[derive(Copy, Drop, Serde)]
#[dojo::model]
struct GameSettings {
    #[key]
    game_settings_id: u32,
    combat_cool_down: u32,
}

// ---- Working ----


#[derive(Copy, Drop, Serde)]
#[dojo::model]
struct Potions {
    #[key]
    id: u32,
    quantity: u8,
}
 
#[derive(Copy, Drop, Serde)]
#[dojo::model]
struct Health {
    #[key]
    id: u32,
    health: u8,
}
 
#[derive(Copy, Drop, Serde)]
#[dojo::model]
struct Position {
    #[key]
    id: u32,
    x: u32,
    y: u32
}
 
// Special counter model
#[derive(Copy, Drop, Serde)]
#[dojo::model]
struct Counter {
    #[key]
    counter: u32,
    goblin_count: u32,
    human_count: u32,
}

// ---- Working ----


#[dojo::contract]
mod spawnHuman {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::Into;
    use core::poseidon::poseidon_hash_span;
    use dojo::world::Context;
 
    use super::Position;
    use super::Health;
    use super::Potions;
    use super::Counter;
 
    // we can set the counter value as a const, then query it easily!
    // This pattern is useful for settings.
    const COUNTER_ID: u32 = 999;
 
    // As `human_count` and `goblin_count` may have the same value, 
    // we can have a same id for models like `Health` and `Position`, 
    // leading to a same storage location for both goblin and human.
    // To avoid this storage location conflict, we compute an unique
    // id by hashing the id with one of these constants.
    const HUMAN : felt252 = 'HUMAN';
    const GOBLIN : felt252 = 'GOBLIN';
 
 
    // impl: implement functions specified in trait
    #[abi(embed_v0)]
    impl GoblinActionsImpl of IGoblinActions<ContractState> {
        fn goblin_actions(ref self: ContractState, id: u32) {
            let mut world = self.world(@"dojo_starter");
 
            let counter: Counter = world.read_model(COUNTER_ID);
 
            let human_count = counter.human_count + 1;
            let goblin_count = counter.goblin_count + 1;
 
            // spawn a human
            let human_id = poseidon_hash_span([id, HUMAN].span());
            world.write_model(@Health { id: human_id, health: 100 });
            world.write_model(@Position { id: human_id, x: 0, y: 0 });
            world.write_model(@Potions { id: human_id, quantity: 10 });
 
            // spawn a goblin
            let goblin_id = poseidon_hash_span(
                [goblin_count, GOBLIN].span()
            );
            world.write_model(
                @Health { id: goblin_id, health: 100 }
            );
            world.write_model(
                @Position {
                    id: goblin_id,
                    x: position.x + 10,
                    y: position.y + 10
                }
            );
 
            // increment the counter
            world.write_model(
                @Counter {
                    counter: COUNTER_ID, human_count, goblin_count
                }
            );
        }
    }
}


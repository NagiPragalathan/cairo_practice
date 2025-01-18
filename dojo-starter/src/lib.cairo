use starknet::{ContractAddress};

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct Moves {
    #[key]
    pub player: ContractAddress,
    pub remaining: u8,
    pub last_direction: Option<Direction>,
    pub can_move: bool,
}

#[derive(Drop, Serde, Debug)]
#[dojo::model]
pub struct DirectionsAvailable {
    #[key]
    pub player: ContractAddress,
    pub directions: Array<Direction>,
}

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct Position {
    #[key]
    pub player: ContractAddress,
    pub vec: Vec2,
}


#[derive(Serde, Copy, Drop, Introspect, PartialEq, Debug)]
pub enum Direction {
    Left,
    Right,
    Up,
    Down,
}


#[derive(Copy, Drop, Serde, IntrospectPacked, Debug)]
pub struct Vec2 {
    pub x: u32,
    pub y: u32
}


impl DirectionIntoFelt252 of Into<Direction, felt252> {
    fn into(self: Direction) -> felt252 {
        match self {
            Direction::Left => 1,
            Direction::Right => 2,
            Direction::Up => 3,
            Direction::Down => 4,
        }
    }
}

impl OptionDirectionIntoFelt252 of Into<Option<Direction>, felt252> {
    fn into(self: Option<Direction>) -> felt252 {
        match self {
            Option::None => 0,
            Option::Some(d) => d.into(),
        }
    }
}

#[generate_trait]
impl Vec2Impl of Vec2Trait {
    fn is_zero(self: Vec2) -> bool {
        if self.x - self.y == 0 {
            return true;
        }
        false
    }

    fn is_equal(self: Vec2, b: Vec2) -> bool {
        self.x == b.x && self.y == b.y
    }
}

#[cfg(test)]
mod tests {
    use super::{Position, Vec2, Vec2Trait};

    #[test]
    fn test_vec_is_zero() {
        assert(Vec2Trait::is_zero(Vec2 { x: 0, y: 0 }), 'not zero');
    }

    #[test]
    fn test_vec_is_equal() {
        let position = Vec2 { x: 420, y: 0 };
        assert(position.is_equal(Vec2 { x: 420, y: 0 }), 'not equal');
    }
}
// define the interface
#[starknet::interface]
trait IActions<T> {
    fn spawn(ref self: T);
    fn move(ref self: T, direction: Direction);
}

// dojo decorator
#[dojo::contract]
pub mod actions {
    use super::{IActions, Direction, Position, next_position};
    use starknet::{ContractAddress, get_caller_address};
    use super::{Vec2, Moves, DirectionsAvailable};

    use dojo::model::{ModelStorage, ModelValueStorage};
    use dojo::event::EventStorage;

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct Moved {
        #[key]
        pub player: ContractAddress,
        pub direction: Direction,
    }

    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn spawn(ref self: ContractState) {
            // Get the default world.
            let mut world = self.world_default();

            // Get the address of the current caller, possibly the player's address.
            let player = get_caller_address();
            // Retrieve the player's current position from the world.
            let position: Position = world.read_model(player);

            // Update the world state with the new data.

            // 1. Move the player's position 10 units in both the x and y direction.
            let new_position = Position {
                player, vec: Vec2 { x: position.vec.x + 10, y: position.vec.y + 10 }
            };

            // Write the new position to the world.
            world.write_model(@new_position);

            // 2. Set the player's remaining moves to 100.
            let moves = Moves {
                player, remaining: 100, last_direction: Option::None, can_move: true
            };

            // Write the new moves to the world.
            world.write_model(@moves);
        }

        // Implementation of the move function for the ContractState struct.
        fn move(ref self: ContractState, direction: Direction) {
            // Get the address of the current caller, possibly the player's address.

            let mut world = self.world_default();

            let player = get_caller_address();

            // Retrieve the player's current position and moves data from the world.
            let position: Position = world.read_model(player);
            let mut moves: Moves = world.read_model(player);
            // if player hasn't spawn, read returns model default values. This leads to sub overflow afterwards.
            // Plus it's generally considered as a good pratice to fast-return on matching conditions.
            if !moves.can_move {
                return;
            }

            // Deduct one from the player's remaining moves.
            moves.remaining -= 1;

            // Update the last direction the player moved in.
            moves.last_direction = Option::Some(direction);

            // Calculate the player's next position based on the provided direction.
            let next = next_position(position, moves.last_direction);

            // Write the new position to the world.
            world.write_model(@next);

            // Write the new moves to the world.
            world.write_model(@moves);

            // Emit an event to the world to notify about the player's move.
            world.emit_event(@Moved { player, direction });
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

// Define function like this:
fn next_position(mut position: Position, direction: Option<Direction>) -> Position {
    match direction {
        Option::None => { return position; },
        Option::Some(d) => match d {
            Direction::Left => { position.vec.x -= 1; },
            Direction::Right => { position.vec.x += 1; },
            Direction::Up => { position.vec.y -= 1; },
            Direction::Down => { position.vec.y += 1; },
        }
    };
    position
}
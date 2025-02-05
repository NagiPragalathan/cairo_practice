#[cfg(test)]
mod tests {
    use dojo_cairo_test::{spawn_test_world, NamespaceDef, TestResource, ContractDefTrait, ContractDef};
    use dojo::model::{ModelStorage};  // Import ModelStorage
    use dojo_cairo_test::WorldStorageTestTrait;
    use crate::systems::actions::{actions, IActionsDispatcher, IActionsDispatcherTrait};
    use crate::models::{Settings, m_Settings};
    use starknet::felt252;

    // Define the namespace
    fn namespace_def() -> NamespaceDef {
        NamespaceDef {
            namespace: "beach_ball",
            resources: [
                TestResource::Model(m_Settings::TEST_CLASS_HASH),
                TestResource::Event(crate::events::e_UpdatedSettings::TEST_CLASS_HASH),
                TestResource::Contract(actions::TEST_CLASS_HASH),
            ].span(),
        }
    }

    // Define contract resources
    fn contract_defs() -> Span<ContractDef> {
        [
            ContractDefTrait::new(@"beach_ball", @"actions")
                .with_writer_of([dojo::utils::bytearray_hash(@"beach_ball")].span()),
        ].span()
    }

    // Test for add_settings
    #[test]
    #[available_gas(30000000)]
    fn test_add_settings() {
        // Initialize test environment
        let caller = starknet::contract_address_const::<0x0>();
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());

        // Sync permissions and initializations
        world.sync_perms_and_inits(contract_defs());

        // Deploy the contract (if necessary)
        let contract_address = actions_system.deploy_contract();
        actions_system.set_contract_address(contract_address);

        // Add settings
        let actions_system = IActionsDispatcher { contract_address: caller };
        actions_system.add_settings();

        // Retrieve the settings for the caller
        let settings: Settings = world.read_model(caller);

        // Assert the settings are as expected
        assert(settings.mode == felt252::new(1), "Mode is incorrect");
        assert(settings.difficulty == felt252::new(1), "Difficulty is incorrect");
        assert(settings.number_of_blocks == felt252::new(1), "Number of blocks is incorrect");
    }

    // Test for update_settings
    #[test]
    #[available_gas(30000000)]
    fn test_update_settings() {
        let caller = starknet::contract_address_const::<0x0>();
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());
        world.sync_perms_and_inits(contract_defs());

        // Deploy the contract (if necessary)
        let contract_address = actions_system.deploy_contract();
        actions_system.set_contract_address(contract_address);

        // Call add_settings to initialize settings
        let actions_system = IActionsDispatcher { contract_address: caller };
        actions_system.add_settings();

        // Call update_settings to modify settings
        actions_system.update_settings(felt252::new(2), felt252::new(3), felt252::new(4));

        // Retrieve updated settings for the caller
        let settings: Settings = world.read_model(caller);

        // Assert the updated settings
        assert!(settings.mode == felt252::new(2), "Mode update failed");
        assert!(settings.difficulty == felt252::new(3), "Difficulty update failed");
        assert!(settings.number_of_blocks == felt252::new(4), "Number of blocks update failed");
    }
}

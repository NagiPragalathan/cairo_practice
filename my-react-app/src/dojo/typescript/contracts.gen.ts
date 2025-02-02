import { DojoProvider, DojoCall } from "@dojoengine/core";
import { Account, AccountInterface, BigNumberish, CairoOption, CairoCustomEnum, ByteArray } from "starknet";
import * as models from "./models.gen";

export function setupWorld(provider: DojoProvider) {

	const build_actions_addPlayer_calldata = (): DojoCall => {
		return {
			contractName: "actions",
			entrypoint: "add_player",
			calldata: [],
		};
	};

	const actions_addPlayer = async (snAccount: Account | AccountInterface) => {
		try {
			return await provider.execute(
				snAccount,
				build_actions_addPlayer_calldata(),
				"dojo_starter",
			);
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_actions_updatePlayer_calldata = (health: BigNumberish, tool: BigNumberish): DojoCall => {
		return {
			contractName: "actions",
			entrypoint: "update_player",
			calldata: [health, tool],
		};
	};

	const actions_updatePlayer = async (snAccount: Account | AccountInterface, health: BigNumberish, tool: BigNumberish) => {
		try {
			return await provider.execute(
				snAccount,
				build_actions_updatePlayer_calldata(health, tool),
				"dojo_starter",
			);
		} catch (error) {
			console.error(error);
			throw error;
		}
	};



	return {
		actions: {
			addPlayer: actions_addPlayer,
			buildAddPlayerCalldata: build_actions_addPlayer_calldata,
			updatePlayer: actions_updatePlayer,
			buildUpdatePlayerCalldata: build_actions_updatePlayer_calldata,
		},
	};
}
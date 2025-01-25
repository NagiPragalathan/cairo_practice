import type { SchemaType as ISchemaType } from "@dojoengine/sdk";

import { BigNumberish } from 'starknet';

type WithFieldOrder<T> = T & { fieldOrder: string[] };

// Type definition for `dojo_starter::Player` struct
export interface Player {
	player_id: BigNumberish;
	name: BigNumberish;
	health: BigNumberish;
	tool: BigNumberish;
}

// Type definition for `dojo_starter::PlayerValue` struct
export interface PlayerValue {
	name: BigNumberish;
	health: BigNumberish;
	tool: BigNumberish;
}

export interface SchemaType extends ISchemaType {
	dojo_starter: {
		Player: WithFieldOrder<Player>,
		PlayerValue: WithFieldOrder<PlayerValue>,
	},
}
export const schema: SchemaType = {
	dojo_starter: {
		Player: {
			fieldOrder: ['player_id', 'name', 'health', 'tool'],
			player_id: 0,
			name: 0,
			health: 0,
			tool: 0,
		},
		PlayerValue: {
			fieldOrder: ['name', 'health', 'tool'],
			name: 0,
			health: 0,
			tool: 0,
		},
	},
};
export enum ModelsMapping {
	Player = 'dojo_starter-Player',
	PlayerValue = 'dojo_starter-PlayerValue',
}
import type { SchemaType as ISchemaType } from "@dojoengine/sdk";

import { BigNumberish } from 'starknet';

type WithFieldOrder<T> = T & { fieldOrder: string[] };

// Type definition for `dojo_starter::models::Player` struct
export interface Player {
	player: string;
	name: BigNumberish;
	health: BigNumberish;
	tool: BigNumberish;
}

// Type definition for `dojo_starter::models::PlayerValue` struct
export interface PlayerValue {
	name: BigNumberish;
	health: BigNumberish;
	tool: BigNumberish;
}

// Type definition for `dojo_starter::systems::actions::actions::UpdatedPlayer` struct
export interface UpdatedPlayer {
	player: string;
	health: BigNumberish;
	tool: BigNumberish;
}

// Type definition for `dojo_starter::systems::actions::actions::UpdatedPlayerValue` struct
export interface UpdatedPlayerValue {
	health: BigNumberish;
	tool: BigNumberish;
}

export interface SchemaType extends ISchemaType {
	dojo_starter: {
		Player: WithFieldOrder<Player>,
		PlayerValue: WithFieldOrder<PlayerValue>,
		UpdatedPlayer: WithFieldOrder<UpdatedPlayer>,
		UpdatedPlayerValue: WithFieldOrder<UpdatedPlayerValue>,
	},
}
export const schema: SchemaType = {
	dojo_starter: {
		Player: {
			fieldOrder: ['player', 'name', 'health', 'tool'],
			player: "",
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
		UpdatedPlayer: {
			fieldOrder: ['player', 'health', 'tool'],
			player: "",
			health: 0,
			tool: 0,
		},
		UpdatedPlayerValue: {
			fieldOrder: ['health', 'tool'],
			health: 0,
			tool: 0,
		},
	},
};
export enum ModelsMapping {
	Player = 'dojo_starter-Player',
	PlayerValue = 'dojo_starter-PlayerValue',
	UpdatedPlayer = 'dojo_starter-UpdatedPlayer',
	UpdatedPlayerValue = 'dojo_starter-UpdatedPlayerValue',
}
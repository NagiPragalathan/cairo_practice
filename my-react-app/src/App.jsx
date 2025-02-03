import { useState, useEffect , useMemo} from "react";
import reactLogo from "./assets/react.svg";
import viteLogo from "/vite.svg";
import "./App.css";

import {  QueryBuilder } from "@dojoengine/sdk";
import { AccountInterface, addAddressPadding, CairoCustomEnum } from "starknet";
import { ModelsMapping } from "./typescript/models.gen.ts";


import { getEntityIdFromKeys } from "@dojoengine/utils";

import { useAccount } from "@starknet-react/core";
import { WalletAccount } from "./wallet-account.tsx";
import { init } from "@dojoengine/sdk";
import { schema } from "./typescript/models.gen.ts"; // Adjust schema path if needed
import { useDojoSDK, useModel } from "@dojoengine/sdk/react";
import { useSystemCalls } from "./useSystemCalls.ts";

function App() {

      const { useDojoStore, client, sdk } = useDojoSDK();

   const { account } = useAccount();

   const state = useDojoStore((state) => state);
   const entities = useDojoStore((state) => state.entities);

   const { spawn } = useSystemCalls();


   const entityId = useMemo(() => {
    if (account) {
        return getEntityIdFromKeys([BigInt(account.address)]);
    }
    return BigInt(0);
}, [account]);



useEffect(() => {
  let unsubscribe;

  const subscribe = async (account) => {
      const subscription = await sdk.subscribeEntityQuery({
          query: new QueryBuilder()
              .namespace("dojo_starter", (n) =>
                  n
                      .entity("Player", (e) =>
                          e.eq(
                              "health",
                              100
                          )
                      )
                     
              )
              .build(),
          callback: ({ error, data }) => {
              if (error) {
                  console.error("Error setting up entity sync:", error);
              } else if (
                  data &&
                  data[0].entityId !== "0x0"
              ) {
                  state.updateEntity(data[0]);
              }
          },
      });

      unsubscribe = () => subscription.cancel();
  };

  if (account) {
      subscribe(account);
  }

  return () => {
      if (unsubscribe) {
          unsubscribe();
      }
  };
}, [sdk, account]);



useEffect(() => {
  const fetchEntities = async (account) => {
      try {
          await sdk.getEntities({
              query: new QueryBuilder()
                  .namespace("dojo_starter", (n) =>
                      n.entity("Player", (e) =>
                          e.eq(
                              "health",
                              100
                          )
                      )
                  )
                  .build(),
              callback: (resp) => {
                  if (resp.error) {
                      console.error(
                          "resp.error.message:",
                          resp.error.message
                      );
                      return;
                  }
                  if (resp.data) {
                      state.setEntities(
                          resp.data 
                      );
                  }
              },
          });
      } catch (error) {
          console.error("Error querying entities:", error);
      }
  };

  if (account) {
      fetchEntities(account);
  }
}, [sdk, account]);

const moves = useModel(entityId , ModelsMapping.Player);
// const position = useModel(entityId , ModelsMapping.Position);

const spawnHandler = async () => {
  try {
          const res = await spawn();
          console.log(res);
      } catch (error) {
          console.log(error);
  }
  };



  const updateHandler = async () => {
    try {
      console.log("client", client);
      
            const res = await client.actions.updatePlayer(account,"88", "screwdriver");
            console.log(res);
        } catch (error) {
            console.log(error);
    }
  };

  const getToolName = (hex) => {
    try {
      const hexWithoutPrefix = hex.slice(2);
      const bytes = new Uint8Array(hexWithoutPrefix.match(/.{1,2}/g).map(byte => parseInt(byte, 16)));
      const decoder = new TextDecoder();
      return decoder.decode(bytes).replace(/\x00/g, '');
    } catch (error) {
      console.error("Error decoding hex:", error);
      return "";
    }
  };





  return (
    <>
      <div>
        <a href="https://vite.dev" target="_blank" rel="noopener noreferrer">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://react.dev" target="_blank" rel="noopener noreferrer">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <h1>Vite + React</h1>
      <div className="card">
        <WalletAccount />
        <p>
          Edit <code>src/App.jsx</code> and save to test HMR
        </p>
        <button onClick={spawnHandler}>Spawn</button>

        <div className="col-span-3 text-center text-base text-white">
                                Health:{" "}
                                {moves ? `${moves.health}` : "Need to Spawn"}
                            </div>
        <div className="col-span-3 text-center text-base text-white">
                                Health:{" "}
                                {moves ? `${getToolName(moves.tool.toString())}` : "Need to Spawn"}
                            </div>

                            <div className="col-span-3 text-center text-base text-white " onClick={updateHandler}>
Update
                            </div>
      </div>
    </>
  );
}

export default App;

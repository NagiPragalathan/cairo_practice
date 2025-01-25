import { useEffect, useState } from "react";
import reactLogo from "./assets/react.svg";
import viteLogo from "/vite.svg";
import "./App.css";

import { QueryBuilder } from "@dojoengine/sdk"; // Added missing import
import { useDojoSDK } from "@dojoengine/sdk/react";

function App() {
  const [count, setCount] = useState(0);
  const { useDojoStore, client, sdk } = useDojoSDK();

  console.log(sdk, "sdk", client);

  // Subscribe to entity updates
  useEffect(() => {
    const subscribe = async () => {
      try {
        const subscription = await sdk.subscribeEntityQuery({
          query: new QueryBuilder()
            .namespace("dojo_starter", (n) =>
              n.entity("Player", (e) => e.eq("player_id", "1"))
            )
            .build(),
          callback: ({ error, data }) => {
            if (error) {
              console.error("Error setting up entity sync:", error);
            } else if (data && data[0]?.entityId !== "0x0") {
              console.log("Entity updated:", data[0]);
            }
          },
        });

        return () => {
          subscription.cancel(); // Clean up the subscription
        };
      } catch (error) {
        console.error("Error subscribing to entity updates:", error);
      }
    };

    subscribe();
  }, [sdk]);

  // Function to handle adding a player
  const handleAddPlayer = async () => {
    try {
      const result = await client.actions.update_player();
      console.log(result, "Player added successfully");
    } catch (error) {
      console.error("Error adding player:", error);
    }
  };

  return (
    <>
      <div>
        <a href="https://vite.dev" target="_blank">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://react.dev" target="_blank">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <h1>Vite + React</h1>
      <div className="card">
        <button onClick={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
        <button onClick={handleAddPlayer}>Add Player</button>
        <p>
          Edit <code>src/App.jsx</code> and save to test HMR
        </p>
      </div>
      <p className="read-the-docs">
        Click on the Vite and React logos to learn more
      </p>
    </>
  );
}

export default App;

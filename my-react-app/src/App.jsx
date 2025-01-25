import { useState, useEffect } from "react";
import reactLogo from "./assets/react.svg";
import viteLogo from "/vite.svg";
import "./App.css";
import { useAccount } from "@starknet-react/core";
import { WalletAccount } from "./wallet-account.tsx";
import { init } from "@dojoengine/sdk";
import { schema } from "./typescript/models.gen.ts"; // Adjust schema path if needed

function App() {
  const [client, setClient] = useState(null);
  const { account } = useAccount();

  // Initialize Dojo client
  useEffect(() => {
    async function initializeDojoClient() {
      try {
        const dojoClient = await init(
          {
            client: {
              rpcUrl: "http://localhost:5050", // Replace with your RPC URL
              toriiUrl: "http://localhost:8080", // Replace with your Torii URL
              relayUrl: "/ip4/127.0.0.1/tcp/9090", // Corrected relay URL format
              worldAddress: "0x0525177c8afe8680d7ad1da30ca183e482cfcd6404c1e09d83fd3fa2994fd4b8", // Replace with your deployed world address
            },
            domain: {
              name: "MyDojoProject",
              version: "1.0",
              chainId: "1",
              revision: "1",
            },
          },
          schema // Pass the schema generated with sozo
        );
        console.log("Initialized Dojo client:", dojoClient);
        setClient(dojoClient);
      } catch (error) {
        console.error("Error initializing Dojo client:", error);
      }
    }

    initializeDojoClient();
  }, []);

  // Add a new player
  async function addPlayer() {
    if (!client) {
      console.error("Dojo client is not initialized.");
      return;
    }

    const playerData = {
      player_id: 1,
      name: "John",
      health: 100,
      tool: "Sword",
    };

    try {
      console.log("Attempting to add player:", playerData);

      // Generate a typed message for the `add_player` action
      const message = client.generateTypedData("world-Player", {
        id: playerData.player_id,
        name: playerData.name,
        health: playerData.health,
        tool: playerData.tool,
      });

      // Sign the message using the account signer
      const signature = await account.signMessage(message);

      // Send the message to Torii
      const result = await client.sendMessage(
        JSON.stringify(message),
        signature
      );

      console.log("Player added successfully:", result);

      // Fetch the added player to verify
      const entities = await client.getEntities({
        query: {
          world: {
            Player: {
              $: {
                where: { id: { $eq: playerData.player_id } },
              },
            },
          },
        },
      });

      console.log("Entities retrieved after adding player:", entities);
    } catch (error) {
      console.error("Error adding player:", error);
    }
  }

  // Trigger addPlayer when client and account are ready
  useEffect(() => {
    if (client && account) {
      addPlayer();
    }
  }, [client, account]);

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
      </div>
    </>
  );
}

export default App;

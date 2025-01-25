import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.jsx'


import { init } from "@dojoengine/sdk";
// ModelNameInteface is exported from ./models.generated.ts
// This file contains mapping of your cairo contracts to torii client
import { schema } from "./typescript/models.gen";
import { dojoConfig } from "../dojoConfig";
import { createContext } from 'react';
import { DojoContext } from '@dojoengine/sdk/react';

async function main() {
  const db = await init(
    {
        client: {
            // This is local katana
            rpcUrl: "http://localhost:5050",
            // This is local torii
            toriiUrl: "http://localhost:8080",
            relayUrl: "/ip4/127.0.0.1/tcp/9090/tcp/80",
            worldAddress: dojoConfig.manifest.world.address,
        },
        // Those values are used
        domain: {
          name: "WORLD_NAME",
          version: "1.0",
          chainId: "KATANA",
          revision: "1",
      },
    },
    schema
  );
  
  createRoot(document.getElementById("root")).render(
      <StrictMode>
          <DojoContext.Provider value={db}>
                  <App />
          </DojoContext.Provider>
      </StrictMode>
  );
}

main();

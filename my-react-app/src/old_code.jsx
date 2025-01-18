import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.jsx'

import { init } from "@dojoengine/sdk";

import { schema } from "./typescript/models.gen.ts";

// import { env, getRpcUrl } from "@/env";
import { dojoConfig } from "../dojoConfig";

export const DojoContext = createContext(
  null
);

async function main() {
  // Function init defined above
  const db = await init(
    {
        client: {
            // This is local katana
            rpcUrl: "http://localhost:5050",
            // This is local torii
            toriiUrl: "http://localhost:8080",
            relayUrl: "/ip4/127.0.0.1/tcp/9090/tcp/80",
            worldAddress: "0x0525177c8afe8680d7ad1da30ca183e482cfcd6404c1e09d83fd3fa2994fd4b8",
        },
        // Those values are used
        domain: {
            name: "MyDojoProject",
        },
    },
    schema
  );

  createRoot(document.getElementById("root")).render(
      <StrictMode>
          <DojoContext.Provider value={db}>
          <StrictMode>
          <div>Test Render</div>
          </StrictMode>
          </DojoContext.Provider>
      </StrictMode>
  );
}

main();
import React, { StrictMode, createContext } from 'react';
import { createRoot } from 'react-dom/client';
import './index.css';
import { init } from '@dojoengine/sdk';
import { schema } from './typescript/models.gen.ts';
import App from './App';
import { DojoSdkProvider } from "@dojoengine/sdk/react";
import { dojoConfig } from "../dojoConfig.ts";
import { setupWorld } from "./typescript/contracts.gen.ts";
import StarknetProvider from "./starknet-provider.tsx";


export const DojoContext = createContext(null);

async function main() {
  try {
    const sdk = await init(
      {
        client: {
          rpcUrl: dojoConfig.rpcUrl,
          toriiUrl: dojoConfig.toriiUrl,
          relayUrl: dojoConfig.relayUrl,
          worldAddress: dojoConfig.manifest.world.address,
        },
        domain: {
          name: 'dojo_starter',
          version: "1.0",
          chainId: "KATANA",
          revision: "1",
        },
      },
      schema
    );

    createRoot(document.getElementById('root')).render(
      <StrictMode>
      <DojoSdkProvider
          sdk={sdk}
          dojoConfig={dojoConfig}
          clientFn={setupWorld}
      >
          <StarknetProvider>
              <App />
          </StarknetProvider>
      </DojoSdkProvider>
  </StrictMode>
    );
  } catch (error) {
    console.error('Error initializing app:', error);
  }
}

main();

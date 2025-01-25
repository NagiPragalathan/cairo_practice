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
          rpcUrl: 'http://localhost:5050', // Local Katana
          toriiUrl: 'http://localhost:8080', // Local  
          relayUrl: '/ip4/127.0.0.1/tcp/9090/tcp/80',
          worldAddress: '0x0525177c8afe8680d7ad1da30ca183e482cfcd6404c1e09d83fd3fa2994fd4b8',
        },
        domain: {
          name: 'dojo_starter',
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

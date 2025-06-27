import React  from 'react'
import ReactDOM  from 'react-dom/client'
import './index.css'
import App from './App.jsx'

import { WagmiProvider, createConfig, http } from 'wagmi';
import { sepolia } from 'wagmi/chains';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';

// 1. Set up a QueryClient from tanstack/react-query
const queryClient = new QueryClient();

// 2. Create a wagmi config
const config = createConfig({
  chains: [sepolia],
  transports: {
    [sepolia.id]: http()
  },
});

// 3. Render the app with the providers
ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        <App ></App>
      </QueryClientProvider>
    </WagmiProvider>
  </React.StrictMode>,
);

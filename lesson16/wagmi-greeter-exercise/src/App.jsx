import { useState, useEffect} from 'react';
import { useAccount, useConnect, useDisconnect, useReadContract, useWriteContract, useWaitForTransactionReceipt } from 'wagmi';
import { injected } from 'wagmi/connectors';

// Import the ABI from the contract details provided earlier.
const greeterAbi = [
    { "inputs": [{ "internalType": "string", "name": "_initialGreeting", "type": "string" }], "stateMutability": "nonpayable", "type": "constructor" },
    { "inputs": [], "name": "greet", "outputs": [{ "internalType": "string", "name": "", "type": "string" }], "stateMutability": "view", "type": "function" },
    { "inputs": [{ "internalType": "string", "name": "_newGreeting", "type": "string" }], "name": "setGreeting", "outputs": [], "stateMutability": "nonpayable", "type": "function" }
];

// TODO  - Fill in your contract address
const greeterContractConfig = {
    address: '0xeFaBb832600f4729D95EBa1Ce8ad74a220d65B47',     
    abi: greeterAbi,
};

function App() {
    const account = useAccount();
    const { connect } = useConnect();
    const { disconnect } = useDisconnect();
    const { data: hash, writeContract } = useWriteContract();

    const [newGreeting, setNewGreeting] = useState('');

    // Hook to read the current greeting from the smart contract.
    const { data: currentGreeting, refetch } = useReadContract({
        ...greeterContractConfig,
        functionName: 'greet',
    });

    // Hook to wait for the transaction to be mined.
    const { isLoading: isConfirming, isSuccess: isConfirmed } = useWaitForTransactionReceipt({
        hash,
    });

    // Function to handle the 'setGreeting' transaction.
    async function submitGreeting(e) {
        e.preventDefault();
        if (!newGreeting.trim()) return;
        writeContract({
            ...greeterContractConfig,
            functionName: 'setGreeting',
            args: [newGreeting],
        });
    }
    
    // Effect to refetch the greeting when a transaction is confirmed.
    useEffect(() => {
        if (isConfirmed) {
            refetch();
            setNewGreeting('');
        }
    }, [isConfirmed, refetch]);

    return (
        <div style={{ padding: '2rem' }}>
            <h1>Wagmi Greeter Exercise</h1>

            {account.status === 'connected' ? (
                <div>
                    <p>Connected as: {account.address}</p>
                    <button onClick={() => disconnect()}>Disconnect</button>
                    <hr style={{ margin: '1rem 0' }} ></hr>
                    
                    <h3>Read from Contract</h3>
                    <p>Current Greeting: <strong>{currentGreeting?.toString() || 'Loading...'}</strong></p>

                    <hr style={{ margin: '1rem 0' }} ></hr>

                    <h3>Write to Contract</h3>
                    <form onSubmit={submitGreeting}>
                        <input
                            type="text"
                            placeholder="Enter new greeting"
                            value={newGreeting}
                            onChange={(e) => setNewGreeting(e.target.value)}
                            style={{ marginRight: '0.5rem' }}
                        />
                        <button type="submit" disabled={isConfirming}>
                            {isConfirming ? 'Confirming...' : 'Set Greeting'}
                        </button>
                    </form>
                    {hash && <div>Transaction Hash: {hash}</div>}
                    {isConfirmed && <div>Transaction confirmed! Greeting updated.</div>}
                </div>
            ) : (
                <button onClick={() => connect({ connector: injected() })}>
                    Connect Wallet
                </button>
            )}
        </div>
    );
}

export default App;
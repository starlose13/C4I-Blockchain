import { useState, useEffect } from 'react';
import { ethers } from 'ethers';
import contractABI from '../abi/contractABI.json';

const useContract = () => {
    const [contract, setContract] = useState(null);

    useEffect(() => {
        const init = async () => {
            try {
                const provider = new ethers.JsonRpcProvider(process.env.VITE_RPC_URL);
                const wallet = new ethers.Wallet(process.env.VITE_PRIVATE_KEY, provider);
                const contractInstance = new ethers.Contract(process.env.VITE_STORAGE_CONTRACT_ADDRESS, contractABI, wallet);
                setContract(contractInstance);
            } catch (error) {
                console.error("Error connecting to Anvil:", error);
            }
        };
        init();
    }, []);

    return contract;
};

export default useContract;

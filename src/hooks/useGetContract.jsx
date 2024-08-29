/*//////////////////////////////////////////////////////////////
                               IMPORTS
//////////////////////////////////////////////////////////////*/
import { ethers } from 'ethers';
import { useEffect, useState } from "react";
import NodeManagerABI from "../utils/NodeManagerABI/NodeManager.json"
import ConsensusMechanismABI from "../utils/ConsensusMechanismABI/ConsensusMechanism.json"

/*//////////////////////////////////////////////////////////////
                      LOAD ENVIROMENT VARIABLES
//////////////////////////////////////////////////////////////*/
const anvilUrl = import.meta.env.VITE_RPC_URL;
const privateKey = import.meta.env.VITE_PRIVATE_KEY;
const NodeManagerContractAddress = import.meta.env.VITE_NODEMANAGER_CONTRACT_ADDRESS;
const ConsensusMechanismContractAddress = import.meta.env.VITE_CONSENSUS_CONTRACT_ADDRESS;


/*//////////////////////////////////////////////////////////////
                  INITIALIZE THE PROVIDER AND WALLET
//////////////////////////////////////////////////////////////*/
const provider = new ethers.JsonRpcProvider(anvilUrl);
const wallet = new ethers.Wallet(privateKey, provider);


/*//////////////////////////////////////////////////////////////
                      CREATE A CONTRACT INSTANCE
//////////////////////////////////////////////////////////////*/
const NodeManagerContract = new ethers.Contract(NodeManagerContractAddress, NodeManagerABI, wallet);
const ConsensusMechanismContract = new ethers.Contract(ConsensusMechanismContractAddress, ConsensusMechanismABI, wallet);


/*//////////////////////////////////////////////////////////////
                        NODE MANAGER FUNCTIONS
//////////////////////////////////////////////////////////////*/
export const useFetchNodeAddresses = () => {
    const [result, setResult] = useState()
    const [error, setError] = useState()
    useEffect(() => {
        const fetchData = async () => {
            try {
                const data = await NodeManagerContract.getNodeAddresses();
                setResult(data);
            } catch (err) {
                setError(err);
                console.error('Error interacting with the contract:', err);
            }
        };
        fetchData();
    }, []);
    return { result, error };
}


export const useFormatAndFetchURIData = async (ad) => {
    try {
        const data = await NodeManagerContract.URIDataFormatter(ad);
        return data;
    } catch (err) {
        console.error('Error interacting with the contract:', err);
        return null; 
    }
}


/*//////////////////////////////////////////////////////////////
                          CONSENSUS FUNCTION
//////////////////////////////////////////////////////////////*/


export const useSimulateTargetLocation = () => {
    const [error, setError] = useState(null);
    const [data, setData] = useState(null);


    const simulateTargetLocation = async (fetchAddress, clickedData) => {
        if (fetchAddress.length === 0) return;

        try {
              // Initiating the transaction
              const transaction = await ConsensusMechanismContract.TargetLocationSimulation(fetchAddress, clickedData);
              console.log('useSimulateTargetLocation Transaction sent:', transaction.hash);
  
              // Waiting for the transaction to be confirmed in a block
              const receipt = await transaction.wait();
              console.log('Transaction confirmed in block:', receipt.blockNumber);
  
              // Logging detailed transaction information
              console.log('Transaction Hash:', receipt.transactionHash);
              console.log('Gas used:', receipt.gasUsed.toString());
              console.log('Block Number:', receipt.blockNumber);
              console.log('Block Hash:', receipt.blockHash);
  
              // Fetching the block to get the timestamp
              const block = await transaction.provider.getBlock(receipt.blockNumber);
              console.log('Block Time:', new Date(block.timestamp * 1000).toUTCString());
  
              // Storing the receipt data
              setData(receipt);
            // console.log(fetchAddress);
            // // console.log(clickedData);
            // const data = await ConsensusMechanismContract.TargetLocationSimulation(fetchAddress, clickedData);
            // console.log('TargetLocationSimulation Transaction sent :', data.hash);
            // const receipt = await data.wait();
            // console.log('Transaction confirmed in block:', receipt.blockNumber);
        } catch (err) {
            // console.error('Error interacting with the contract:', err);
            setError(err);
        }
    };

    return { simulateTargetLocation, error };
};




// walletAddress => one of JSON privateKey (runner, executer)
//Consensus.consensusAutomationExecution();

export const useConsensusExecution = () => {
    const [error, setError] = useState(null);
    const [data, setData] = useState(null);

    const executeConsensus = async () => {
        try {
              // Initiating the transaction
              const transaction = await ConsensusMechanismContract.consensusAutomationExecution();
              console.log('useConsensusExecution Transaction sent:', transaction.hash);
  
              // Waiting for the transaction to be confirmed in a block
              const receipt = await transaction.wait();
              console.log('Transaction confirmed in block:', receipt.blockNumber);
  
              // Logging detailed transaction information
              console.log('Transaction Hash:', receipt.transactionHash);
              console.log('Gas used:', receipt.gasUsed.toString());
              console.log('Block Number:', receipt.blockNumber);
              console.log('Block Hash:', receipt.blockHash);
  
              // Fetching the block to get the timestamp
              const block = await transaction.provider.getBlock(receipt.blockNumber);
              console.log('Block Time:', new Date(block.timestamp * 1000).toUTCString());
  
              // Storing the receipt data
              setData(receipt);
        } catch (err) {
            // console.error('Error interacting with the contract:', err);
            setError(err);
        }
    };

    return { executeConsensus, data, error };
};

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

            const transaction = await ConsensusMechanismContract.TargetLocationSimulation(fetchAddress, clickedData);
            const receipt = await transaction.wait();
            const block = await transaction.provider.getBlock(receipt.blockNumber);

            console.log('useSimulateTargetLocation Transaction sent:', transaction.hash);
            console.log('Transaction confirmed in block:', receipt.blockNumber);
            console.log('Transaction Hash:', receipt.transactionHash);
            console.log('Gas used:', receipt.gasUsed.toString());
            console.log('Block Number:', receipt.blockNumber);
            console.log('Block Hash:', receipt.blockHash);
            console.log('Block Time:', new Date(block.timestamp * 1000).toUTCString());

            setData(receipt);
        } catch (err) {
            setError(err);
        }
    };
    return { simulateTargetLocation, error };
};


export const useConsensusExecution = () => {
    const [error, setError] = useState(null);
    const [data, setData] = useState(null);

    const executeConsensus = async () => {
        try {
            
            const transaction = await ConsensusMechanismContract.consensusAutomationExecution();
            const receipt = await transaction.wait();
            const block = await transaction.provider.getBlock(receipt.blockNumber);

            console.log('useConsensusExecution Transaction sent:', transaction.hash);
            console.log('Transaction confirmed in block:', receipt.blockNumber);
            console.log('Transaction Hash:', receipt.transactionHash);
            console.log('Gas used:', receipt.gasUsed.toString());
            console.log('Block Number:', receipt.blockNumber);
            console.log('Block Hash:', receipt.transactionHash);
            console.log('Block Time:', new Date(block.timestamp * 1000).toUTCString());

            setData(receipt);
        } catch (err) {
            setError(err);
        }
    };
    return { executeConsensus, data, error };
};


/*//////////////////////////////////////////////////////////////
                            Epoch section
//////////////////////////////////////////////////////////////*/



export const useSimulationNumberOfEpoch = () => {
    const [result, setResult] = useState();
    const [error, setError] = useState();

    useEffect(() => {
        const fetchData = async () => {
            try {
                const data = await ConsensusMechanismContract.fetchNumberOfEpoch();
                setResult(data);
            } catch (err) {
                setError(err);
                console.error('Error interacting with the contract:', err);
            }
        };
        fetchData();
    }, []);
    return { result, error };
};




export const useSimulationNumberOfEachEpoch = (dataNumberOfEpoch) => {
    const [result, setResult] = useState();
    const [error, setError] = useState();

    useEffect(() => {
        if (!dataNumberOfEpoch) return;
        const fetchData = async () => {
            try {
                const resultData = await ConsensusMechanismContract.fetchResultOfEachEpoch(dataNumberOfEpoch);
                setResult(resultData);
            } catch (err) {
                setError(err);
                console.error('Error interacting with the contract:', err);
            }
        };
        fetchData();
    }, [dataNumberOfEpoch]);
    return { result, error };
};
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
export const useInteractWithNodeManagerContract = () => {

    const [result, setResult] = useState()
    const [error, setError] = useState()
    useEffect(() => {
        const fetchData = async () => {
            try {
                // const data = await NodeManagerContract.retrieveAllRegisteredNodeData();
                const data = await NodeManagerContract.getNodeAddresses();
                console.log("getnodeAddresses is: ", data);

                // const structuredData = data.map((nodeData, index) => ({
                //     // id: index,
                //     // address: nodeData.nodeAddress,
                //     // position: nodeData.currentPosition,
                //     // ipfsData: nodeData.IPFSData

                // }));

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


export const useInteractWithConsensusContractOnChainData = (newUriAddresses) => {
    const [error, setError] = useState(null);
    useEffect(() => {
        const fetchData = async () => {
            if (!newUriAddresses) return; // Wait until newUriAddresses is available
            try {
                // const data = await NodeManagerContract.URIDataFormatter('0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266');
                const data = await NodeManagerContract.URIDataFormatter(newUriAddresses);
                // const _data = await ConsensusMechanismContract.TargetLocationSimulation(s_agents, s_announceTargets);
                console.log(data);

                console.log('Transaction sent:', data);
                // console.log('Transaction sent:', _data);

            } catch (err) {
                console.error('Error interacting with the contract:', err);
                setError(err);

            }
        };
        fetchData();
    }, [newUriAddresses]);

    return { error };
}

/*//////////////////////////////////////////////////////////////
                          CONSENSUS FUNCTION
    //////////////////////////////////////////////////////////////*/


export const useInteractWithConsensusContract = (addresses, positions) => {

    const [error, setError] = useState(null);
    useEffect(() => {
        const fetchData = async () => {

            if (addresses.length === 0 || positions.length === 0) return;


            try {
                console.log(addresses)
                console.log(positions)

                const data = await ConsensusMechanismContract.TargetLocationSimulation(addresses, positions);
                // const data = await ConsensusMechanismContract.TargetLocationSimulation(s_agents,s_announceTargets);
                // console.log(data);
                console.log('Transaction sent:', data.hash);
                const receipt = await data.wait();
                console.log('Transaction confirmed in block:', receipt.blockNumber);
            } catch (err) {
                console.error('Error interacting with the contract:', err);
                setError(err);
            }
        };
        fetchData();
    }, [addresses, positions]);

    return { error };
}



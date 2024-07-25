// import './App.css'
//     import Navbar from "./Components/Navbar.jsx";
// import Sidebar from "./Components/Sidebar.jsx";
// import MapComponent from "./Components/MainContent/MainContent.jsx";
// import { ethers } from 'ethers';
// import {useState} from "react";



// // Replace with your contract's ABI and address
// // const contractABI = [ /* ABI JSON here */ ];
// // const contractAddress = '0xYourContractAddress';

// function App() {

//     return (
//         <div className="w-full h-screen relative bg-[#00030c]">
//             <Navbar/>
//             <div className="flex">
//                 <div>
//                     <Sidebar/>
//                 </div>
//                 <div className="flex-grow mx-2 ">
//                     <MapComponent/>
//                 </div>
//             </div>
//         </div>

//     )
// }

// export default App



import { useState, useEffect } from 'react';
import { ethers } from 'ethers';

// Replace with your contract's ABI and address
const contractABI = [{ "inputs": [], "stateMutability": "view", "type": "function", "name": "getNumber", "outputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }] }, { "inputs": [{ "internalType": "uint256", "name": "_number", "type": "uint256" }], "stateMutability": "nonpayable", "type": "function", "name": "setValue" }];

const contractAddress = "0xB7f8BC63BbcaD18155201308C8f3540b07f84F5e";

const privateKey = '0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80';

const App = () => {
    const [contract, setContract] = useState(null);
    const [storedData, setStoredData] = useState(null);
    const [transactions, setTransactions] = useState([]);
    const [inputValue, setInputValue] = useState(''); // State for the input field

    useEffect(() => {
        const init = async () => {
            try {
                // Connect to Anvil
                const provider = new ethers.JsonRpcProvider('http://127.0.0.1:8545'); // Anvil RPC URL
                const wallet = new ethers.Wallet(privateKey, provider);
                const contractInstance = new ethers.Contract(contractAddress, contractABI, wallet); // Connect the wallet to the contract
                setContract(contractInstance);
            } catch (error) {
                console.error("Error connecting to Anvil:", error);
            }
        };
        init();
    }, []);

    const fetchStoredData = async () => {
        if (contract) {
            try {
                const data = await contract.getNumber(); // Fetch data from the contract
                setStoredData(data);
            } catch (error) {
                console.error("Error fetching data:", error);
            }
        }
    };

    const updateStoredData = async () => {
        if (contract && inputValue) {
            try {
                const value = ethers.BigNumber.from(inputValue); // Convert the input value to a BigNumber
                const tx = await contract.setValue(value); // Call the setValue function on the contract
                const receipt = await tx.wait(); // Wait for the transaction to be mined
    
                // Extract detailed transaction information from the receipt
                const detailedTransaction = {
                    hash: tx.hash,
                    blockNumber: receipt.blockNumber,
                    // from: receipt.from ? receipt.from : 'N/A', // Safely access 'from' property
                    // to: receipt.to ? receipt.to : 'N/A', // Safely access 'to' property
                    gasUsed: receipt.gasUsed ? receipt.gasUsed.toString() : 'N/A', // Safely access 'gasUsed' property
                    cumulativeGasUsed: receipt.cumulativeGasUsed ? receipt.cumulativeGasUsed.toString() : 'N/A', // Safely access 'cumulativeGasUsed' property
                    effectiveGasPrice: receipt.effectiveGasPrice ? receipt.effectiveGasPrice.toString() : 'N/A', // Safely access 'effectiveGasPrice' property
                    status: receipt.status === 1 ? 'Success' : 'Failed', // 1 for success, 0 for failure
                    method: 'setValue',
                    value: inputValue,
                };
    
                setTransactions([...transactions, detailedTransaction]); // Store the detailed transaction info
                setInputValue(''); // Clear the input field after successful transaction
            } catch (error) {
                console.error("Error updating data:", error);
            }
        }
    };
    

    const handleInputChange = (event) => {
        setInputValue(event.target.value); // Update state with input value
    };

    return (
        <div className="w-full h-screen relative bg-[#00030c] text-white">
            <h1 className="text-2xl mb-4">Simple Storage</h1>
            <button
                className="bg-blue-500 text-white px-4 py-2 rounded mb-4"
                onClick={fetchStoredData}
            >
                Get Stored Data
            </button>
            <p className="mb-4">Stored Data: {storedData}</p>

            <div className="mb-4">
                <input
                    type="number"
                    value={inputValue}
                    onChange={handleInputChange}
                    className="bg-gray-800 border border-gray-600 px-3 py-2 rounded mr-4"
                />
                <button
                    className="bg-green-500 text-white px-4 py-2 rounded mt-2"
                    onClick={updateStoredData}
                >
                    Set Stored Data
                </button>
            </div>

            <h2 className="text-xl mb-2">Transactions</h2>
            <ul className="list-disc pl-5">
                {transactions.map((tx, index) => (
                    <li key={index} className="mb-2">
                        <p>Transaction Hash: <a href={`https://etherscan.io/tx/${tx.hash}`} target="_blank" rel="noopener noreferrer">{tx.hash}</a></p>
                        <p>Block Number: {tx.blockNumber}</p>
                        {/* <p>From: {tx.from}</p>
                        <p>To: {tx.to}</p> */}
                        <p>Gas Used: {tx.gasUsed}</p>
                        <p>Cumulative Gas Used: {tx.cumulativeGasUsed}</p>
                        <p>Effective Gas Price: {tx.effectiveGasPrice}</p>
                        <p>Status: {tx.status ? 'Success' : 'Failed'}</p>
                        <p>Method: {tx.method}</p>
                        <p>Value: {tx.value}</p>
                    </li>
                ))}
            </ul>
        </div>
    );
};

export default App;

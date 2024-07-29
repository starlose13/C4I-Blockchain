import './App.css';
import Navbar from "./Components/Navbar.jsx";
import Sidebar from "./Components/Sidebar.jsx";
import MapComponent from "./Components/MapComponent/MapComponents.jsx";



function App() {

    return (
        <div className="w-full h-screen relative bg-[#00030c]">
            <Navbar/>
            <div className="flex">
                <div>
                    <Sidebar/>
                </div>
                <div className="flex-grow mx-2 ">
                    <MapComponent/>
                </div>
            </div>
        </div>

    )
}


// import { useState, useEffect } from 'react';
// import { ethers } from 'ethers';

// // Replace with your contract's ABI and address
// const contractABI =[
//     {
//         "inputs": [],
//         "stateMutability": "view",
//         "type": "function",
//         "name": "getNumber",
//         "outputs": [
//             { "internalType": "uint256", "name": "", "type": "uint256" }
//         ]
//     },
//     {
//         "inputs": [
//             { "internalType": "uint256", "name": "_number", "type": "uint256" }
//         ],
//         "stateMutability": "nonpayable",
//         "type": "function",
//         "name": "setValue"
//     }
// ];

// const contractAddress = import.meta.env.VITE_STORAGE_CONTRACT_ADDRESS;
// const privateKey = import.meta.env.VITE_PRIVATE_KEY;
// const rpcUrl = import.meta.env.VITE_RPC_URL;


// const App = () => {
//     const [contract, setContract] = useState(null);
//     const [storedData, setStoredData] = useState(null);
//     const [transactions, setTransactions] = useState([]);

//     useEffect(() => {
//         const init = async () => {
//             try {
//                 const provider = new ethers.JsonRpcProvider(rpcUrl); // Anvil RPC URL
//                 const wallet = new ethers.Wallet(privateKey, provider); // Create a wallet using the private key
//                 const contractInstance = new ethers.Contract(contractAddress, contractABI, wallet); // Connect the wallet to the contract
//                 setContract(contractInstance);
//             } catch (error) {
//                 console.error("Error connecting to Anvil:", error);
//             }
//         };
//         init();
//     }, []);


//     const fetchStoredData = async () => {
//         if (contract) {
//             try {
//                 const data = await contract.getNumber();
//                 setStoredData(data.toString());
//             } catch (error) {
//                 console.error("Error fetching data:", error);
//             }
//         }
//     };


//     const updateStoredData = async (value) => {
//         if (contract) {
//             try {
//                 const tx = await contract.setValue(value); // Call the setValue function on the contract
//                 const receipt = await tx.wait(); // Wait for the transaction to be mined
//                 // Convert BigNumber values to string and timestamp to a readable date
//                 const detailedTransaction = {
//                     hash: tx.hash,
//                     blockNumber: receipt.blockNumber.toString(),
//                     blockHash: receipt.blockHash,
//                     from: tx.from,
//                     to: tx.to,
//                     gasUsed: receipt.gasUsed.toString(),
//                     status: receipt.status,
//                     method: 'setValue',
//                     value,
//                 };
//                 setTransactions([...transactions, detailedTransaction]); // Store the detailed transaction info
//             } catch (error) {
//                 console.error("Error updating data:", error);
//             }
//         }
//     };

//     return (
//         <div className="w-full h-full relative bg-[#00030c] text-white">
//             <div className='ml-4'>
//                 <h1 className="text-2xl mb-4">Simple Storage</h1>
//                 <button
//                     className="bg-blue-500 text-white px-4 py-2 rounded mb-4"
//                     onClick={fetchStoredData}
//                 >
//                     Get Stored Data
//                 </button>
//                 <p className="mb-4">Stored Data: {storedData}</p>

//                 <div className="mb-4">
//                     <button
//                         className="bg-gray-800 text-white px-4 py-2 rounded mt-2"
//                         onClick={() => updateStoredData(42)}>
//                         Set Stored Data to 42
//                     </button>
//                 </div>

//                 <h2 className="text-xl mb-2">Transactions</h2>
//                 <ul className='overflow-y-auto divide-y divide-solid'>
//                     {transactions.map((tx, index) => (
//                         <li key={index}>
//                             <br />
//                             <p>Transaction Hash: {tx.hash}</p>
//                             <p>Block Number: {tx.blockNumber}</p>
//                             <p>Block Hash: {tx.blockHash}</p>
//                             <p>From: {tx.from}</p>
//                             <p>To: {tx.to}</p>
//                             <p>Gas Used: {tx.gasUsed}</p>
//                             <p>Status: {tx.status ? 'Success' : 'Failed'}</p>
//                             <p>Method: {tx.method}</p>
//                             <p>Value: {tx.value}</p>
//                             <br />
//                         </li>
//                     ))}
//                 </ul>
//             </div>
//         </div>
//     );
// };

export default App;

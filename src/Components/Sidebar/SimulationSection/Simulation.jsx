import AddressCard from './AddressCard';
import "./scrollbar.css";
import { MainContext } from "../../../hooks/useSimulationContext.jsx";
import { useContext, useState } from "react";
import { useInteractWithNodeManagerContract } from "../../../hooks/useGetContract.jsx"
import { useInteractWithConsensusContract } from "../../../hooks/useGetContract.jsx"

/**
 * Simulation Component
 * @description This component fetches address data and renders the simulation UI.
 * @returns {JSX.Element} The rendered component
 */

const Simulation = () => {

    const [addresses, setAddresses] = useState([]);
    const [positions, setPositions] = useState([]);
    let { targetData } = useContext(MainContext)

    const { result: nodeData, error: nodeError } = useInteractWithNodeManagerContract();

    const handleRunSimulationClick = async () => {
        if (nodeData) {
            const addresses = nodeData.map(node => node.address);
            const positions = nodeData.map(node => node.position);
            setAddresses(addresses);
            setPositions(positions);
        }
    };

 

    const { error: consensusError } = useInteractWithConsensusContract(addresses, positions);



    // Main render
    return (
        <div className="w-[40rem] p-4">
            <h4 className="text-white mb-4 font-bold">Simulation</h4>
            <div className="grid grid-cols-2 gap-2 mb-2 overflow-y-scroll h-72">

                {targetData.map((addressData, index) => (
                    <AddressCard
                        key={index}
                        addressData={addressData}
                    />
                ))}
                
            </div>

            <button className="w-full text-sm bg-[#298bfe] text-[#d7e6f7] h-10" onClick={handleRunSimulationClick}>
                Run Simulation
            </button>

        </div>
    );
};

export default Simulation;
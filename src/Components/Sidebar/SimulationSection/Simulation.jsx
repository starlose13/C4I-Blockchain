import AddressCard from './AddressCard';
import "./scrollbar.css";
import { MainContext } from "../../../hooks/useSimulationContext.jsx";
import { useContext, useState, useEffect } from "react";
import { useFetchNodeAddresses, useSimulateTargetLocation, useConsensusExecution } from "../../../hooks/useGetContract.jsx";

const Simulation = () => {
    const { clickedData, targetData } = useContext(MainContext);

    const { result: resultObj } = useFetchNodeAddresses();
    const { simulateTargetLocation } = useSimulateTargetLocation();
    const { executeConsensus, data, error } = useConsensusExecution();
    const [fetchAddress, setFetchAddresses] = useState([]);
    
    useEffect(() => {
        if (fetchAddress.length !== 0 && clickedData.length !== 0) {
            simulateTargetLocation(fetchAddress, clickedData);
        }
    }, [fetchAddress, clickedData, simulateTargetLocation]);

    const handleRunSimulationClick = () => {
        
        const addresses = resultObj.map((res) => res);
        setFetchAddresses(addresses);
        setTimeout(() => {
            executeConsensus();
        }, 60000);
    };

    return (
        <div className="w-[40rem] p-4">
            <h4 className="text-white mb-4 font-bold">Simulation</h4>
            <div className="grid grid-cols-2 gap-2 mb-2 overflow-y-scroll h-72">
                {targetData.map((addressData, index) => (
                    <AddressCard key={index} addressData={addressData} />
                ))}
            </div>
            <button className="w-full text-sm bg-[#298bfe] text-[#d7e6f7] h-10" onClick={handleRunSimulationClick}>
                Run Simulation
            </button>
        </div>
    );
};

export default Simulation;

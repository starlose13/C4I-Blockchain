import AddressCard from './AddressCard';
import "./scrollbar.css";
import { MainContext } from "../../../hooks/useSimulationContext.jsx";
import { useContext, useState, useEffect } from "react";
import { useFetchNodeAddresses, useSimulateTargetLocation, useConsensusExecution } from "../../../hooks/useGetContract.jsx";


const Simulation = () => {
    const { clickedData, targetData, setTargetData } = useContext(MainContext);

    const { result: resultObj } = useFetchNodeAddresses();
    const { simulateTargetLocation } = useSimulateTargetLocation();
    const { executeConsensus, data, error } = useConsensusExecution();
    const [fetchAddress, setFetchAddresses] = useState([]);

    useEffect(() => {
        const runSimulation = async () => {
            try {
                if (fetchAddress.length !== 0 && clickedData.length !== 0) {
                    await simulateTargetLocation(fetchAddress, clickedData);
                    setTimeout(async () => {
                        await executeConsensus();
                        // setTargetData([
                        //     {
                        //         id: 1,
                        //         address: '0x13c857...a2297d22256',
                        //         NodePosition: '',
                        //         TargetLatitude: '',
                        //         TargetLongitude: '',
                        //         unitName: '',
                        //         TargetPositionName: '',
                        //         NodeLatitude: '48.8584° N',
                        //         NodeLongitude: '2.2945° E',
                        //     },
                        //     {
                        //         id: 2,
                        //         address: '0x13c857...a2297d22256',
                        //         NodePosition: '',
                        //         TargetLatitude: '',
                        //         TargetLongitude: '',
                        //         unitName: '',
                        //         TargetPositionName: '',
                        //         NodeLatitude: '48.8584° N',
                        //         NodeLongitude: '2.2945° E',
                        //     },
                        //     {
                        //         id: 3,
                        //         address: '0x13c857...a2297d22256',
                        //         NodePosition: '',
                        //         TargetLatitude: '',
                        //         TargetLongitude: '',
                        //         unitName: '',
                        //         TargetPositionName: '',
                        //         NodeLatitude: '48.8584° N',
                        //         NodeLongitude: '2.2945° E',
                        //     },
                        //     {
                        //         id: 4,
                        //         address: '0x13c857...a2297d22256',
                        //         NodePosition: '',
                        //         TargetLatitude: '',
                        //         TargetLongitude: '',
                        //         unitName: '',
                        //         TargetPositionName: '',
                        //         NodeLatitude: '48.8584° N',
                        //         NodeLongitude: '2.2945° E',
                        //     },
                        //     {
                        //         id: 5,
                        //         address: '0x13c857...a2297d22256',
                        //         NodePosition: '',
                        //         TargetLatitude: '',
                        //         TargetLongitude: '',
                        //         unitName: '',
                        //         TargetPositionName: '',
                        //         NodeLatitude: '48.8584° N',
                        //         NodeLongitude: '2.2945° E',
                        //     },
                        //     {
                        //         id: 6,
                        //         address: '0x13c857...a2297d22256',
                        //         NodePosition: '',
                        //         TargetLatitude: '',
                        //         TargetLongitude: '',
                        //         unitName: '',
                        //         TargetPositionName: '',
                        //         NodeLatitude: '48.8584° N',
                        //         NodeLongitude: '2.2945° E',
                        //     },
                        //     {
                        //         id: 7,
                        //         address: '0x13c857...a2297d22256',
                        //         NodePosition: '',
                        //         TargetLatitude: '',
                        //         TargetLongitude: '',
                        //         unitName: '',
                        //         TargetPositionName: '',
                        //         NodeLatitude: '48.8584° N',
                        //         NodeLongitude: '2.2945° E',
                        //     },
                        // ])



                        // setTargetData((prevData) => {
                        //     const updatedData = prevData.map((node, idx) => {
                        //       if (idx === selectedNode - 1) {
                        //         return {
                        //           ...node,
                        //           TargetLatitude: area.TargetLatitude,
                        //           TargetLongitude: area.TargetLongitude,
                        //           TargetPositionName: area.TargetPositionName,
                        //         };
                        //       }
                        //       return node;
                        //     });
                        //     return updatedData;
                        //   });
                    }, 5000);
                }
            } catch (err) {
                console.error("Error in simulating target location:", err);
            }
        };
        if (fetchAddress.length !== 0 && clickedData.length !== 0) {
            runSimulation();
        }
    }, []);
    const handleRunSimulationClick = () => {
        const addresses = resultObj.map((res) => res);
        setFetchAddresses(addresses);
    }
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

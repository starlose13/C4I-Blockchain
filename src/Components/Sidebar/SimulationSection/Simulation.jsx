import AddressCard from './AddressCard';
import "./scrollbar.css";
import { MainContext } from "../../../hooks/useSimulationContext.jsx";
import { useContext, useState, useEffect } from "react";

import {
    useSimulateTargetLocation, useConsensusExecution,
    useSimulationNumberOfEpoch, useSimulationNumberOfEachEpoch
} from "../../../hooks/useGetContract.jsx";


const Simulation = () => {

    const { targetData, setTargetData, setLoading } = useContext(MainContext);

    const { simulateTargetLocation } = useSimulateTargetLocation();

    const { executeConsensus, data, error } = useConsensusExecution();

    const { result: numberOfEpoch } = useSimulationNumberOfEpoch()

    const { result: numberOfEachEpoch } = useSimulationNumberOfEachEpoch(numberOfEpoch)

    const [address, setAddress] = useState([]);
    
    const [position, setPosition] = useState([]);

    useEffect(() => {
        const runSimulation = async () => {
            try {
                if (address.length > 0 && position.length > 0) {
                    await simulateTargetLocation(address, position);
                    setLoading(true);
                    setTimeout(async () => {
                        await executeConsensus();
                        console.log('Number of Epoch:', numberOfEpoch);
                        console.log('Number of Each Epoch:', numberOfEachEpoch);
                        setTargetData([
                            {
                                id: 1,
                                address: '0x13c857...a2297d22256',
                                NodePosition: '',
                                TargetLatitude: '',
                                TargetLongitude: '',
                                unitName: '',
                                TargetPositionName: '',
                                NodeLatitude: '48.8584° N',
                                NodeLongitude: '2.2945° E',
                                TargetId: '',
                            },
                            {
                                id: 2,
                                address: '0x13c857...a2297d22256',
                                NodePosition: '',
                                TargetLatitude: '',
                                TargetLongitude: '',
                                unitName: '',
                                TargetPositionName: '',
                                NodeLatitude: '48.8584° N',
                                NodeLongitude: '2.2945° E',
                                TargetId: '',

                            },
                            {
                                id: 3,
                                address: '0x13c857...a2297d22256',
                                NodePosition: '',
                                TargetLatitude: '',
                                TargetLongitude: '',
                                unitName: '',
                                TargetPositionName: '',
                                NodeLatitude: '48.8584° N',
                                NodeLongitude: '2.2945° E',
                                TargetId: '',

                            },
                            {
                                id: 4,
                                address: '0x13c857...a2297d22256',
                                NodePosition: '',
                                TargetLatitude: '',
                                TargetLongitude: '',
                                unitName: '',
                                TargetPositionName: '',
                                NodeLatitude: '48.8584° N',
                                NodeLongitude: '2.2945° E',
                                TargetId: '',

                            },
                            {
                                id: 5,
                                address: '0x13c857...a2297d22256',
                                NodePosition: '',
                                TargetLatitude: '',
                                TargetLongitude: '',
                                unitName: '',
                                TargetPositionName: '',
                                NodeLatitude: '48.8584° N',
                                NodeLongitude: '2.2945° E',
                                TargetId: '',

                            },
                            {
                                id: 6,
                                address: '0x13c857...a2297d22256',
                                NodePosition: '',
                                TargetLatitude: '',
                                TargetLongitude: '',
                                unitName: '',
                                TargetPositionName: '',
                                NodeLatitude: '48.8584° N',
                                NodeLongitude: '2.2945° E', TargetId: '',

                            },
                            {
                                id: 7,
                                address: '0x13c857...a2297d22256',
                                NodePosition: '',
                                TargetLatitude: '',
                                TargetLongitude: '',
                                unitName: '',
                                TargetPositionName: '',
                                NodeLatitude: '48.8584° N',
                                NodeLongitude: '2.2945° E', TargetId: '',

                            },
                        ])
                        setLoading(false);
                    }, 7000);
                }
            } catch (err) {
                console.error("Error in simulating target location:", err);
            }
        };
        if (address.length > 0 && position.length > 0) {
            runSimulation();
        }
    }, [address, position, numberOfEpoch, numberOfEachEpoch]);




    const handleRunSimulationClick = () => {
        const addressData = targetData
            .map((target) => target.TargetId !== '' ? target.address : undefined)
            .filter(Boolean);

        const positionData = targetData
            .map((target) => target.TargetId !== '' ? target.TargetId : undefined)
            .filter(Boolean);

        console.log('address is', addressData);
        console.log('position is', positionData);

        setAddress(addressData);
        setPosition(positionData);
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
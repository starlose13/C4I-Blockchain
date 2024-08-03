import AddressCard from './AddressCard';
import "./scrollbar.css";
import useAddressData from "../../../hooks/useAddressData.jsx";
import {MainContext} from "../../../hooks/useSimulationContext.jsx";
import {useContext, useEffect} from "react";

/**
 * Simulation Component
 * @description This component fetches address data and renders the simulation UI.
 * @returns {JSX.Element} The rendered component
 */

const Simulation = () => {

    let {targetData} = useContext(MainContext)
    const {loading, error} = useAddressData();

    useEffect(() => {
        console.log('targetData changed:', targetData);
    }, [targetData]);

    if (loading) return <div className="text-white">Loading...</div>;
    if (error) return <div className="text-red-500">Error: {error.message}</div>;


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

            <button className="w-full text-sm bg-[#298bfe] text-[#d7e6f7] h-10">
                Run Simulation
            </button>

        </div>
    );
};

export default Simulation;
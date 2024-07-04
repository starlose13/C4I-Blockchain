import React from 'react';
import AddressCard from './AddressCard';
import useAddressData from '../../../hooks/useAddressData';
import { ModalSimulation } from './ModalSimolation';
import './scrollbar.css';


/**
 * Simulation Component
 * @description This component fetches address data and renders the simulation UI.
 * @returns {JSX.Element} The rendered component
 */
const Simulation = () => {
    // Custom hook to fetch address data
    const { data, loading, error } = useAddressData();

    // Handle loading state
    if (loading) return <div className="text-white">Loading...</div>;

    // Handle error state
    if (error) return <div className="text-red-500">Error: {error.message}</div>;

    // Main render
    return (
        <div>
            <div className="w-[40rem] p-4 custom-scrollbar">
                <h4 className="text-white mb-4 font-bold">Simulation</h4>
                
                    <div
                        className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4 h-64 w-[40rem] overflow-y-scroll"
                    >
                        {data.map((addressData, index) => (
                            <AddressCard key={index} addressData={addressData} />
                        ))}
                    </div>
                <button className="w-full text-sm bg-[#298bfe] text-[#d7e6f7] h-10">
                    Run Simulation
                </button>
            </div>
        </div>
    );
};

export default Simulation;

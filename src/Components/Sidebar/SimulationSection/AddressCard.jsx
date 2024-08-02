import React, {useContext} from 'react';
import PropTypes from 'prop-types';
import {MainContext} from "../../../hooks/useSimulationContext.jsx"

/**
 * AddressCard Component
 * @description Renders individual address data.
 * @param {Object} props - Component properties
 * @param {Object} props.addressData - Data for a single address
 * @param {string} props.addressData.address - The address
 * @param {string} props.addressData.location - The location
 * @param {number} props.addressData.latitude - The latitude
 * @param {number} props.addressData.longitude - The longitude
 * @returns {JSX.Element} The rendered component
 */

const AddressCard = ({addressData}) => {
    const {id, address, location, latitude, longitude} = addressData;
    let {setSelectedNode} = useContext(MainContext)

    return (
        <div className="w-full p-2 bg-[#0d2f5c]" onClick={() => {
            setSelectedNode(id)
        }}>
            <h3 className="text-sm text-[#dfeeff]">Address</h3>
            <h4 className="text-xs text-[#5178a6]">{address}</h4>


            <div className="pt-2 grid grid-rows-3">
                <h3 className="text-sm text-red-500 font-bold">Target Position </h3>
                <h2 className="text-xs text-[#5178a6]">Location: {location}</h2>
                <h2 className="text-xs text-[#5178a6]">Latitude: {latitude}</h2>
                <h2 className="text-xs text-[#5178a6] ">Longitude: {longitude}</h2>
            </div>


            <div className="pt-2 grid grid-rows-3">
                <h3 className="text-sm text-[#dfeeff]">Node Position </h3>
                <h2 className="text-xs text-[#5178a6]">Location: {location}</h2>
                <h2 className="text-xs text-[#5178a6]">Latitude: {latitude}</h2>
                <h2 className="text-xs text-[#5178a6]">Longitude: {longitude}</h2>
            </div>


        </div>
    );
};

AddressCard.propTypes = {
    addressData: PropTypes.shape({
        address: PropTypes.string.isRequired,
        location: PropTypes.string.isRequired,
        latitude: PropTypes.number.isRequired,
        longitude: PropTypes.number.isRequired,
    }).isRequired,
};

export default AddressCard;
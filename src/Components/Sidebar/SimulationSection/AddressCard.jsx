import React, { useContext } from 'react';
import PropTypes from 'prop-types';
import { MainContext } from "../../../hooks/useSimulationContext.jsx"

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

const AddressCard = ({ addressData }) => {
    const {
        id,
        address,
        NodePosition,
        TargetLatitude,
        TargetLongitude,
        TargetPositionName,
        NodeLatitude,
        NodeLongitude
    } = addressData;

    const { selectedNode, setSelectedNode } = useContext(MainContext);
    const isSelected = selectedNode === id;

    return (
        <div
            className={`w-full p-2 ${isSelected ? 'raise border-2 border-blue-500 bg-[#0d2f5c]' : 'bg-[#0d2f5c]'} cursor-pointer`}
            onClick={() => setSelectedNode(id)}
        >
            <h3 className="text-sm text-[#dfeeff]">Address</h3>
            <h4 className="text-[11px] text-[#5178a6] ">{address}</h4>


            <div className="pt-2 grid grid-rows-3">
                <h3 className="text-sm text-red-500">Target Position </h3>
                <h2 className="text-xs text-[#5178a6]">Location: {TargetPositionName}</h2>
                <h2 className="text-xs text-[#5178a6]">Latitude: {TargetLatitude}</h2>
                <h2 className="text-xs text-[#5178a6] ">Longitude: {TargetLongitude}</h2>
            </div>


            <div className="pt-2 grid grid-rows-3">
                <h3 className="text-sm text-blue-500">Node Position </h3>
                <h2 className="text-xs text-[#5178a6]">Location: {NodePosition}</h2>
                <h2 className="text-xs text-[#5178a6]">Latitude: {NodeLatitude}</h2>
                <h2 className="text-xs text-[#5178a6]">Longitude: {NodeLongitude}</h2>
            </div>


        </div>
    );
};

AddressCard.propTypes = {
    addressData: PropTypes.shape({
        address: PropTypes.number.isRequired,
        location: PropTypes.number.isRequired,
        latitude: PropTypes.string.isRequired,
        longitude: PropTypes.string.isRequired,
    }).isRequired,
};
export default AddressCard;


import PropTypes from 'prop-types';

/**
 * AddressCard Component
 * @description Renders individual address data.
 * @param {Object} props - Component properties
 * @param {Object} props.addressData - Data for a single address
 * @param {string} props.addressData.address - The address
 * @param {string} props.addressData.location - The location
 * @param {number} props.addressData.latitude - The latitude
 * @param {number} props.addressData.longitude - The longitude
 * @param {Function} props.toggleModal - Function to toggle the modal
 * @returns {JSX.Element} The rendered component
 */


const AddressCard = ({ addressData, toggleModal }) => {
    const { address, location, latitude, longitude } = addressData;

    return (
        <div className="w-full p-2 bg-[#0d2f5c]" onClick={toggleModal}>
            <h3 className="text-sm text-[#dfeeff]">Address</h3>
            <h4 className="text-xs text-[#5178a6]">{address}</h4>
            <div className="pt-2">
                <h3 className="text-sm text-[#dfeeff]">Position</h3>
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
    toggleModal: PropTypes.func.isRequired,
};

export default AddressCard;

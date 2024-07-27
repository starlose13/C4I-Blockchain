import AddressCard from "./AddressCard";


/**
 * AddressList Component
 * @description Renders a list of address cards.
 * @param {Object} props - Component properties.
 * @param {Array} props.addressData - Array of address data objects.
 * @param {Function} props.onEdit - Function to handle editing an address.
 * @returns {JSX.Element} The rendered component.
 */


const AddressList = ({ addressData, onEdit }) => {
    return (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4 h-72 w-[38rem] overflow-y-scroll">
            {addressData.map((address, id) => (
                <AddressCard key={id} addressData={address} onEdit={() => onEdit(id)} />
            ))}
        </div>
    );
};

export default AddressList;

import SimulationForm from "./SimulationForm";



/**
 * Modal Component
 * @description Renders a modal with the simulation form.
 * @param {Object} props - Component properties.
 * @param {boolean} props.isOpen - Flag indicating if the modal is open.
 * @param {Function} props.onClose - Function to close the modal.
 * @param {Function} props.onSubmit - Function to handle form submission.
 * @param {Object} props.addressData - Initial values for the form fields.
 * @returns {JSX.Element} The rendered component.
 */


const Modal = ({ isOpen, onClose, onSubmit, addressData }) => {
    if (!isOpen) return null;

    return (
        <div
            tabIndex="-1"
            aria-hidden="true"
            className="fixed inset-0 z-50 flex justify-center items-center w-full h-full bg-[rgb(41, 139, 254, 0.4)] backdrop-blur-[20px]"
        >
            <div className="relative p-4 w-full max-w-lg h-full md:h-auto">
                <div className="relative p-4 w-full max-w-lg h-full md:h-auto">
                    <SimulationForm onSubmit={onSubmit} initialValues={addressData} onClose={onClose} />
                </div>
            </div>
        </div>
    );
};

export default Modal;

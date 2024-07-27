// import { useState, useEffect } from "react";
// import { Toaster } from "react-hot-toast";
// import useAddressData from "../../../hooks/useAddressData";
// import AddressList from "./AddressList";
// import Modal from "./Modal";
// import "./scrollbar.css";
//
// /**
//  * Simulation Component
//  * @description Manages address data and form submission for the simulation.
//  * @returns {JSX.Element} The rendered Simulation component.
//  */
//
// const Simulation = () => {
//   const { data: initialData, loading, error } = useAddressData();
//   const [addressData, setAddressData] = useState(initialData || []);
//   const [isModalOpen, setIsModalOpen] = useState(false);
//   const [currentAddressIndex, setCurrentAddressIndex] = useState(null);
//
//   useEffect(() => {
//     setAddressData(initialData);
//   }, [initialData]);
//
//   const toggleModal = (index = null) => {
//     setCurrentAddressIndex(index);
//     setIsModalOpen(!isModalOpen);
//   };
//
//   const handleFormSubmit = (formData) => {
//     if (!formData.address || !formData.name || !formData.latitude || !formData.longitude) {
//       console.error("Invalid form data", formData);
//       return;
//     }
//
//     const updatedAddress = {
//       address: formData.address,
//       location: formData.name,
//       latitude: parseFloat(formData.latitude),
//       longitude: parseFloat(formData.longitude),
//     };
//
//     setAddressData((prevData) => {
//       const newData = [...prevData];
//       newData[currentAddressIndex] = updatedAddress;
//       return newData;
//     });
//
//     toggleModal();
//   };
//
//   if (loading) return <div className="text-white">Loading...</div>;
//   if (error) return <div className="text-red-500">Error: {error.message}</div>;
//
//   return (
//       <div>
//         <Toaster position="top-left" reverseOrder={true} />
//         <div className="w-[40rem] p-4 custom-scrollbar">
//           <h4 className="text-white mb-4 font-bold">Simulation</h4>
//           <AddressList addressData={addressData} onEdit={toggleModal} />
//           <button
//               className="w-full text-sm bg-[#298bfe] text-[#d7e6f7] h-10"
//               onClick={() => toggleModal(null)}
//           >
//             Run Simulation
//           </button>
//         </div>
//         {isModalOpen && (
//             <Modal
//                 isOpen={isModalOpen}
//                 onClose={toggleModal}
//                 onSubmit={handleFormSubmit}
//                 addressData={addressData[currentAddressIndex]}
//             />
//         )}
//       </div>
//   );
// };
//
// export default Simulation;



import { useState, useEffect } from "react";
import { Toaster } from "react-hot-toast";
import useAddressData from "../../../hooks/useAddressData";
import AddressList from "./AddressList";
import Modal from "./Modal";
import "./scrollbar.css";

/**
 * Simulation Component
 * @description Manages address data and form submission for the simulation.
 * @returns {JSX.Element} The rendered Simulation component.
 */

const Simulation = () => {
  const { data: initialData, loading, error } = useAddressData();
  const [addressData, setAddressData] = useState(initialData || []);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [currentAddressIndex, setCurrentAddressIndex] = useState(null);

  useEffect(() => {
    setAddressData(initialData);
  }, [initialData]);

  const toggleModal = (index = null) => {
    setCurrentAddressIndex(index);
    setIsModalOpen(!isModalOpen);
  };

  const handleFormSubmit = (formData) => {
    if (!formData.address || !formData.name || !formData.latitude || !formData.longitude) {
      console.error("Invalid form data", formData);
      return;
    }

    const updatedAddress = {
      address: formData.address,
      location: formData.name,
      latitude: parseFloat(formData.latitude),
      longitude: parseFloat(formData.longitude),
    };

    setAddressData((prevData) => {
      const newData = [...prevData];
      newData[currentAddressIndex] = updatedAddress;
      return newData;
    });

    toggleModal();
  };

  if (loading) return <div className="text-white">Loading...</div>;
  if (error) return <div className="text-red-500">Error: {error.message}</div>;

  return (
      <div>
        <Toaster position="top-left" reverseOrder={true} />
        <div className="w-[40rem] p-4 custom-scrollbar">
          <h4 className="text-white mb-4 font-bold">Simulation</h4>
          <AddressList addressData={addressData} onEdit={toggleModal} />
          <button
              className="w-full text-sm bg-[#298bfe] text-[#d7e6f7] h-10"
          >
            Run Simulation
          </button>
        </div>

      </div>
  );
};

export default Simulation;

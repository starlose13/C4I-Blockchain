import { useState, useEffect } from "react";
import { useForm } from "react-hook-form";
import AddressCard from "./AddressCard";
import useAddressData from "../../../hooks/useAddressData";
import toast, { Toaster } from "react-hot-toast";
import "./scrollbar.css";


const Simulation = () => {
  const { data: initialData, loading, error } = useAddressData();
  const [addressData, setAddressData] = useState(initialData || []);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [currentAddressIndex, setCurrentAddressIndex] = useState(null);
  const {
    register,
    handleSubmit,
    setValue,
    formState: { errors, isSubmitted },
  } = useForm();

  useEffect(() => {
    setAddressData(initialData);
  }, [initialData]);

  const toggleModal = (index = null) => {
    setCurrentAddressIndex(index);
    if (index !== null && addressData[index]) {
      setValue("name", addressData[index].location);
      setValue("address", addressData[index].address);
      setValue("latitude", addressData[index].latitude);
      setValue("longitude", addressData[index].longitude);
    }
    setIsModalOpen(!isModalOpen);
  };

  const onSubmit = (formData) => {
    console.log("Form Data Submitted: ", formData); // Log form data
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

    toggleModal(); // Close modal on submit
  };

  useEffect(() => {
    if (isSubmitted) {
      if (errors.name) {
        toast.error("Enter Position", {
          icon: (
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              strokeWidth="1.5"
              stroke="currentColor"
              className="size-5 text-white"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                d="M9 6.75V15m6-6v8.25m.503 3.498 4.875-2.437c.381-.19.622-.58.622-1.006V4.82c0-.836-.88-1.38-1.628-1.006l-3.869 1.934c-.317.159-.69.159-1.006 0L9.503 3.252a1.125 1.125 0 0 0-1.006 0L3.622 5.689C3.24 5.88 3 6.27 3 6.695V19.18c0 .836.88 1.38 1.628 1.006l3.869-1.934c.317-.159.69-.159 1.006 0l4.994 2.497c.317.158.69.158 1.006 0Z"
              />
            </svg>
          ),
          style: {
            borderRadius: "10px",
            background: "#a60f0f",
            color: "#fff",
          },
        });
      }
      if (errors.latitude) {
        toast.error("Enter Latitude", {
          icon: (
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              strokeWidth="1.5"
              stroke="currentColor"
              className="size-5 text-white"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                d="M15 10.5a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z"
              />
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                d="M19.5 10.5c0 7.142-7.5 11.25-7.5 11.25S4.5 17.642 4.5 10.5a7.5 7.5 0 1 1 15 0Z"
              />
            </svg>
          ),
          style: {
            borderRadius: "10px",
            background: "#a60f0f",
            color: "#fff",
          },
        });
      }
      if (errors.longitude) {
        toast.error("Enter Longitude", {
          icon: (
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              strokeWidth="1.5"
              stroke="currentColor"
              className="size-5 text-white"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                d="M15 10.5a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z"
              />
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                d="M19.5 10.5c0 7.142-7.5 11.25-7.5 11.25S4.5 17.642 4.5 10.5a7.5 7.5 0 1 1 15 0Z"
              />
            </svg>
          ),
          style: {
            borderRadius: "10px",
            background: "#a60f0f",
            color: "#fff",
          },
        });
      }
    }
  });

  if (loading) return <div className="text-white">Loading...</div>;
  if (error) return <div className="text-red-500">Error: {error.message}</div>;

  return (
    <div>
      <Toaster position="top-left" reverseOrder={true} />
      <div className="w-[40rem] p-4 custom-scrollbar">
        <h4 className="text-white mb-4 font-bold">Simulation</h4>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4 h-72 w-[38rem] overflow-y-scroll">
          {addressData.map((address, id) => (
            <AddressCard
              key={id}
              addressData={address}
              onEdit={() => toggleModal(id)}
            />
          ))}
        </div>

        <button
          className="w-full text-sm bg-[#298bfe] text-[#d7e6f7] h-10"
          onClick={() => toggleModal(null)}
        >
          Run Simulation
        </button>
      </div>
      {isModalOpen && (
        <div
          tabIndex="-1"
          aria-hidden="true"
          className="fixed inset-0 z-50 flex justify-center items-center w-full h-full bg-[rgb(41, 139, 254, 0.4)] backdrop-blur-[20px]"
        >
          <div className="relative p-4 w-full max-w-lg h-full md:h-auto">
            <div className="relative p-4 w-full max-w-lg h-full md:h-auto">
              <form
                onSubmit={handleSubmit(onSubmit)}
                className="relative bg-[#0d2f5c7c] rounded-lg shadow py-4 px-6"
              >
                <div className="grid gap-4 mb-4 grid-cols-2">
                  <h3 className="text-xl my-8 font-semibold text-slate-200">
                    Add New Location
                  </h3>
                  <div className="col-span-2">
                    <label
                      htmlFor="name"
                      className="block mb-2 text-sm font-medium text-slate-300"
                    >
                      Position
                    </label>
                    <input
                      type="text"
                      id="name"
                      className="bg-sky-950 border border-sky-900 text-gray-100 text-sm rounded-lg block w-full p-2.5 placeholder-slate-400 text-red focus:outline-none"
                      placeholder="Eiffel Tower, Paris, France"
                      {...register("name", { required: true })}
                    />
                  </div>
                  <div className="col-span-2">
                    <label
                      htmlFor="address"
                      className="block mb-2 text-sm font-medium text-slate-300"
                    >
                      Address
                    </label>
                    <input
                      type="text"
                      id="address"
                      className="bg-sky-950 border border-sky-900 text-gray-100 text-sm rounded-lg block w-full p-2.5 placeholder-slate-400 text-red focus:outline-none"
                      placeholder="0x13c857...a2297d22256"
                      {...register("address", { required: true })}
                    />
                  </div>
                  <div className="col-span-1">
                    <label
                      htmlFor="latitude"
                      className="block mb-2 text-sm font-medium text-slate-300"
                    >
                      Latitude
                    </label>
                    <input
                      type="text"
                      id="latitude"
                      className="bg-sky-950 border border-sky-900 text-gray-100 text-sm rounded-lg block w-full p-2.5 placeholder-slate-400 text-red focus:ring-sky-950 focus:border-sky-950 focus:outline-none"
                      placeholder="48.8584° N"
                      {...register("latitude", { required: true })}
                    />
                  </div>

                  <div className="col-span-1">
                    <label
                      htmlFor="longitude"
                      className="block mb-2 text-sm font-medium text-slate-300"
                    >
                      Longitude
                    </label>
                    <input
                      type="text"
                      id="longitude"
                      className="bg-sky-950 border border-sky-900 text-gray-100 text-sm rounded-lg block w-full p-2.5 placeholder-slate-400 text-red focus:ring-sky-950 focus:border-sky-950 focus:outline-none"
                      placeholder="2.2945° E"
                      {...register("longitude", { required: true })}
                    />
                  </div>
                </div>

                <div className="flex justify-end mt-14">
                  <button
                    type="submit"
                    className="mr-4 text-white inline-flex items-center bg-blue-700 hover:bg-blue-800 focus:outline-none font-medium rounded-lg text-sm px-5 py-2.5 text-center"
                  >
                    Submit
                  </button>

                  <button
                    type="button"
                    className=" text-white inline-flex items-center bg-[#912020] hover:bg-[#5c1c1c] focus:outline-none font-medium rounded-lg text-sm px-5 py-2.5 text-center"
                    onClick={() => toggleModal()}
                  >
                    Close
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default Simulation;

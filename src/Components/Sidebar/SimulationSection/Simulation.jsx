import React, { useState } from "react";
import AddressCard from "./AddressCard";
import useAddressData from "../../../hooks/useAddressData";
import "./scrollbar.css";

const Simulation = () => {
  const { data, loading, error } = useAddressData();
  const [isModalOpen, setIsModalOpen] = useState(false);

  const toggleModal = () => {
    setIsModalOpen(!isModalOpen);
  };

  if (loading) return <div className="text-white">Loading...</div>;
  if (error) return <div className="text-red-500">Error: {error.message}</div>;

  return (
    <div>
      <div className="w-[40rem] p-4 custom-scrollbar">
        <h4 className="text-white mb-4 font-bold">Simulation</h4>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4 h-72 w-[38rem] overflow-y-scroll">
          {data.map((addressData, id) => (
            <AddressCard key={id} addressData={addressData} toggleModal={toggleModal} />
          ))}
        </div>
        <button className="w-full text-sm bg-[#298bfe] text-[#d7e6f7] h-10" onClick={toggleModal}>
          Run Simulation
        </button>
      </div>
      {isModalOpen && (
        <div
          tabIndex="-1"
          aria-hidden="true"
          className="fixed inset-0 z-50 flex justify-center items-center w-full h-full bg-[rgb(41, 139, 254)] backdrop-blur-[20px]"
        >
          <div className="relative p-4 w-full max-w-md max-h-full bg-[#0a324670] rounded-lg">
            <div className="relative">
              <div className="flex items-center justify-between p-4 md:p-5 ">
                <h3 className="text-2xl font-semibold text-gray-900 dark:text-white">
                  Add New Location
                </h3>
              </div>
              <form className="p-4 md:p-5">
                <div className="grid gap-4 mb-4 grid-cols-2">
                  <div className="col-span-2">
                    <label
                      htmlFor="name"
                      className="block mb-2 text-sm font-medium text-slate-400"
                    >
                      Position
                    </label>
                    <input
                      type="text"
                      name="name"
                      id="name"
                      className="bg-sky-950 border border-sky-900 text-gray-100 text-sm rounded-lg block w-full p-2.5 placeholder-slate-400 text-red focus:outline-none"
                      placeholder="Eiffel Tower, Paris, France"
                      required
                    />
                  </div>

                  <div className="col-span-1">
                    <label
                      htmlFor="latitude"
                      className="block mb-2 text-sm font-medium text-slate-400"
                    >
                      Latitude
                    </label>
                    <input
                      type="text"
                      name="latitude"
                      id="latitude"
                      className="bg-sky-950 border border-sky-900 text-gray-100 text-sm rounded-lg block w-full p-2.5 placeholder-slate-400 text-red focus:ring-sky-950 focus:border-sky-950 focus:outline-none"
                      placeholder="48.8584° N"
                      required
                    />
                  </div>

                  <div className="col-span-1">
                    <label
                      htmlFor="longitude"
                      className="block mb-2 text-sm font-medium text-slate-400"
                    >
                      Longitude
                    </label>
                    <input
                      type="text"
                      name="longitude"
                      id="longitude"
                      className="bg-sky-950 border border-sky-900 text-gray-100 text-sm rounded-lg block w-full p-2.5 placeholder-slate-400 text-red focus:ring-sky-950 focus:border-sky-950 focus:outline-none"
                      placeholder="2.2945° E"
                      required
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
                    className=" text-white inline-flex items-center bg-[#d81d1d] hover:bg-[#a61919] focus:outline-none font-medium rounded-lg text-sm px-5 py-2.5 text-center"
                    onClick={toggleModal}
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

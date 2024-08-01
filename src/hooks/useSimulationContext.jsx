// import React, { createContext, useState, useEffect } from "react";
// import dataArea from '../../src/Components/MapComponent/areas.json';
// import useAddressData from './useAddressData';
//
// export const SimulationData = createContext();
//
// export const SimulationDataProvider = ({ children }) => {
//     const { data: addressData, loading, error } = useAddressData();
//     const [data, setData] = useState({
//         location: "",
//         latitude: "",
//         longitude: "",
//     });
//
//     const updateData = (areaId) => {
//         const area = dataArea.find(a => a.name === areaId);
//         if (!area) {
//             console.warn("Area not found for areaId:", areaId);
//             return;
//         }
//
//         const addressInfo = addressData.find(a => a.address === area.publicAddress);
//         if (!addressInfo) {
//             console.warn("Address info not found for publicAddress:", area.publicAddress);
//             return;
//         }
//
//         setData({
//             location: addressInfo.location || "",
//             latitude: addressInfo.latitude || "",
//             longitude: addressInfo.longitude || "",
//         });
//     };
//
//     return (
//         <SimulationData.Provider value={{ data, updateData, loading, error }}>
//             {children}
//         </SimulationData.Provider>
//     );
// };

import {createContext} from "react";
export const MainContext = createContext()


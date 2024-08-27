import './App.css';
import Navbar from "./Components/Navbar.jsx";
import Sidebar from "./Components/Sidebar.jsx";
import Map from "./Components/MapComponent/Map.jsx";
import { MainContext } from "./hooks/useSimulationContext.jsx";
import React, { useState, useEffect } from "react";
import { useConsensusExecution } from './hooks/useGetContract.jsx'


function App() {
    const [selectedNode, setSelectedNode] = useState(0)
    const [targetData, setTargetData] = useState([
        {
            id: 1,
            address: '0x13c857...a2297d22256',
            NodePosition: '',
            TargetLatitude: '',
            TargetLongitude: '',
            unitName: '',
            TargetPositionName: '',
            NodeLatitude: '48.8584° N',
            NodeLongitude: '2.2945° E',
        },
        {
            id: 2,
            address: '0x13c857...a2297d22256',
            NodePosition: '',
            TargetLatitude: '',
            TargetLongitude: '',
            unitName: '',
            TargetPositionName: '',
            NodeLatitude: '48.8584° N',
            NodeLongitude: '2.2945° E',
        },
        {
            id: 3,
            address: '0x13c857...a2297d22256',
            NodePosition: '',
            TargetLatitude: '',
            TargetLongitude: '',
            unitName: '',
            TargetPositionName: '',
            NodeLatitude: '48.8584° N',
            NodeLongitude: '2.2945° E',
        },
        {
            id: 4,
            address: '0x13c857...a2297d22256',
            NodePosition: '',
            TargetLatitude: '',
            TargetLongitude: '',
            unitName: '',
            TargetPositionName: '',
            NodeLatitude: '48.8584° N',
            NodeLongitude: '2.2945° E',
        },
        {
            id: 5,
            address: '0x13c857...a2297d22256',
            NodePosition: '',
            TargetLatitude: '',
            TargetLongitude: '',
            unitName: '',
            TargetPositionName: '',
            NodeLatitude: '48.8584° N',
            NodeLongitude: '2.2945° E',
        },
        {
            id: 6,
            address: '0x13c857...a2297d22256',
            NodePosition: '',
            TargetLatitude: '',
            TargetLongitude: '',
            unitName: '',
            TargetPositionName: '',
            NodeLatitude: '48.8584° N',
            NodeLongitude: '2.2945° E',
        },
        {
            id: 7,
            address: '0x13c857...a2297d22256',
            NodePosition: '',
            TargetLatitude: '',
            TargetLongitude: '',
            unitName: '',
            TargetPositionName: '',
            NodeLatitude: '48.8584° N',
            NodeLongitude: '2.2945° E',
        },
    ])

    const [clickedData, setClickedData] = useState([]);
    const [address, setAddresses] = useState([])

    return (
        <MainContext.Provider
            value={{ selectedNode, setSelectedNode, targetData, setTargetData, clickedData, setClickedData, address, setAddresses }}>
            <div className=" w-screen h-screen relative bg-[#00030c]">
                <Navbar />
                <div className="flex">
                    <div>
                        <Sidebar />
                    </div>
                    <div className="flex-grow mx-2 ">
                        <Map />
                    </div>
                </div>
            </div>
        </MainContext.Provider>
    )
}


export default App;



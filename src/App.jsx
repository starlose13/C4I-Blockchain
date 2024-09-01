import './App.css';
import Navbar from "./Components/Navbar.jsx";
import Sidebar from "./Components/Sidebar.jsx";
import Map from "./Components/MapComponent/Map.jsx";
import { MainContext } from "./hooks/useSimulationContext.jsx";
import React, { useState } from "react";
import Loader from './Components/StyledComponent/StyledComponent.jsx'


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
            TargetId: '',
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
            TargetId: '',

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
            TargetId: '',

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
            TargetId: '',

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
            TargetId: '',

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
            NodeLongitude: '2.2945° E', TargetId: '',

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
            NodeLongitude: '2.2945° E', TargetId: '',

        },
    ])
    const [clickedData, setClickedData] = useState([]);
    const [address, setAddresses] = useState([])
    const [loading, setLoading] = useState(false);

    // const {result} = useSimulationNumberOfEpoch()


    return (
        <MainContext.Provider
            value={{
                selectedNode,
                setSelectedNode,
                targetData,
                setTargetData,
                clickedData,
                setClickedData,
                address,
                setAddresses,
                loading,
                setLoading,
            }}
        >
            <div className="w-screen h-screen relative bg-[#00030c]">
                {loading ? (
                    <>
                        <div className="bg-[url('/background.png')] bg-cover bg-fixed bg-repeat blur-xl flex items-center justify-center h-full"></div>
                        <Loader />
                    </>
                ) : (
                    <>
                        <Navbar />
                        <div className="flex">
                            <Sidebar />
                            <div className="flex-grow mx-2 h-full bg-[#00030c]">
                                <Map />
                            </div>
                        </div>
                    </>
                )}
            </div>
        </MainContext.Provider>
    );

}


export default App;



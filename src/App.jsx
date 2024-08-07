import './App.css';
import Navbar from "./Components/Navbar.jsx";
import Sidebar from "./Components/Sidebar.jsx";
import MapComponent from "./Components/MapComponent/MapComponents.jsx";
import {MainContext} from "./hooks/useSimulationContext.jsx";
import React, {useState} from "react";
import {useInteractWithNodeManagerContract} from "./hooks/useGetContract.jsx";


function App() {
    const [selectedNode, setSelectedNode] = useState(0)
    const [targetData, setTargetData] = useState([
        {
            id: 1,
            address: '0x13c857...a2297d22256',
            location: 'Eiffel Tower, Paris, France',
            TargetLatitude: '48.8584° N',
            TargetLongitude: '2.2945° E',
            NodePositionName: 'Eiffel Tower, Paris, France',
            NodeLatitude: '48.8584° N',
            NodeLongitude: '2.2945° E',
        },
        {
            id: 2,
            address: '0x13c857...a2297d22256',
            location: 'Eiffel Tower, Paris, France',
            TargetLatitude: '48.8584° N',
            TargetLongitude: '2.2945° E',
            NodePositionName: 'Eiffel Tower, Paris, France',
            NodeLatitude: '48.8584° N',
            NodeLongitude: '2.2945° E',
        },
        {
            id: 3,
            address: '0x13c857...a2297d22256',
            location: 'Eiffel Tower, Paris, France',
            TargetLatitude: '48.8584° N',
            TargetLongitude: '2.2945° E',
            NodePositionName: 'Eiffel Tower, Paris, France',
            NodeLatitude: '48.8584° N',
            NodeLongitude: '2.2945° E',
        },
        {
            id: 4,
            address: '0x13c857...a2297d22256',
            location: 'Eiffel Tower, Paris, France',
            TargetLatitude: '48.8584° N',
            TargetLongitude: '2.2945° E',
            NodePositionName: 'Eiffel Tower, Paris, France',
            NodeLatitude: '48.8584° N',
            NodeLongitude: '2.2945° E',
        },
        {
            id: 5,
            address: '0x13c857...a2297d22256',
            location: 'Eiffel Tower, Paris, France',
            TargetLatitude: '48.8584° N',
            TargetLongitude: '2.2945° E',
            NodePositionName: 'Eiffel Tower, Paris, France',
            NodeLatitude: '48.8584° N',
            NodeLongitude: '2.2945° E',
        },
        {
            id: 6,
            address: '0x13c857...a2297d22256',
            location: 'Eiffel Tower, Paris, France',
            TargetLatitude: '48.8584° N',
            TargetLongitude: '2.2945° E',
            NodePositionName: 'Eiffel Tower, Paris, France',
            NodeLatitude: '48.8584° N',
            NodeLongitude: '2.2945° E',
        },
        {
            id: 7,
            address: '0x13c857...a2297d22256',
            location: 'Eiffel Tower, Paris, France',
            TargetLatitude: '48.8584° N',
            TargetLongitude: '2.2945° E',
            NodePositionName: 'Eiffel Tower, Paris, France',
            NodeLatitude: '48.8584° N',
            NodeLongitude: '2.2945° E',
        },
    ])

    const  result  = useInteractWithNodeManagerContract();
    const {res,err} = result

   

    return (
        <MainContext.Provider
            value={{selectedNode, setSelectedNode, targetData, setTargetData}}>
            <div className="w-full h-screen relative bg-[#00030c]">
                <Navbar/>
                <div className="flex">
                    <div>
                        <Sidebar/>
                    </div>
                    <div className="flex-grow mx-2 ">
                        <MapComponent/>
                    </div>
                </div>
            </div>
        </MainContext.Provider>
    )
}


export default App;



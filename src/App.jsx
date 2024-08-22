import './App.css';
import Navbar from "./Components/Navbar.jsx";
import Sidebar from "./Components/Sidebar.jsx";
import Map from "./Components/MapComponent/Map.jsx";
import { MainContext } from "./hooks/useSimulationContext.jsx";
import React, { useState } from "react";


function App() {
    const [selectedNode, setSelectedNode] = useState(0)
    const [targetData, setTargetData] = useState([
            {
                "data": {
                    "wallet_address": "0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266",
                    "position": "aaaaa",
                    "unit": {
                        "name": "Bravo Commander"
                    },
                    "location": {
                        "latitude": "38.907299",
                        "longitude": "-77.036873"
                    },
                    "communications": {
                        "encryption": "AES-256"
                    }
                },
                "id": 1
            },
            {
                "data": {
                    "wallet_address": "0x70997970c51812dc3a010c7d01b50e0d17dc79c8",
                    "position": "bbbbb",
                    "unit": {
                        "name": "Bravo Commander"
                    },
                    "location": {
                        "latitude": "37.774929",
                        "longitude": "-122.419418"
                    },
                    "communications": {
                        "encryption": "AES-256"
                    }
                },
                "id": 2
            },
            {
                "data": {
                    "wallet_address": "0x3c44cdddb6a900fa2b585dd299e03d12fa4293bc",
                    "position": "cccc",
                    "unit": {
                        "name": "Bravo Commander"
                    },
                    "location": {
                        "latitude": "51.507351",
                        "longitude": "-0.127758"
                    },
                    "communications": {
                        "encryption": "AES-256"
                    }
                },
                "id": 3
            },
            {
                "data": {
                    "wallet_address": "0x90f79bf6eb2c4f870365e785982e1f101e93b906",
                    "position": "dddd",
                    "unit": {
                        "name": "Bravo Commander"
                    },
                    "location": {
                        "latitude": "35.689487",
                        "longitude": "139.691711"
                    },
                    "communications": {
                        "encryption": "AES-256"
                    }
                },
                "id": 4
            },
            {
                "data": {
                    "wallet_address": "0x15d34aaf54267db7d7c367839aaf71a00a2c6a65",
                    "position": "eeee",
                    "unit": {
                        "name": "Bravo Commander"
                    },
                    "location": {
                        "latitude": "40.416775",
                        "longitude": "-3.703790"
                    },
                    "communications": {
                        "encryption": "AES-256"
                    }
                },
                "id": 5
            },
            {
                "data": {
                    "wallet_address": "0x9965507d1a55bcc2695c58ba16fb37d819b0a4dc",
                    "position": "fffff",
                    "unit": {
                        "name": "Bravo Commander"
                    },
                    "location": {
                        "latitude": "-33.868820",
                        "longitude": "151.209295"
                    },
                    "communications": {
                        "encryption": "AES-256"
                    }
                },
                "id": 6
            },
            {
                "data": {
                    "wallet_address": "0x976ea74026e726554db657fa54763abd0c3a0aa9",
                    "position": "ggggg",
                    "unit": {
                        "name": "Bravo Commander"
                    },
                    "location": {
                        "latitude": "-15.779072",
                        "longitude": "-47.929215"
                    },
                    "communications": {
                        "encryption": "AES-256"
                    }
                },
                "id": 7
            }
    ])

    const [clickedData, setClickedData] = useState([]);
    const [address, setAddresses] = useState([])
    const [formattedData, setFormattedData] = useState([]);



    return (
        <MainContext.Provider
            value={{ selectedNode, setSelectedNode, targetData, setTargetData, clickedData, setClickedData, address, setAddresses, formattedData, setFormattedData }}>
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



import './App.css'
    import Navbar from "./Components/Navbar.jsx";
import Sidebar from "./Components/Sidebar.jsx";
import MapComponent from "./Components/MainContent/MainContent.jsx";


function App() {

    return (
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

    )
}

export default App


// 
import {useState} from "react";
import MapImage from "./MapImage.jsx";
import TooltipComponent from "./ToolTip/TooltipComponent.jsx";
import areas from './data/areas.json'


const MapComponent = () => {
    const [toolTipData, setToolTipData] = useState({
        visible: false,
        area: {},
        position: {x: 0, y: 0}
    });


    const handleAreaClick = (area, index, event) => {
        const x = event.nativeEvent.offsetX;
        const y = event.nativeEvent.offsetY;
        setToolTipData({visible: true, area: area, position: {x, y}});
    };


    return (
        <div className="ml-48">
            <MapImage areas={areas} onAreaClick={handleAreaClick}/>
            <TooltipComponent
                area={toolTipData.area}
                visible={toolTipData.visible}
                position={toolTipData.position}
            />
        </div>
    );
};


export default MapComponent;
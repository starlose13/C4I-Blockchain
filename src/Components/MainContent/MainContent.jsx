// import ImageMapper from 'react-image-mapper';
// import areas from './areas.json';
// import NodeTooltip from "./NodeTooltip.jsx";
// import TargetTooltip from "./TargetTooltip.jsx"
// import { useState } from "react";

// const MapComponent = () => {
//     const URL = "/x.jpg";
//     const width = 2100;
//     const height = 1200;
//     const imgWidth = 1665;
//     const imgHeight = 957;
//     const [tooltipData, setTooltipData] = useState({
//         visible: false,
//         area: {},
//         position: { x: 0, y: 0 }
//     });
//     const scaleCoords = (coords, width, height) => {
//         return coords.map((coord, index) => {
//             return index % 2 === 0 ? coord * width : coord * height
//         })
//     };
//     const MAP = {
//         name: "Map",
//         areas: areas.map((area) => {
//             return {
//                 name: area.name,
//                 shape: area.shape,
//                 preFillColor: area.preFillColor,
//                 fillColor: area.fillColor,
//                 coords: scaleCoords(area.coords, imgWidth, imgHeight)
//             };
//         })
//     };
//     const handleAreaClick = (area, index, event) => {
//         const offset = 100;
//         const x = event.clientX - 25;
//         const y = event.clientY;
//         console.log(`clientX: ${x}, clientY: ${y}`);
//         setTooltipData({ visible: true, area: area, position: { x, y } });
//     };
//     return (
//         <div className="ml-48 mt-10">
//             <div className="drop-shadow relative">
//                 <ImageMapper
//                     src={URL}
//                     map={MAP}
//                     onClick={handleAreaClick}
//                     width={width}
//                     height={height}
//                     imgWidth={imgWidth}
//                     imgHeight={imgHeight}
//                     strokeColor={"transparent"}
//                     alt="Map Image"
//                 />
//                 {/* <div className='absolute top-80 text-2xl left-80 text-black bg-yellow-50 z-50'>
//                     <NodeTooltip area={tooltipData.area} visible={tooltipData.visible}
//                         position={tooltipData.position} />
//                 </div> */}
//             </div>
//             <TargetTooltip area={tooltipData.area} visible={tooltipData.visible}
//                 position={tooltipData.position} />
//         </div>
//     )
// };
// export default MapComponent;












import React, { useState } from 'react';
import ImageMapper from 'react-image-mapper';
import areas from './areas.json';
import nodes from './node.json';
import NodeTooltip from "./NodeTooltip.jsx";
import TargetTooltip from "./TargetTooltip.jsx";


const MapComponent = () => {
    const URL = "/x.jpg";
    const width = 2100;
    const height = 1200;
    const imgWidth = 1665;
    const imgHeight = 957;

    const nodeWidth = 1000;
    const nodeHeight = 500;

    const [tooltipData, setTooltipData] = useState({
        visible: false,
        area: {},
        position: { x: 0, y: 0 }
    });

    const scaleCoords = (coords, width, height) => {
        return coords.map((coord, index) => {
            return index % 2 === 0 ? coord * width : coord * height;
        });
    };

    const MAP = {
        name: "Map",
        areas: areas.map((area) => {
            return {
                name: area.name,
                shape: area.shape,
                preFillColor: area.preFillColor,
                fillColor: area.fillColor,
                coords: scaleCoords(area.coords, imgWidth, imgHeight)
            };
        })
    };

    const handleAreaClick = (area, index, event) => {
        const x = event.clientX - 25;
        const y = event.clientY;
        console.log(`clientX: ${x}, clientY: ${y}`);
        setTooltipData({ visible: true, area: area, position: { x, y } });
    };

    const renderNodes = () => {
        return nodes.map((node, index) => {
            const scaledX = node.coords[0] * nodeWidth;
            const scaledY = node.coords[1] * nodeHeight;



            return (
                <div
                    key={index}
                    className='absolute top-80 text-2xl left-80 text-black bg-yellow-50 z-50'
                    style={{
                        left: `${scaledX}px`,
                        top: `${scaledY}px`,
                    }}
                >
                    <NodeTooltip
                        area={node}
                        visible={true}
                        position={{ x: scaledX, y: scaledY }}
                        radius={node.coords[2]} // Assuming NodeTooltip can handle a radius prop if needed
                    />
                </div>
            );
        });
    };
    return (
        <div className="ml-48 mt-10">
            <div className="drop-shadow relative">
                <ImageMapper
                    src={URL}
                    map={MAP}
                    onClick={handleAreaClick}
                    width={width}
                    height={height}
                    imgWidth={imgWidth}
                    imgHeight={imgHeight}
                    strokeColor={"transparent"}
                    alt="Map Image"
                />
                 {renderNodes()}
                {tooltipData.visible && (
                    <div
                        className='absolute z-50'
                        style={{
                            left: `${tooltipData.position.x}px`,
                            top: `${tooltipData.position.y}px`,
                        }}
                    >
                    </div>
                )}


            </div>
            <TargetTooltip className='z-50' area={tooltipData.area} visible={tooltipData.visible} position={tooltipData.position} />
        </div>);


};

export default MapComponent;
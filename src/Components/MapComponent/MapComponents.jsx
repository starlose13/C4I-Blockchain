import React, { useContext, useState } from 'react';
import ImageMapper from 'react-image-mapper';
import areas from './areas.json';
import nodes from './node.json';
import NodeTooltip from "./NodeTooltip.jsx";
import TargetTooltip from "./TargetTooltip.jsx";
import { MainContext } from "../../hooks/useSimulationContext.jsx";
import { useFetchNodeAddresses } from "../../hooks/useGetContract.jsx";


const MapComponent = () => {

    const { targetData, setTargetData, selectedNode } = useContext(MainContext);
    const [positionArray, setPositionArray] = useState([]);

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

    const getdata = useFetchNodeAddresses ();

    const handleAreaClick = (area, index, event) => {
        let { result } = getdata;     

        console.log("area is: ", area);

        let _area_;
        result.map(a => {
            if (area.name === a.id) {
                _area_ = a;
            }
        });

        if (_area_) {
            console.log("_area_ :", _area_);
        } else {
            console.log("Area not found in result");
            return;
        }
        console.log(_area_);

        const x = event.clientX - 25;
        const y = event.clientY;

        // Update positionArray outside of setTargetData to avoid state update during rendering
        setPositionArray(prevPositionArray => {
            const positionExists = prevPositionArray.some(position => position === _area_.position);
            if (!positionExists) {
                return [...prevPositionArray, _area_.position];
            }
            return prevPositionArray;
        });

        // Update targetData
        setTargetData(prevData => {
            const updatedData = prevData.map((node, idx) => {
                if (idx === selectedNode - 1 ) {

                    return {
                        ...node,
                        address: _area_.address,//URIDATAFORMAT /// nodeData (pref)
                        TargetLatitude: _area_.ipfsData,//send by front-ned
                        TargetLongitude: _area_.ipfsData, //send by front-ned
                        location: _area_.position, 
                        NodeLatitude: _area_.ipfsData, //URIDATAFORMAT
                        NodeLongitude: _area_.ipfsData, //URIDATAFORMAT
                        NodePositionName: _area_.ipfsData,// URIDATAFORMAT
                    };
                }
                return node;
            });
            return updatedData;
        });

        const adjustedX = Math.min(x, window.innerWidth - 500);
        const adjustedY = Math.min(y, window.innerHeight - 300);
        setTooltipData({ visible: true, areaId: area.name, position: { x: adjustedX, y: adjustedY } });
    };

    // useEffect(() => {
        // console.log("Updated positionArray: ", positionArray);
    // }, [positionArray]);



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
                        radius={node.coords[2]}
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
                    strokeColor={"red"}
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

            <TargetTooltip
                className='z-50'
                areaId={tooltipData.area}
                visible={tooltipData.visible}
                position={tooltipData.position}
            />
        </div>
    );
};

export default MapComponent;


import React, { useContext, useState, useEffect, useRef } from "react";
import ImageMapper from "react-image-mapper";
import areas from "./JsonData/areas.json";
import nodes from "./JsonData/node.json";
import NodeTooltip from "./NodeTooltip.jsx";
import TargetTooltip from "./TargetTooltip.jsx";
import { MainContext } from "../../hooks/useSimulationContext.jsx";
import {
  useFetchNodeAddresses,
  useFormatAndFetchURIData,
} from "../../hooks/useGetContract";

const Map = () => {
  const { targetData, setTargetData, selectedNode, setClickedData } =
    useContext(MainContext);

  const { address, setAddresses } = useContext(MainContext);
  const [formattedData, setFormattedData] = useState([]);
  const mappedDataRef = useRef([]);  // Store mappedData here
  const { result: addressResult } = useFetchNodeAddresses();

  const decodeBase64Data = (dataObject) => {
    try {
      if (!dataObject || typeof dataObject !== "string") {
        throw new Error("Invalid dataObject or missing 'data' property");
      }

      const base64String = dataObject.split(",")[1];
      if (!base64String) {
        throw new Error("Failed to extract Base64 string");
      }

      const decodedString = atob(base64String);
      const jsonData = JSON.parse(decodedString);
      return jsonData;

    } catch (error) {
      console.error("Error decoding and parsing JSON:", error);
      return null;
    }
  };

  useEffect(() => {
    if (addressResult) {
      setAddresses(addressResult);
    }
  }, [addressResult]);

  useEffect(() => {
    const fetchAndFormatData = async () => {
      const results = await Promise.all(
        address.map(async (ad) => {
          const data = await useFormatAndFetchURIData(ad);
          const decodedData = decodeBase64Data(data);
          return { ad, data: decodedData || "Decoding failed or no data" };
        })
      );
      setFormattedData(results);
    };

    if (address.length > 0) {
      fetchAndFormatData();
    }
  }, [address]);

  useEffect(() => {
    if (formattedData.length > 0) {
      const newMappedData = formattedData.map((data, index) => {
        let template = targetData[index];
        let temp = {
          address: data.ad,
          NodePosition: data.data.position,
          unitName: data.data.unit.name,
          NodeLatitude: data.data.location.latitude,
          NodeLongitude: data.data.location.longitude,
        };

        return Object.assign(
          {},
          template,
          ...Object.keys(template).map(k => k in temp && { [k]: temp[k] })
        );

      });

      mappedDataRef.current = newMappedData; // Update the ref value
      setTargetData(newMappedData); // Update targetData once
    }
  }, [formattedData, targetData]);

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
    position: { x: 0, y: 0 },
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
        TargetLatitude: area.TargetLatitude,
        TargetLongitude: area.TargetLongitude,
        TargetPositionName: area.TargetPositionName,

        fillColor: area.fillColor,
        coords: scaleCoords(area.coords, imgWidth, imgHeight),
      };
    }),
  };

  const handleAreaClick = (area, index, event) => {



    setClickedData((prevData) => {
      if (prevData.length < 7) {
        const newData = [...prevData, area.name];
        return newData;
      } else {
        alert("Length of clickedData is already enough. No new item added.");
        return prevData;
      }
    });

    const x = event.clientX - 25;
    const y = event.clientY;

    setTargetData((prevData) => {
      const updatedData = prevData.map((node, idx) => {
        if (idx === selectedNode - 1) {
          console.log(area.TargetLatitude)
          console.log("hora")
          return {
            ...node,
            TargetLatitude: area.TargetLatitude,
            TargetLongitude: area.TargetLongitude,
            TargetPositionName: area.TargetPositionName,
            // NodeLatitude: area.NodeLatitude,
            // NodeLongitude: area.NodeLongitude,
            // NodePositionName: area.NodePositionName,
          };
        }
        return node;
      });
      return updatedData;
    });

    const adjustedX = Math.min(x, window.innerWidth - 500);
    const adjustedY = Math.min(y, window.innerHeight - 300);
    setTooltipData({
      visible: true,
      areaId: area.name,
      position: { x: adjustedX, y: adjustedY },
    });
  };

  const renderNodes = () => {
    return nodes.map((node, index) => {
      const scaledX = node.coords[0] * nodeWidth;
      const scaledY = node.coords[1] * nodeHeight;
      return (
        <div
          key={index}
          className="absolute top-80 text-2xl left-80 text-black bg-yellow-50 z-50"
          style={{
            left: `${scaledX}px`,
            top: `${scaledY}px`,
          }}
        >
          <NodeTooltip
            area={targetData[index]?.NodePosition}
            visible={true}
            position={{ x: scaledX, y: scaledY }}
            nodeLan={targetData[index].NodeLongitude}
            nodeLat={targetData[index].NodeLatitude}
            address={targetData[index].address}
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
          strokeColor={"transparent"}
          alt="Map Image"
        />
        {renderNodes()}
        {tooltipData.visible && (
          <div
            className="absolute z-50"
            style={{
              left: `${tooltipData.position.x}px`,
              top: `${tooltipData.position.y}px`,
            }}
          ></div>
        )}
      </div>

      <TargetTooltip
        className="z-50"
        areaId={tooltipData.area}
        visible={tooltipData.visible}
        position={tooltipData.position}
      />
    </div>
  );
};

export default Map;

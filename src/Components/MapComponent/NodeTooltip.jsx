import { useContext, useState, useEffect } from "react";
import { MainContext } from "../../hooks/useSimulationContext";
import {
  useFetchNodeAddresses,
  useFormatAndFetchURIData,
} from "../../hooks/useGetContract";
import nodeData from "./JsonData/node.json";

const NodeTooltip = ({ area, visible, position, radius }) => {
  if (!visible) return null;

  const { address, setAddresses } = useContext(MainContext);
  const [formattedData, setFormattedData] = useState([]);
  const { result: addressResult } = useFetchNodeAddresses();

  const decodeBase64Data = (dataObject) => {
    try {
      //   console.log("DataObject before decoding:", dataObject);

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
      console.log("Formatted Data:", formattedData);
    }
  }, [formattedData]);

  const mappedData = formattedData.map((data) => {
    return {
      address: data.ad,
      walletAddress: data.data.wallet_address,
      position: data.data.position,
      unitName: data.data.unit.name,
      location: {
        latitude: data.data.location.latitude,
        longitude: data.data.location.longitude,
      },
      encryption: data.data.communications.encryption,
    };
  });

  console.log("mappedData is", mappedData);

  const nodeDataMap = nodeData.map((nodes) => {
    return {
      name: nodes.name,
    };
  });
  console.log("nodeDataMap", nodeDataMap);

  if (nodeDataMap.name === mappedData.walletAddress) {
    return (
      <div
        className="absolute bg-[rgba(41, 139, 254)] backdrop-blur-[10px] border-t-8 border-[#298BFE] w-[17rem]"
        style={{ top: position.y, left: position.x }}
      >
        {mappedData.map((data, index) => (
          <div key={data.walletAddress} className="node-item">
            <div className="bg-[#1f426f] pb-2">
              <div className="text-[#298BFE] text-xl font-bold p-3">
                {data.unitName}
              </div>
            </div>
            <div>
              <div className="text-gray-300 p-3">
                <div>
                  <div className="text-sm font-bold">Address</div>
                  <div className="text-[10px] text-[#5a6b6d]">
                    {data.walletAddress}
                  </div>
                </div>
                <div className="mt-2">
                  <div className="text-sm font-bold">Position</div>
                  <div className="text-xs font-bold text-[#5a6b6d]">
                    Location: {data.position}
                  </div>
                  <div className="text-xs font-bold text-[#5a6b6d]">
                    Latitude: {data.location.latitude}
                  </div>
                  <div className="text-xs font-bold text-[#5a6b6d]">
                    Longitude: {data.location.longitude}
                  </div>
                </div>
              </div>
            </div>
          </div>
        ))}
      </div>
    );
  }
};

export default NodeTooltip;

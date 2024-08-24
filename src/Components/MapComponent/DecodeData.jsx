import { useContext, useState, useEffect } from 'react';
import { MainContext } from '../../hooks/useSimulationContext';
import { useFetchNodeAddresses, useFormatAndFetchURIData } from '../../hooks/useGetContract';



const DecodeData = () => {
    const { address, setAddresses } = useContext(MainContext);
    const { result: addressResult } = useFetchNodeAddresses();
    const [formattedData, setFormattedData] = useState([]);

    const decodeBase64Data = (dataObject) => {
        try {
            console.log("DataObject before decoding:", dataObject);

            if (!dataObject || typeof dataObject !== 'string') {
                throw new Error("Invalid dataObject or missing 'data' property");
            }

            const base64String = dataObject.split(',')[1]; // Extract Base64 part
            if (!base64String) {
                throw new Error("Failed to extract Base64 string");
            }

            const decodedString = atob(base64String); // Decode Base64 string
            const jsonData = JSON.parse(decodedString); // Parse JSON string
            return jsonData;
        } catch (error) {
            console.error('Error decoding and parsing JSON:', error);
            return null;
        }
    };


    useEffect(() => {
        if (addressResult) {
            setAddresses(addressResult);
        }
    }, [addressResult]);

    useEffect(() => {
        const fetchFormattedData = async () => {
            const results = await Promise.all(
                address.map(async (ad) => {
                    const data = await useFormatAndFetchURIData(ad);
                    console.log(`data is ${data}`);
                    // return { ad, data };
                    const decodedData = decodeBase64Data(data);
                    // console.log(`Decoded data for ${ad}:`, decodedData);
                    return { ad, data: decodedData || 'Decoding failed or no data' };
                    // return {ad , data}
                })
            );
            setFormattedData(results);
        };

        if (address.length > 0) {
            fetchFormattedData();
        }
    }, [address]);


    useEffect(() => {
        if (formattedData.length > 0) {
            console.log("Formatted Data:", formattedData);
        }
    }, [formattedData]);


}



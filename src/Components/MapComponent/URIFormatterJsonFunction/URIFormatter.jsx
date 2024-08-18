import { useContext } from 'react';
import { MainContext } from '../../hooks/useSimulationContext';
import { useFormatAndFetchURIData, useFetchNodeAddresses } from '../../hooks/useGetContract';



const JsonReaderFromUriFormatter = () => {
    
    const {setAddresses } = useContext(MainContext);
    const { result: addressResult } = useFetchNodeAddresses()

    useEffect(() => {
        if (addressResult) {
            // console.log("🚀 ~ MapComponent ~ addressResult:", addressResult);
            setAddresses(addressResult);

            addressResult.forEach(async (ad) => {
                // console.log("🚀 ~ addressResult.map ~ ar:", ad);
                const { data: URIformatterAddress } = await useFormatAndFetchURIData(ad);
                // console.log("🚀 ~ MapComponent ~ URIformatterAddress:", URIformatterAddress);
            });
        }

    }, [addressResult, setAddresses]);
}



export default JsonReaderFromUriFormatter;


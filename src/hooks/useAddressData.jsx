import {useState, useEffect} from 'react';

const useAddressData = () => {
    const [data, setData] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        // Simulate fetching data from an API
        const fetchData = async () => {
            try {
                // Simulating a delay for fetching data
                setTimeout(() => {
                    const fetchedData = [
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
                    ];
                    setData(fetchedData);
                    setLoading(false);
                }, 1000);
            } catch (err) {
                setError(err);
                setLoading(false);
            }
        };

        fetchData();
    }, []);

    return {data, loading, error};
};

export default useAddressData;
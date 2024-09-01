const EnhancedTooltip = ({active, payload, label}) => {
    if (active && payload && payload.length) {
        return (
            <div className="custom-tooltip" style={{
                backgroundColor: 'rgba(29,43,65,0.62)',
                padding: '15px',
                color: '#fff',
                backdropFilter: 'blur(5px)'
            }}>
                <h1 className="text-[#FF483D] text-2xl ">TARGET</h1>
                <h2 className="text-white ">Position</h2>
                <h4 className="text-[#4e5a6e]">{`Location: ${label}`}</h4>
                {/* <h4 className="text-[#4e5a6e]">Location: Eiffel Tower, Paris, France</h4> */}
                <h4 className="text-[#4e5a6e]">{`Latitude: ${payload[0].value}`}</h4>
                {/* <h4 className="text-[#4e5a6e]">Latitude: 48.8584N</h4> */}
                <h4 className="text-[#4e5a6e]">{`Longitude: ${payload[0].value}`}</h4>
                {/* <h4 className="text-[#4e5a6e]">Longitude: 2.2945E</h4> */}

            </div>
        );
    }
    return null;
};

export default EnhancedTooltip;

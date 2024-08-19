const NodeTooltip = ({ area, visible, position, radius }) => {
    if (!visible) return null;

    const nodeCard = {
        'nodeName': [
            'Node Number 1',
            'Node Number 2',
            'Node Number 3',
            'Node Number 4',
            'Node Number 5',
            'Node Number 6',
            'Node Number 7'
        ],
        'nodeAddress': [
            '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266',
            '0x70997970C51812dc3A010C7d01b50e0d17dc79C8',
            '0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC',
            '0x90F79bf6EB2c4f870365E785982E1f101E93b906',
            '0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65',
            '0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc',
            '0x976EA74026E726554dB657fA54763abd0C3a0aa9'
        ],
        'nodeLocation': [
            'sensor',
            'gateway',
            'sensor',
            'transmitter',
            'baseStation',
            'sensor',
            'baseStation'
        ],
        'nodeLatitude': [
            '38.907299',
            '37.774929',
            '51.507351',
            '35.689487',
            '40.416775',
            '-33.868820',
            '-15.779072'
        ],
        'nodeLongitude':[
            '-122.419418',
            '-0.127758',
            '139.691711',
            '-3.703790',
            '151.209295',
            '-47.929215',
            '-122.419418'
        ]
    };

    return (
        <div
            className="absolute bg-[rgba(41, 139, 254)] backdrop-blur-[10px] border-t-8 border-[#298BFE] w-[17rem]"
            style={{ top: position.y, left: position.x }}
        >
            <div className="bg-[#1f426f] pb-2">
                <div className="text-[#298BFE] text-4xl font-bold p-3">Node name</div>
            </div>
            <div>
                <div className="text-gray-300 p-3">
                    <div>
                        <div className="text-sm font-bold">Address</div>
                        <div className="text-xs text-[#5a6b6d]">0x13c857...a2297d2256</div>
                    </div>
                    <div className="mt-2">
                        <div className="text-sm font-bold">Position</div>
                        <div className="text-xs font-bold text-[#5a6b6d]">Location: Eiffel Tower, Paris, France</div>
                        <div className="text-xs font-bold text-[#5a6b6d]">Latitude: 48.8584° N</div>
                        <div className="text-xs font-bold text-[#5a6b6d]">Longitude: 2.2945° E</div>
                    </div>
                </div>

            </div>

        </div>
    );
};

export default NodeTooltip;

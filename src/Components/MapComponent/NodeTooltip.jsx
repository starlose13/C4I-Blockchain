
const NodeTooltip = ({ area, visible, position, radius }) => {
    if (!visible) return null;





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

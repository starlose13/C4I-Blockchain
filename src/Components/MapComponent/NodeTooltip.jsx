const NodeTooltip = ({ address,area, nodeLat,nodeLan,visible, position, radius }) => {
  if (!visible) return null;

 
  return (
    <div
      className="absolute bg-[rgba(41, 139, 254)] backdrop-blur-[10px] border-t-8 border-[#298BFE] w-[17rem]"
      style={{ top: position.y, left: position.x }}
    >
      {/* {mappedData.map((data, index) => ( */}
        {/* nodeDataMap.name === data.walletAddress && ( */}
          <div  className="node-item">
            <div className="bg-[#1f426f] pb-2">
              <div className="text-[#298BFE] text-xl font-bold p-3">
              </div>
            </div>
            <div>
              <div className="text-gray-300 p-3">
                <div>
                  <div className="text-sm font-bold">Address</div>
                  <div className="text-[10px] text-[#5a6b6d]">
                  {address}
                  </div>
                </div>
                <div className="mt-2">
                  <div className="text-sm font-bold">Position</div>
                  <div className="text-xs font-bold text-[#5a6b6d]">
                    Location: {area}
                  </div>
                  <div className="text-xs font-bold text-[#5a6b6d]">
                    Latitude:  {nodeLat}
                  </div>
                  <div className="text-xs font-bold text-[#5a6b6d]">
                    Longitude: {nodeLan}
                  </div>
                </div>
              </div>
            </div>
          </div>
        {/* ) */}
      {/* ))} */}
    </div>
  );
  



}

export default NodeTooltip;



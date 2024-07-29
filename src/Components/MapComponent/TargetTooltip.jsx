// import React from 'react';
// import areas from './areas.json';
//
//
//
// const TargetTooltip = ({ visible, position }) => {
//     if (!visible) return null;
//
//     const circleRadius = 30; // Radius of the indicator circle
//     const lineThickness = 6; // Thickness of the lines
//     const horizontalLineLength = 70; // Length of the horizontal line
//     const verticalLineLength = 50; // Length of the vertical line
//     const tooltipOffsetX = horizontalLineLength + 30; // Horizontal offset of the tooltip from the horizontal line
//     const tooltipOffsetY = verticalLineLength + 10; // Vertical offset of the tooltip from the horizontal line
//
//     // Style for the indicator circle
//     const indicatorStyle = {
//         position: 'absolute',
//         width: `${circleRadius * 2}px`,
//         height: `${circleRadius * 2}px`,
//         borderRadius: '50%',
//         border: `${lineThickness}px solid #dc2626`,
//         top: position.y - circleRadius + 4, // Center the circle on the cursor
//         left: position.x, // Center the circle on the cursor
//         backgroundColor: 'transparent', // Transparent background for the circle
//         display: 'flex',
//         alignItems: 'center',
//         justifyContent: 'center'
//     };
//
//     // Style for the horizontal line
//     const horizontalLineStyle = {
//         position: 'absolute',
//         width: `${horizontalLineLength}px`,
//         height: `${lineThickness}px`,
//         backgroundColor: '#dc2626',
//         top: position.y, // Center the line horizontally with the circle
//         left: position.x + circleRadius // Start from the right edge of the circle
//     };
//
//     // Style for the vertical line
//     const verticalLineStyle = {
//         position: 'absolute',
//         width: `${lineThickness}px`,
//         height: `${verticalLineLength}px`,
//         backgroundColor: '#dc2626',
//         top: position.y, // Start from the top of the horizontal line
//         left: position.x + circleRadius + horizontalLineLength // Position after the horizontal line
//     };
//
//     // Style for the tooltip
//     const tooltipStyle = {
//         position: 'absolute',
//         backgroundColor: '#1D2B419E', // Semi-transparent background
//         backdropFilter: 'blur(10px)', // Blur effect
//         padding: '1rem', // Padding inside the tooltip
//         borderTop: '8px solid red', // Border around the tooltip
//         width: '40rem', // Tooltip width
//         top: position.y + verticalLineLength, // Position below the vertical line
//         left: position.x // Position to the right of the horizontal line
//     };
//
//
//
//     return (
//         <div>
//             {/* Indicator circle with plus signs */}
//             <div style={indicatorStyle}>
//                 <div style={{
//                     position: 'relative',
//                     width: '100%',
//                     height: '100%',
//                     display: 'flex',
//                     alignItems: 'center',
//                     justifyContent: 'center'
//                 }}>
//                     <div style={{
//                         position: 'absolute',
//                         width: '100%',
//                         height: '8px',
//                         backgroundColor: 'red'
//                     }}></div>
//                     <div style={{
//                         position: 'absolute',
//                         height: '100%',
//                         width: '8px',
//                         backgroundColor: 'red'
//                     }}></div>
//                     <div style={{
//                         position: 'absolute',
//                         width: '50%',
//                         height: '8px',
//                         backgroundColor: 'red',
//                         zIndex: 1
//                     }}></div>
//                     <div style={{
//                         position: 'absolute',
//                         height: '50%',
//                         width: '8px',
//                         backgroundColor: 'red',
//                         zIndex: 1
//                     }}></div>
//                 </div>
//             </div>
//             {/* Horizontal connecting line */}
//             <div style={horizontalLineStyle}></div>
//             {/* Vertical connecting line */}
//             <div style={verticalLineStyle}></div>
//             {/* Tooltip content */}
//             <div style={tooltipStyle}>
//                 <div className="flex">
//                     <div className="flex py-2 m-3 text-red-500 text-4xl items-center font-bold px-4">TARGET</div>
//                     <div className="text-gray-300">
//                         <div className="mb-2">
//                             <div className="font-semibold">Address:</div>
//                             <div className="text-[#5a6b6d]">0x70997970C51812dc3A010C7d01b50e0d17dc79C8</div>
//                         </div>
//                         <div>
//                             <div className="font-semibold">Position:</div>
//                             <div className="text-[#5a6b6d]">Location: Station</div>
//                             <div className="text-[#5a6b6d]">Latitude: 0.5915915915915916</div>
//                             <div className="text-[#5a6b6d]">Longitude: 0.5915915915915916</div>
//                         </div>
//                     </div>
//                 </div>
//             </div>
//         </div>
//     );
// };
//
// export default TargetTooltip;


import React from 'react';
import dataArea from './areas.json';


const TargetTooltip = ({area, visible, position}) => {
    if (!visible) return null;


    const circleRadius = 30; // Radius of the indicator circle
    const lineThickness = 6; // Thickness of the lines
    const horizontalLineLength = 70; // Length of the horizontal line
    const verticalLineLength = 50; // Length of the vertical line
    const tooltipOffsetX = horizontalLineLength + 30; // Horizontal offset of the tooltip from the horizontal line
    const tooltipOffsetY = verticalLineLength + 10; // Vertical offset of the tooltip from the horizontal line

    // Style for the indicator circle
    const indicatorStyle = {
        position: 'absolute',
        width: `${circleRadius * 2}px`,
        height: `${circleRadius * 2}px`,
        borderRadius: '50%',
        border: `${lineThickness}px solid #dc2626`,
        top: position.y - circleRadius + 4, // Center the circle on the cursor
        left: position.x, // Center the circle on the cursor
        backgroundColor: 'transparent', // Transparent background for the circle
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center'
    };

    // Style for the horizontal line
    const horizontalLineStyle = {
        position: 'absolute',
        width: `${horizontalLineLength}px`,
        height: `${lineThickness}px`,
        backgroundColor: '#dc2626',
        top: position.y, // Center the line horizontally with the circle
        left: position.x + circleRadius // Start from the right edge of the circle
    };

    // Style for the vertical line
    const verticalLineStyle = {
        position: 'absolute',
        width: `${lineThickness}px`,
        height: `${verticalLineLength}px`,
        backgroundColor: '#dc2626',
        top: position.y, // Start from the top of the horizontal line
        left: position.x + circleRadius + horizontalLineLength // Position after the horizontal line
    };

    // Style for the tooltip
    const tooltipStyle = {
        position: 'absolute',
        backgroundColor: '#1D2B419E', // Semi-transparent background
        backdropFilter: 'blur(10px)', // Blur effect
        padding: '1rem', // Padding inside the tooltip
        borderTop: '8px solid red', // Border around the tooltip
        width: '40rem', // Tooltip width
        top: position.y + verticalLineLength, // Position below the vertical line
        left: position.x // Position to the right of the horizontal line
    };

    return (
        <div>
            {/* Indicator circle with plus signs */}
            <div style={indicatorStyle}>
                <div style={{
                    position: 'relative',
                    width: '100%',
                    height: '100%',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center'
                }}>
                    <div style={{
                        position: 'absolute',
                        width: '100%',
                        height: '8px',
                        backgroundColor: 'red'
                    }}></div>
                    <div style={{
                        position: 'absolute',
                        height: '100%',
                        width: '8px',
                        backgroundColor: 'red'
                    }}></div>
                    <div style={{
                        position: 'absolute',
                        width: '50%',
                        height: '8px',
                        backgroundColor: 'red',
                        zIndex: 1
                    }}></div>
                    <div style={{
                        position: 'absolute',
                        height: '50%',
                        width: '8px',
                        backgroundColor: 'red',
                        zIndex: 1
                    }}></div>
                </div>
            </div>
            {/* Horizontal connecting line */}
            <div style={horizontalLineStyle}></div>
            {/* Vertical connecting line */}
            <div style={verticalLineStyle}></div>
            {/* Tooltip content */}
            <div style={tooltipStyle}>
                <div className="flex">
                    <div
                        className="flex py-2 m-3 text-red-500 text-4xl items-center font-bold px-4">TARGET
                    </div>
                    <div className="text-gray-300">
                        <div className="mb-2">
                            <div className="font-semibold">Address: </div>
                            <div className="text-[#5a6b6d]">{dataArea[1].publicAddress}</div>
                        </div>
                            <div>
                                <div className="font-semibold">Position: </div>
                                <div className="text-[#5a6b6d]">Location: {dataArea[1].positionName}</div>
                                <div className="text-[#5a6b6d]">Latitude: {dataArea[1].latitude}</div>
                                <div className="text-[#5a6b6d]">Longitude: {dataArea[1].longitude}</div>
                            </div>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default TargetTooltip;

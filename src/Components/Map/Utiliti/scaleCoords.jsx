export const scaleCoords = (coords, imgWidth, imgHeight) => {
    return coords.map((coord, index) =>
        (
            index % 2 === 0 ? coord * imgWidth : coord * imgHeight
        )
    )
};
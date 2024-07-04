import ImageMapper from "react-image-mapper";

export const MapImageMapper = ({src, map, onAreaClick, width, height, imgWidth, imgHeight}) => {
    return (
        <ImageMapper
            src={src}
            map={map}
            onAreaClick={onAreaClick}
            width={width}
            height={height}
            imgWidth={imgWidth}
            imgHeight={imgHeight}
            alt="Map Image"
        />

    )
};
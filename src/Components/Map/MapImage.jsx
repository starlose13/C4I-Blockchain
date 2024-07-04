import {scaleCoords} from "./Utiliti/scaleCoords.jsx";
import {MapImageMapper} from "./MapImageMapper.jsx";

const MapImage = ({areas, onAreaClick}) => {
    const URL = "x.jpg";
    const width = 2100;
    const height = 1200;
    const imgWidth = 1665;
    const imgHeight = 957;


    const MAP = {
        name: 'MAP',
        areas: areas.map((area) => ({
            name: area.name,
            shape: area.shape,
            coords: scaleCoords(area.coords, imgWidth, imgHeight)
        }))
    };


    return (
        <div className="drop-shadow">
            <MapImageMapper
                src={URL}
                map={MAP}
                onAreaClick={onAreaClick}
                width={width}
                height={height}
                imgHeight={imgHeight}
                imgWidth={imgWidth}
            />
        </div>
    );
};


export default MapImage;
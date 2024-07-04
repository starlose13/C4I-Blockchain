import TooltipContent from "./TooltipContent.jsx";
import {tooltipStyles} from "./TooltipStyles.jsx";

const TooltipComponent = ({area, visible, position}) => {
    if (!isVisible) return null;

    return (
        <div style={{...tooltipStyles.container, left: position.x, top: position.y}}>
            <TooltipContent area={area}/>
        </div>
    )
};

export default TooltipComponent;
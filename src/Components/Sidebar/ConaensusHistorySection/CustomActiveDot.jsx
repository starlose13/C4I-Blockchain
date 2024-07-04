const renderActiveDot = (props) => {
    const {cx, cy} = props;
    return (
        <svg>
            <circle cx={cx} cy={cy} r={10} stroke="#ea4f50" strokeWidth={4} fill="transparent"/>
            <circle cx={cx} cy={cy} r={4} stroke="none" fill="#ea4f50"/>
        </svg>
    );
};

export default renderActiveDot;

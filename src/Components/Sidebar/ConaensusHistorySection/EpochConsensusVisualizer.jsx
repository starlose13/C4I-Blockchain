import Stack from '@mui/material/Stack';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip } from 'recharts';
import { consensusData } from './ConsensusData.jsx';
import EnhancedTooltip from './EnhancedTooltip.jsx';
import renderActiveDot from './CustomActiveDot.jsx';

const EpochConsensusVisualizer = () => {
    return (
        <div className="w-[40rem] p-4">
            <h1 className="text-white font-bold">Consensus History</h1>
            <h3 className="text-white">#Node</h3>
            <div>
                <Stack direction="row">
                    <LineChart width={630} height={300} data={consensusData}>
                        <CartesianGrid stroke="#565a61" strokeDasharray="4 4" />
                        <XAxis dataKey="name" stroke="#cccccc" />
                        <YAxis stroke="#cccccc" />
                        <Tooltip
                            content={<EnhancedTooltip />}
                            cursor={{ stroke: '#0000', strokeWidth: 1 }}
                        />
                        <Line
                            type="linear"
                            dataKey="uv"
                            stroke="aqua"
                            activeDot={renderActiveDot}
                        />
                    </LineChart>
                </Stack>
            </div>
            <h3 className="flex text-white justify-end">#Epoch</h3>
        </div>
    );
};

export default EpochConsensusVisualizer;

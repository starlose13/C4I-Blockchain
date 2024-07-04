import Simulation from "./Sidebar/SimulationSection/Simulation.jsx";
import TransactionTable from "./Sidebar/LatestTransactionSection/TransactionTable.jsx";
import EpochConsensusVisualizer
    from "./Sidebar/ConaensusHistorySection/EpochConsensusVisualizer.jsx";

const Sidebar = () => {
    return (
        <div className="ml-4">
            <Simulation/>
            <TransactionTable/>
            <EpochConsensusVisualizer/>
        </div>
    )
}
export default Sidebar
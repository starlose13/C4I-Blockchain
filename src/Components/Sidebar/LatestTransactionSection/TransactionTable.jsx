const Icon = ({children}) => (
    <div className="text-xl mr-2">
        {children}
    </div>
)

const InfoBlock = ({title, value, icon, valueClass = ''}) => (
    <div className="flex items-center text-white mr-4">
        <Icon>{icon}</Icon>
        <div>
            <div className="text-sm text-gray-400">{title}</div>
            <div className={`text-2xl font-bold flex items-center ${valueClass}`}>
                {value}
            </div>
        </div>
    </div>
)

const TransactionTable = () => {
    return (
        <div className="w-[40rem] p-4">
            <h4 className="text-white mb-4 font-bold">Latest Transactions</h4>
            <div className="grid grid-cols-3 mb-4 items-center p-4 rounded-lg ">
                <InfoBlock
                    title="# Epoch"
                    value="146"
                    icon={
                        <svg width="47" height="48" viewBox="0 0 47 48" fill="none"
                             xmlns="http://www.w3.org/2000/svg">
                            <rect width="47" height="48" rx="12" fill="white" fillOpacity="0.05"/>
                            <path
                                d="M23.2812 39L28.054 9.90909H33.1676L28.3949 39H23.2812ZM10.3125 32.0682L11.179 26.9545H34.2472L33.3807 32.0682H10.3125ZM13.054 39L17.8267 9.90909H22.9403L18.1676 39H13.054ZM11.9744 21.9545L12.8409 16.8409H35.9091L35.0426 21.9545H11.9744Z"
                                fill="#F7F7F7"/>
                        </svg>

                    }
                />
                <InfoBlock
                    title="# Agents"
                    value={<>253,425 <span className="text-green-500 ml-1 text-xs">▲</span></>}
                    icon={
                        <svg width="48" height="48" viewBox="0 0 48 48" fill="none"
                             xmlns="http://www.w3.org/2000/svg">
                            <rect width="48" height="48" rx="12" fill="white" fillOpacity="0.05"/>
                            <path
                                d="M12.3333 40.6666C11.4167 40.6666 10.6322 40.3405 9.98 39.6883C9.32778 39.0361 9.00111 38.2511 9 37.3333V30.9999C9 30.6111 9.06944 30.2222 9.20833 29.8333C9.34722 29.4444 9.55556 29.0972 9.83333 28.7916L12.4167 25.8749C12.7222 25.5138 13.1183 25.3266 13.605 25.3133C14.0917 25.2999 14.5011 25.4594 14.8333 25.7916C15.1389 26.0972 15.3056 26.4722 15.3333 26.9166C15.3611 27.3611 15.2222 27.7499 14.9167 28.0833L12.625 30.6666H35.375L33.1667 28.1666C32.8611 27.8333 32.7222 27.4444 32.75 26.9999C32.7778 26.5555 32.9444 26.1805 33.25 25.8749C33.5833 25.5416 33.9933 25.3816 34.48 25.3949C34.9667 25.4083 35.3622 25.5961 35.6667 25.9583L38.1667 28.7916C38.4444 29.0972 38.6528 29.4444 38.7917 29.8333C38.9306 30.2222 39 30.6111 39 30.9999V37.3333C39 38.2499 38.6739 39.0349 38.0217 39.6883C37.3694 40.3416 36.5844 40.6677 35.6667 40.6666H12.3333ZM21.6667 27.9999L15.875 22.1249C15.2361 21.4861 14.9167 20.6944 14.9167 19.7499C14.9167 18.8055 15.2361 18.0138 15.875 17.3749L24.0417 9.20827C24.6806 8.56938 25.4722 8.24994 26.4167 8.24994C27.3611 8.24994 28.1528 8.56938 28.7917 9.20827L34.6667 14.9999C35.3056 15.6388 35.6322 16.4233 35.6467 17.3533C35.6611 18.2833 35.3483 19.0683 34.7083 19.7083L26.375 28.0416C25.7361 28.6805 24.9517 28.9933 24.0217 28.9799C23.0917 28.9666 22.3067 28.6399 21.6667 27.9999ZM32.3333 17.3333L26.4167 11.4999L18.1667 19.7499L24.0833 25.5833L32.3333 17.3333Z"
                                fill="white"/>
                        </svg>

                    }
                />
                <InfoBlock
                    title="Epoch Ends in:"
                    value="11:43:16"
                    icon={
                        <svg width="49" height="48" viewBox="0 0 49 48" fill="none"
                             xmlns="http://www.w3.org/2000/svg">
                            <rect x="0.5" width="48" height="48" rx="12" fill="white"
                                  fillOpacity="0.05"/>
                            <path
                                d="M19.5 8.99984V5.6665H29.5V8.99984H19.5ZM22.8333 27.3332H26.1667V17.3332H22.8333V27.3332ZM24.5 40.6665C22.4444 40.6665 20.5067 40.2709 18.6867 39.4798C16.8667 38.6887 15.2767 37.6121 13.9167 36.2498C12.5567 34.8876 11.4806 33.2971 10.6883 31.4782C9.89611 29.6593 9.5 27.7221 9.5 25.6665C9.5 23.6109 9.89611 21.6732 10.6883 19.8532C11.4806 18.0332 12.5567 16.4432 13.9167 15.0832C15.2767 13.7232 16.8672 12.6471 18.6883 11.8548C20.5094 11.0626 22.4467 10.6665 24.5 10.6665C26.2222 10.6665 27.875 10.9443 29.4583 11.4998C31.0417 12.0554 32.5278 12.8609 33.9167 13.9165L36.25 11.5832L38.5833 13.9165L36.25 16.2498C37.3056 17.6387 38.1111 19.1248 38.6667 20.7082C39.2222 22.2915 39.5 23.9443 39.5 25.6665C39.5 27.7221 39.1039 29.6598 38.3117 31.4798C37.5194 33.2998 36.4433 34.8898 35.0833 36.2498C33.7233 37.6098 32.1328 38.6865 30.3117 39.4798C28.4906 40.2732 26.5533 40.6687 24.5 40.6665Z"
                                fill="white"/>
                        </svg>
                    }
                />
            </div>
            <div className="overflow-x-auto">
                <table className="min-w-full">
                    <thead className="border-t">
                    <tr className="bg-[#32435c] text-[#5d7497]">
                        <th className="text-sm py-2 px-4 text-center">Block</th>
                        <th className="text-sm py-2 px-4 text-center">Epoch</th>
                        <th className="text-sm py-2 px-4 text-center">Node Address</th>
                        <th className="text-sm py-2 px-4 text-center">Target</th>
                        <th className="text-sm py-2 px-4 text-center">Txn Hash</th>
                    </tr>
                    </thead>
                    <tbody className="border-separate" style={{borderSpacing: '20px'}}>
                    {[...Array(6)].map((_, idx) => (
                        <tr key={idx} className="bg-[#0a192f] text-[#566d8f]">
                            <td className="py-2 px-4 text-center border-y-8 border-[#030712]">
                                <div className="text-xs m-1">4587624</div>
                            </td>
                            <td className="py-2 px-4 text-center border-y-8 border-l-8 border-[#030712]">
                                <div className="text-xs m-1">12</div>
                            </td>
                            <td className="py-2 px-4 text-center border-y-8 border-l-8 border-[#030712]">
                                <div className="text-xs m-1">Name</div>
                            </td>
                            <td className="py-2 px-4 text-center border-y-8 border-l-8 border-[#030712]">
                                <div className="text-xs m-1">Name</div>
                            </td>
                            <td className="py-2 px-4 text-center border-y-8 border-l-8 border-[#030712]">
                                <div className="text-xs m-1">0x13c85...22256</div>
                            </td>
                        </tr>
                    ))}
                    </tbody>
                </table>
            </div>
        </div>
    );
};

export default TransactionTable

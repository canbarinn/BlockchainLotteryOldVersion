// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IFinalLottery {
    event AmountOfPrize(string prizeName, uint prize);
    event WinningTicket(uint ticketNo, uint amount);
    event Winner(bool isWin);
    event SinglePriceVal(uint totalPrice);

    enum TicketTier {
        Full,
        Half,
        Quarter,
        Invalid
    }
    struct Ticket {
        address owner;
        uint ticketNo;
        uint lotteryNo;
        bytes32 ticketHash;
        uint8 status;
        bool active;
        TicketTier ticketTier;
    }

    struct LotteryInfo {
        uint lotteryNo;
        uint startTimestamp;
        uint[] winningTickets;
        uint[] ticketNosInLottery;
    }

    function lotteryNoCalculator() external view returns (uint);

    function depositEther() external payable;

    function transferAmount(uint lottery_no, uint prize) external;

    function withdrawEther(uint amount) external payable;

    function buyTicket(bytes32 hash_rnd_number, int tier) external;

    function revealRndNumber(uint ticket_no, uint random_number) external;

    function getamount(TicketTier tier) external pure returns (uint);

    function collectTicketRefund(uint ticket_no) external;

    function getIthOwnedTicketNo(
        uint i,
        uint lottery_no
    ) external returns (uint, uint8);

    function getLastOwnedTicketNo(
        uint lottery_no
    ) external view returns (uint, uint8);

    function getTicketInfo(uint ticket_number) external;

    function getRandomNumber() external view returns (uint);

    function pickWinner(uint lottery_no) external;

    function calculateSinglePriceValue(
        uint thPrice,
        uint lottery_no
    ) external returns (uint);

    function calculateTotalPriceValue(uint lottery_no) external returns (uint);

    function getIthWinningTicket(
        uint i,
        uint lottery_no
    ) external returns (uint ticket_no, uint amount);

    function checkIfTicketWon(
        uint lottery_no,
        uint ticket_no
    ) external returns (uint);

    function findTicketInfosFromNo(
        uint ticket_no
    ) external returns (uint, uint);

    function collectTicketPrize(
        uint lottery_no,
        uint ticket_no
    ) external returns (uint);
}

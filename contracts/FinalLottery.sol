// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract FinalLottery {
    uint ticketNoCounter;
    uint lotteryDeploymentTime = block.timestamp;

    constructor() {
        lotteryDeploymentTime = block.timestamp;
    }

    enum TicketTier {
        Full,
        Half,
        Quarter,
        Invalid
    }

    mapping(address => mapping(uint => Ticket[])) tickets; //address => lotteryNo => Ticket
    mapping(address => uint256) public balance;
    mapping(uint => LotteryInfo) lotteryInfos; //lotteryNo => LotteryInfo

    struct Ticket {
        uint ticketNo;
        uint lotteryNo;
        bytes32 ticketHash;
        uint ticketTimestamp;
        uint8 status;
        bool active;
        TicketTier ticketTier; //0 = full ticket, 1 = half ticket, 2 = quarter ticket
    }

    struct LotteryInfo {
        uint lotteryNo;
        uint startTimestamp;
        uint[] winningTickets; // safes index of the three winning tickets //0 = first price, 1 = second price, 2 = third price
        uint[] ticketNosInLottery; //
        uint lotteryBalance;
    }

    event TicketInfo(
        uint ticketNo,
        uint lotteryNo,
        bytes32 ticketHash,
        uint ticketTimestamp,
        uint8 status,
        bool active,
        TicketTier ticketTier
    );

    event AmountOfPrize(string prizeName, uint prize);

    function lotteryNoCalculator() public returns (uint) {
        uint currentTime = block.timestamp;
        uint timePassed = currentTime - lotteryDeploymentTime;
        uint lotteryNo = (timePassed / (60 * 60 * 24 * 7)) + 1;
        return lotteryNo;
    }

    function depositEther() public payable {
        // amountu cikar
        balance[msg.sender] += msg.value;

        // console.log(msg.value);
        // console.log(balance[msg.sender]);
    }

    function withdrawEther(uint amount) public payable {
        require(balance[msg.sender] >= amount, "insufficient balance");
        balance[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function buyTicket(bytes32 hash_rnd_number, int tier) public {
        uint lotteryNo = lotteryNoCalculator();
        TicketTier ticketTier;
        require(tier == 1 || tier == 2 || tier == 3, "Wrong Input");
        ticketNoCounter += 1;
        if (tier == 1) {
            ticketTier = TicketTier.Full;
        } else if (tier == 2) {
            ticketTier = TicketTier.Half;
        } else if (tier == 3) {
            ticketTier = TicketTier.Quarter;
        }

        tickets[msg.sender][lotteryNo].push(
            Ticket(
                ticketNoCounter,
                lotteryNo,
                hash_rnd_number,
                block.timestamp,
                0,
                true,
                ticketTier
            )
        );
        lotteryInfos[lotteryNo].ticketNosInLottery.push(ticketNoCounter);
        lotteryInfos[lotteryNo].lotteryBalance += getamount(ticketTier);
    }

    function getamount(TicketTier tier) public pure returns (uint) {
        uint amount;
        if (tier == TicketTier.Full) {
            amount = 8;
        } else if (tier == TicketTier.Half) {
            amount = 4;
        } else if (tier == TicketTier.Full) {
            amount = 2;
        }
        return amount;
    }

    function collectTicketRefund(uint ticket_no) public {
        uint lottery_no;
        uint ticket_index;

        (lottery_no, ticket_index) = findTicketInfosFromNo(ticket_no);
        TicketTier tier = tickets[msg.sender][lottery_no][ticket_index]
            .ticketTier;
        uint amount = getamount(tier);
        balance[msg.sender] += amount;
        lotteryInfos[lottery_no].lotteryBalance -= amount;
        tickets[msg.sender][lottery_no][ticket_index].active = false;
    }

    function getIthOwnedTicketNo(
        uint i,
        uint lottery_no
    ) public view returns (uint, uint8 status) {
        Ticket memory targetTicket;
        targetTicket = tickets[msg.sender][lottery_no][i];
        uint ticketNo = targetTicket.ticketNo;
        uint8 ticketStatus = targetTicket.status;
        return (ticketNo, ticketStatus);
    }

    function findTicketInfosFromNo(uint ticket_no) public returns (uint, uint) {
        uint lotteryNoCounter = lotteryNoCalculator();
        for (
            uint lottery_no = 0;
            lottery_no < lotteryNoCounter + 1;
            lottery_no++
        ) {
            for (
                uint index = 0;
                index < tickets[msg.sender][lottery_no].length;
                index++
            ) {
                if (
                    tickets[msg.sender][lottery_no][index].ticketNo == ticket_no
                ) {
                    return (lottery_no, index);
                }
            }
        }
    }

    function getLastOwnedTicketNo(
        uint lottery_no
    ) public view returns (uint, uint8) {
        uint lastIndex = tickets[msg.sender][lottery_no].length - 1;
        return (
            tickets[msg.sender][lottery_no][lastIndex].ticketNo,
            tickets[msg.sender][lottery_no][lastIndex].status
        );
    }

    function getTicketInfo(uint ticket_number) public {
        (uint lottery_no, uint index) = findTicketInfosFromNo(ticket_number);

        emit TicketInfo(
            tickets[msg.sender][lottery_no][index].ticketNo,
            tickets[msg.sender][lottery_no][index].lotteryNo,
            tickets[msg.sender][lottery_no][index].ticketHash,
            tickets[msg.sender][lottery_no][index].ticketTimestamp,
            tickets[msg.sender][lottery_no][index].status,
            tickets[msg.sender][lottery_no][index].active,
            tickets[msg.sender][lottery_no][index].ticketTier
        );
    }

    function getRandomNumber() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp)));
    }

    function pickWinner(uint lottery_no) private {
        if (lotteryInfos[lottery_no].ticketNosInLottery.length <= 3) {
            revert("not enough tickets");
            // make the tickets refundable here
        }
        uint numberofTickets = lotteryInfos[lottery_no]
            .ticketNosInLottery
            .length;
        uint index1 = getRandomNumber() %
            lotteryInfos[lottery_no].ticketNosInLottery.length;
        uint index2 = getRandomNumber() %
            lotteryInfos[lottery_no].ticketNosInLottery.length;
        uint index3 = getRandomNumber() %
            lotteryInfos[lottery_no].ticketNosInLottery.length;

        while ((index1 == index2) || (index2 == index3) || (index1 == index3)) {
            if (index1 == index2) {
                if (index1 != numberofTickets - 1) {
                    index1 = index2 + 1;
                } else {
                    index1 = 0;
                }
            } else if (index2 == index3) {
                if (index2 != numberofTickets - 1) {
                    index2 = index3 + 1;
                } else {
                    index2 = 0;
                }
            } else if (index1 == index3) {
                if (index1 != numberofTickets - 1) {
                    index1 = index3 + 1;
                } else {
                    index1 = 0;
                }
            }

            lotteryInfos[lottery_no].winningTickets.push(index1);
            lotteryInfos[lottery_no].winningTickets.push(index2);
            lotteryInfos[lottery_no].winningTickets.push(index3);
        }
    }

    function getIthWinningTicket(
        uint i,
        uint lottery_no
    ) public returns (uint ticket_no, uint amount) {
        uint ticket_index = lotteryInfos[lottery_no].winningTickets[i];
        ticket_no = lotteryInfos[lottery_no].ticketNosInLottery[ticket_index];

        (, ticket_index) = findTicketInfosFromNo(ticket_no);

        TicketTier tier = tickets[msg.sender][lottery_no][ticket_index]
            .ticketTier;

        amount = getamount(tier);

        return (ticket_no, amount);
    }

    function checkIfTicketWon(
        uint lottery_no,
        uint ticket_no
    ) public returns (uint) {
        if (!(lotteryInfos[lottery_no].winningTickets.length == 3)) {
            pickWinner(lottery_no);
        }
        uint prize;
        string memory prizeName;

        uint firstPrizeWinnerTicketNo = lotteryInfos[lottery_no]
            .ticketNosInLottery[lotteryInfos[lottery_no].winningTickets[0]];
        uint secondPrizeWinnerTicketNo = lotteryInfos[lottery_no]
            .ticketNosInLottery[lotteryInfos[lottery_no].winningTickets[1]];
        uint thirdPrizeWinnerTicketNo = lotteryInfos[lottery_no]
            .ticketNosInLottery[lotteryInfos[lottery_no].winningTickets[2]];

        (, uint index) = findTicketInfosFromNo(ticket_no);
        if (ticket_no == firstPrizeWinnerTicketNo) {
            if (
                tickets[msg.sender][lottery_no][index].ticketTier ==
                TicketTier.Full
            ) {
                prize = lotteryInfos[lottery_no].lotteryBalance / 2;
                prizeName = "Full First";
            } else if (
                tickets[msg.sender][lottery_no][index].ticketTier ==
                TicketTier.Half
            ) {
                prize = lotteryInfos[lottery_no].lotteryBalance / 4;
                prizeName = "Half First";
            } else if (
                tickets[msg.sender][lottery_no][index].ticketTier ==
                TicketTier.Quarter
            ) {
                prize = lotteryInfos[lottery_no].lotteryBalance / 8;
                prizeName = "Quarter First";
            } else {
                revert("Invalid operation.");
            }
        } else if (ticket_no == secondPrizeWinnerTicketNo) {
            if (
                tickets[msg.sender][lottery_no][index].ticketTier ==
                TicketTier.Full
            ) {
                prizeName = "Full Second";
                prize = lotteryInfos[lottery_no].lotteryBalance / 4;
            } else if (
                tickets[msg.sender][lottery_no][index].ticketTier ==
                TicketTier.Half
            ) {
                prizeName = "Half Second";
                prize = lotteryInfos[lottery_no].lotteryBalance / 8;
            } else if (
                tickets[msg.sender][lottery_no][index].ticketTier ==
                TicketTier.Quarter
            ) {
                prizeName = "Quarter Second";
                prize = lotteryInfos[lottery_no].lotteryBalance / 16;
            } else {
                revert("Invalid operation.");
            }
        } else if (ticket_no == thirdPrizeWinnerTicketNo) {
            if (
                tickets[msg.sender][lottery_no][index].ticketTier ==
                TicketTier.Full
            ) {
                prizeName = "Full Third";
                prize = lotteryInfos[lottery_no].lotteryBalance / 8;
            } else if (
                tickets[msg.sender][lottery_no][index].ticketTier ==
                TicketTier.Half
            ) {
                prizeName = "Half Third";
                prize = lotteryInfos[lottery_no].lotteryBalance / 16;
            } else if (
                tickets[msg.sender][lottery_no][index].ticketTier ==
                TicketTier.Quarter
            ) {
                prizeName = "Quarter Third";
                prize = lotteryInfos[lottery_no].lotteryBalance / 32;
            } else {
                revert("Invalid operation.");
            }
        } else {
            prize = 0;
        }
        emit AmountOfPrize(prizeName, prize);
        return prize;
    }

    function getTotalLotteryMoneyCollected(
        uint lottery_no
    ) public view returns (uint amount) {
        return lotteryInfos[lottery_no].lotteryBalance;
    }
}

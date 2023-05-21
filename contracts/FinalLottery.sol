// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract FinalLottery {
    uint ticketNoCounter;
    uint lotteryDeploymentTime = block.timestamp;
    uint lotteryBalance;

    constructor() {
        lotteryDeploymentTime = block.timestamp;
    }

    enum TicketTier {
        Full,
        Half,
        Quarter,
        Invalid
    }

    mapping(address => uint[]) public ticketNosArray; 
    mapping(address => uint256) public balance;
    mapping(uint => LotteryInfo) public lotteryInfos; 
    mapping(uint => uint) public moneyCollectedForEachLottery;
    mapping(uint => uint) public totalPrizeMoney;
    mapping(uint => Ticket) ticketsFromOutside;

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

    function findLotteryNoFromTicketNo(uint ticket_no) public returns (uint) {
        uint lastLotteryNo = lotteryNoCalculator();
        uint searchLotteryNo;
        for (uint i = 1; i < lastLotteryNo; i++) {
            for (
                uint j = 0;
                j < lotteryInfos[i].ticketNosInLottery.length;
                j++
            ) {
                if (ticket_no == lotteryInfos[i].ticketNosInLottery[j]) {
                    searchLotteryNo = i;
                }
            }
        }
        return searchLotteryNo;
    }

    event TicketInfo(
        uint ticketNo,
        uint lotteryNo,
        bytes32 ticketHash,
        uint8 status,
        bool active,
        TicketTier ticketTier
    );

    event AmountOfPrize(string prizeName, uint prize);
    event WinningTicket(uint ticketNo, uint amount);
    event Winner(bool isWin);
    event SinglePriceVal(uint totalPrice);

    function lotteryNoCalculator() public view returns (uint) {
        uint currentTime = block.timestamp;
        uint timePassed = currentTime - lotteryDeploymentTime;
        uint lotteryNo = (timePassed / (60 * 60 * 24 * 7)) + 1;
        return lotteryNo;
    }

    function depositEther() public payable {
        balance[msg.sender] += msg.value;
    }

    function transferAmount(uint lottery_no, uint prize) private {
        require(
            moneyCollectedForEachLottery[lottery_no] >= prize,
            "Lottery is invalid, because there is not enough money in the Lottery for the prizes"
        );
        totalPrizeMoney[lottery_no] += prize;
        uint transferAmnt = moneyCollectedForEachLottery[lottery_no] - prize;
        moneyCollectedForEachLottery[lottery_no + 1] += transferAmnt;
    }

    function withdrawEther(uint amount) public payable {
        require(balance[msg.sender] >= amount, "insufficient balance");
        balance[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function buyTicket(bytes32 hash_rnd_number, int tier) public {
        ticketNoCounter += 1;
        uint lottery_no = lotteryNoCalculator();
        TicketTier ticketTier;

        if (tier == 3) {
            require(
                balance[msg.sender] > 2 * 10,
                "insufficient balance for quarter ticket"
            );
            ticketTier = TicketTier.Quarter;
        } else if (tier == 2) {
            require(
                balance[msg.sender] > 4 * 10,
                "insufficient balance for half ticket"
            );
            ticketTier = TicketTier.Half;
        } else if (tier == 1) {
            require(
                balance[msg.sender] > 8 * 10,
                "insufficient balance for full ticket"
            );
            ticketTier = TicketTier.Full;
        }

        if (lottery_no >= 3) {
            if (!(lotteryInfos[lottery_no - 2].winningTickets.length == 3)) {
                pickWinner(lottery_no - 2);
                totalPrizeMoney[lottery_no - 2] = calculateTotalPriceValue(
                    lottery_no - 2
                );
                transferAmount(lottery_no - 2, totalPrizeMoney[lottery_no - 2]);
            }
        }

        ticketsFromOutside[ticketNoCounter].owner = msg.sender;
        ticketsFromOutside[ticketNoCounter].ticketNo = ticketNoCounter;
        ticketsFromOutside[ticketNoCounter].lotteryNo = lottery_no;
        ticketsFromOutside[ticketNoCounter].ticketHash = hash_rnd_number;
        ticketsFromOutside[ticketNoCounter].status = 0;
        ticketsFromOutside[ticketNoCounter].active = true;
        ticketsFromOutside[ticketNoCounter].ticketTier = ticketTier;

        ticketNosArray[msg.sender].push(ticketNoCounter);
        balance[msg.sender] -= getamount(ticketTier);
        lotteryBalance += getamount(ticketTier);
        lotteryInfos[lottery_no].ticketNosInLottery.push(ticketNoCounter);
        moneyCollectedForEachLottery[lottery_no] += getamount(ticketTier);
    }

    function revealRndNumber(uint ticket_no, uint random_number) public {
        require(
            ticket_no <= ticketNoCounter,
            "There is no ticket with this number in the system"
        );
        require(
            ticketsFromOutside[ticket_no].owner == msg.sender,
            "You are not the owner of this ticket"
        );
        require(
            ticketsFromOutside[ticket_no].lotteryNo ==
                (lotteryNoCalculator() - 1),
            "incorrect time to reveal"
        );
        require(
            ticketsFromOutside[ticket_no].status == 0,
            "Sorry, you have already revealed"
        );
        bytes32 hash = keccak256(abi.encodePacked(msg.sender, random_number));
        if (hash == ticketsFromOutside[ticket_no].ticketHash) {
            ticketsFromOutside[ticket_no].status = 1;
        } else {
            revert("Incorrect number!");
        }
    }

    function getamount(TicketTier tier) public pure returns (uint) {
        uint amount;
        if (tier == TicketTier.Full) {
            amount = 8 * (10);
        } else if (tier == TicketTier.Half) {
            amount = 4 * (10);
        } else if (tier == TicketTier.Full) {
            amount = 2 * (10);
        } else {
            amount = 0;
        }
        return amount;
    }

    function collectTicketRefund(uint ticket_no) public {
        require(
            ticket_no <= ticketNoCounter,
            "There is no ticket with this number in the system"
        );
        require(
            ticketsFromOutside[ticket_no].owner == msg.sender,
            "You are not the owner of this ticket"
        );
        require(
            ticketsFromOutside[ticket_no].lotteryNo == (lotteryNoCalculator()),
            "You cannot refund anymore"
        );
        uint lottery_no = ticketsFromOutside[ticket_no].lotteryNo;
        TicketTier tier = ticketsFromOutside[ticket_no].ticketTier;
        uint amount = getamount(tier);
        balance[msg.sender] += amount;
        moneyCollectedForEachLottery[lottery_no] -= amount;
        lotteryBalance -= amount;
        ticketsFromOutside[ticket_no].active = false;
    }

    function getIthOwnedTicketNo(
        uint i,
        uint lottery_no
    ) public view returns (uint, uint8) {
        require(
            lottery_no <= (lotteryNoCalculator()),
            "Lottery has not started yet"
        );
        require(
            ticketNosArray[msg.sender].length >= i,
            "You don`t have that many tickets"
        );

        for(uint k=0 ; k<ticketNosArray[msg.sender].length;k++) {
            if(ticketsFromOutside[ticketNosArray[msg.sender][k]].lotteryNo == lottery_no) {
                return (ticketsFromOutside[ticketNosArray[msg.sender][k+i-1]].ticketNo,ticketsFromOutside[ticketNosArray[msg.sender][k+i-1]].status );
            }
            else {
                continue;
            }
        
    }
    }

    function getLastOwnedTicketNo(
        uint lottery_no
    ) public view returns (uint, uint8) {
        require(
            ticketNosArray[msg.sender].length > 0,
            "You don`t have any tickets"
        );
        uint lastOwnedTicketNo;

        for (uint i = 0; i < ticketNosArray[msg.sender].length; i++) {
            if (
                ticketsFromOutside[ticketNosArray[msg.sender][i]].lotteryNo <=
                lottery_no
            ) {
                continue;
            } else {
                lastOwnedTicketNo = ticketNosArray[msg.sender][i - 1];
            }
            return (
                lastOwnedTicketNo,
                ticketsFromOutside[lastOwnedTicketNo].status
            );
        }
    }


    function getRandomNumber() internal view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp)));
    }     

    function pickWinner(uint lottery_no) private {
        if (lotteryInfos[lottery_no].ticketNosInLottery.length < 3) {
            revert(
                "There is not enough ticket for picking winners, lottery is cancelled!"
            );
            // TODO: make the tickets refundable here
        }

        uint numberofTickets = lotteryInfos[lottery_no]
            .ticketNosInLottery
            .length - 1;
        uint index1 = uint(keccak256(abi.encodePacked(block.timestamp))) %
            (numberofTickets);

        uint index2 = uint(keccak256(abi.encodePacked(block.timestamp + 1))) %
            (numberofTickets);
        uint index3 = uint(keccak256(abi.encodePacked(block.timestamp + 2))) %
            (numberofTickets);

        lotteryInfos[lottery_no].winningTickets.push(index1);
        lotteryInfos[lottery_no].winningTickets.push(index2);
        lotteryInfos[lottery_no].winningTickets.push(index3);

        totalPrizeMoney[lottery_no] += calculateTotalPriceValue(lottery_no);
    }

    /**
    This Function calculates the value of a specific winning tickets, used in calculateTotalPriceValue() and checkIfTiketWon
     */
    function calculateSinglePriceValue(
        uint thPrice,
        uint lottery_no
    ) private returns (uint) {
        // TODO: This can be private
        require(
            thPrice == 1 || thPrice == 2 || thPrice == 3,
            "Invalid price type!"
        );
        require(lottery_no <= lotteryNoCalculator(), "Invalid lottery number!");
        uint prize;

        uint winnerTicketNo = lotteryInfos[lottery_no].ticketNosInLottery[
            lotteryInfos[lottery_no].winningTickets[thPrice - 1]
        ];
        if (thPrice == 1) {
            if (
                ticketsFromOutside[winnerTicketNo].ticketTier == TicketTier.Full
            ) {
                prize = moneyCollectedForEachLottery[lottery_no] / 2;
            } else if (
                ticketsFromOutside[winnerTicketNo].ticketTier == TicketTier.Half
            ) {
                prize = moneyCollectedForEachLottery[lottery_no] / 4;
            } else if (
                ticketsFromOutside[winnerTicketNo].ticketTier ==
                TicketTier.Quarter
            ) {
                prize = moneyCollectedForEachLottery[lottery_no] / 8;
            }
        } else if (thPrice == 2) {
            if (
                ticketsFromOutside[winnerTicketNo].ticketTier == TicketTier.Full
            ) {
                prize = moneyCollectedForEachLottery[lottery_no] / 4;
            } else if (
                ticketsFromOutside[winnerTicketNo].ticketTier == TicketTier.Half
            ) {
                prize = moneyCollectedForEachLottery[lottery_no] / 8;
            } else if (
                ticketsFromOutside[winnerTicketNo].ticketTier ==
                TicketTier.Quarter
            ) {
                prize = moneyCollectedForEachLottery[lottery_no] / 16;
            }
        } else if (thPrice == 3) {
            if (
                ticketsFromOutside[winnerTicketNo].ticketTier == TicketTier.Full
            ) {
                prize = moneyCollectedForEachLottery[lottery_no] / 8;
            } else if (
                ticketsFromOutside[winnerTicketNo].ticketTier == TicketTier.Half
            ) {
                prize = moneyCollectedForEachLottery[lottery_no] / 16;
            } else if (
                ticketsFromOutside[winnerTicketNo].ticketTier ==
                TicketTier.Quarter
            ) {
                prize = moneyCollectedForEachLottery[lottery_no] / 32;
            }
        } else {
            prize = 0;
        }
        emit SinglePriceVal(prize);
        return (prize);
    }

    /**
    this function calculates the total value of the winners tickets in a specifiv lottery, has to be substracted from the total lottery balance when
     */
    function calculateTotalPriceValue(uint lottery_no) private returns (uint) {

        uint firstprice = calculateSinglePriceValue(1, lottery_no);
        uint secondprice = calculateSinglePriceValue(2, lottery_no);
        uint thirdprice = calculateSinglePriceValue(3, lottery_no);
        uint totalpricevalue = firstprice + secondprice + thirdprice;
        return totalpricevalue;
    }

    function getIthWinningTicket(
        uint i,
        uint lottery_no
    ) public returns (uint ticket_no, uint amount) {
        require(
            lottery_no <= (lotteryNoCalculator()),
            "Lottery you are requesting has not started yet!"
        );

        if (!(lotteryInfos[lottery_no].winningTickets.length == 3)) {
            pickWinner(lottery_no);
            totalPrizeMoney[lottery_no] = calculateTotalPriceValue(lottery_no);
            transferAmount(lottery_no, totalPrizeMoney[lottery_no]);
        }
        require(
            i == 1 || i == 2 || i == 3,
            "Invalid number of winning ticket!"
        );
        uint ticket_index = lotteryInfos[lottery_no].winningTickets[i - 1];
        ticket_no = lotteryInfos[lottery_no].ticketNosInLottery[ticket_index];

        (, ticket_index) = findTicketInfosFromNo(ticket_no);

        // TODO: we need to return the won amount, we need to store it on the blockchain
        amount = calculateSinglePriceValue(i, lottery_no);
        //amount = getamount(tier);

        emit WinningTicket(ticket_no, amount);
        return (ticket_no, amount);
    }

    function checkIfTicketWon(
        uint lottery_no,
        uint ticket_no
    ) public returns (uint) {
        //this requirement assures that the buyer is already allowed to check his ticket /buying phase is over because he has to wait until buying time is over
        require(
            lottery_no <= (lotteryNoCalculator()),
            "Lottery you are requesting has not started yet!"
        );
        if (!(lotteryInfos[lottery_no].winningTickets.length == 3)) {
            pickWinner(lottery_no);
            totalPrizeMoney[lottery_no] = calculateTotalPriceValue(lottery_no);
            transferAmount(lottery_no, totalPrizeMoney[lottery_no]);
        }
        require(
            ticket_no <= ticketNoCounter,
            "The ticket you are requesting does not exist"
        );
        require(
            ticketsFromOutside[ticket_no].owner == msg.sender,
            "You are not the owner!"
        );
        require(
            ticketsFromOutside[ticket_no].status == 1,
            "You have not revealed the random number yet!"
        );

        uint prize;
        bool boolean;
        string memory prizeName;
        uint firstPrizeWinnerTicketNo = lotteryInfos[lottery_no]
            .ticketNosInLottery[lotteryInfos[lottery_no].winningTickets[0]];
        uint secondPrizeWinnerTicketNo = lotteryInfos[lottery_no]
            .ticketNosInLottery[lotteryInfos[lottery_no].winningTickets[1]];
        uint thirdPrizeWinnerTicketNo = lotteryInfos[lottery_no]
            .ticketNosInLottery[lotteryInfos[lottery_no].winningTickets[2]];
        if (ticket_no == firstPrizeWinnerTicketNo) {
            prize = calculateSinglePriceValue(1, lottery_no);
            boolean = true;
        } else if (ticket_no == secondPrizeWinnerTicketNo) {
            prize = calculateSinglePriceValue(2, lottery_no);
            boolean = true;
        } else if (ticket_no == thirdPrizeWinnerTicketNo) {
            prize = calculateSinglePriceValue(3, lottery_no);
            boolean = true;
        } else {
            boolean = false;
            prize = 0;
        }
        emit Winner(boolean);

        return prize;
    }

    /**
    This function transferes the leftover Money (substracted by the Price Money) to the actual round, is called in BuyTicket() and
     */
    function findTicketInfosFromNo(uint ticket_no) public view returns (uint, uint) {
        uint lotteryNoCounter = lotteryNoCalculator();
        for (
            uint lottery_no = 0;
            lottery_no < lotteryNoCounter + 1;
            lottery_no++
        ) {
            for (
                uint index = 0;
                index < ticketNosArray[msg.sender].length;
                index++
            ) {
                if (ticketsFromOutside[ticket_no].ticketNo == ticket_no) {
                    return (lottery_no, index);
                }
            }
        }
    } // DELETABLE

    function collectTicketPrize(
        uint lottery_no,
        uint ticket_no
    ) public returns (uint) {
        require(
            lottery_no <= (lotteryNoCalculator()),
            "Lottery you are requesting has not started yet!"
        );
        require(
            ticket_no <= ticketNoCounter,
            "The ticket you are requesting does not exist"
        );
        require(
            ticketsFromOutside[ticket_no].status == 1,
            "Ticket is not revealed"
        );
        require(
            ticketsFromOutside[ticket_no].owner == msg.sender,
            "You are not the owner!"
        );
        if (!(lotteryInfos[lottery_no].winningTickets.length == 3)) {
            pickWinner(lottery_no);
            //
            totalPrizeMoney[lottery_no] = calculateTotalPriceValue(lottery_no);
            transferAmount(lottery_no, totalPrizeMoney[lottery_no]);
        }
        uint prize;
        uint prizeIndex;
        for (uint i = 0; i < 3; i++) {
            if (
                lotteryInfos[lottery_no].ticketNosInLottery[
                    lotteryInfos[lottery_no].winningTickets[i]
                ] == ticket_no
            ) {
                prizeIndex = i;
                prize = calculateSinglePriceValue(prizeIndex + 1, lottery_no);
                break; // Exit the loop if the ticket is found
            }
        }
        
       

        lotteryBalance -= prize;
        moneyCollectedForEachLottery[lottery_no] -= prize;
        balance[msg.sender] += prize;
        return prize;
    }

    //BELOW ARE GETTERS, SHOULD BE REMOVED TO OTHER CONTRACTS


    function hashOfANum(uint num) public view returns (bytes32) {
        return keccak256(abi.encodePacked(msg.sender, num));
    }

function getBalance() public view returns (uint) {
        return balance[msg.sender];
    }
}
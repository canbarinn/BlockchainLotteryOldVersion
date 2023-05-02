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

    mapping(address => mapping(uint => Ticket[])) public tickets; //address => lotteryNo => Ticket
    mapping(address => uint256) public balance;
    mapping(uint => LotteryInfo) public lotteryInfos; //lotteryNo => LotteryInfo
    mapping(uint => uint) public moneyCollectedForEachLottery;
    mapping(uint => uint) public totalPrizeMoney;
    mapping(uint => Ticket) ticketsFromOutside;


    struct Ticket {
        address owner;
        uint ticketNo;
        uint lotteryNo;
        bytes32 ticketHash;
        uint8 status; //revealed or not
        bool active; //Todo Can will add modifier to that
        TicketTier ticketTier; //0 = full ticket, 1 = half ticket, 2 = quarter ticket
    }

    struct LotteryInfo {
        uint lotteryNo;
        uint startTimestamp;
        uint[] winningTickets; // safes index of the three winning tickets //0 = first price, 1 = second price, 2 = third price
        uint[] ticketNosInLottery; //
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

    function lotteryNoCalculator() internal returns (uint) {
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

    function transferAmount(uint lottery_no, uint prize) public {
        totalPrizeMoney[lottery_no] += prize;
        require(moneyCollectedForEachLottery[lottery_no] >= prize, "Lottery is invalid, because there is not enough money in the Lottery for the prizes");
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

        if(tier == 2){
            require(balance[msg.sender] > 2 * 10 ** 10 , "insufficient balance for quarter ticket");
            ticketTier = TicketTier.Quarter;
            
        }
        else if(tier == 4){
            require(balance[msg.sender] > 4 * 10 ** 10 , "insufficient balance half ticket");
             ticketTier = TicketTier.Half;
        }
        else if(tier == 8){
            require(balance[msg.sender] > 8 * 10 ** 10 , "insufficient balance full ticket");
            ticketTier = TicketTier.Full;
        }

        // We have to check if the lottery before has already picked a winner when we buy tickets in the next round, not sure with indexing if it has to be -1 or -2
        if (lottery_no >= 3) {
            if (!(lotteryInfos[lottery_no - 2].winningTickets.length == 3)) {
                //picks the winner for the lottery before
                pickWinner(lottery_no - 2);
                totalPrizeMoney[lottery_no - 2] = calculateTotalPriceValue(
                    lottery_no - 2
                );
                transferAmount(lottery_no - 2, totalPrizeMoney[lottery_no - 2]);
            }
        }

        tickets[msg.sender][lottery_no].push(
            Ticket(
                msg.sender,
                ticketNoCounter,
                lottery_no,
                hash_rnd_number,
                0,
                true,
                ticketTier
            )
        );

        ticketsFromOutside[ticketNoCounter].owner = msg.sender;
        ticketsFromOutside[ticketNoCounter].ticketNo = ticketNoCounter;
        ticketsFromOutside[ticketNoCounter].lotteryNo = lottery_no;
        ticketsFromOutside[ticketNoCounter].ticketHash = hash_rnd_number;
        ticketsFromOutside[ticketNoCounter].status = 0;
        ticketsFromOutside[ticketNoCounter].active = true;
        ticketsFromOutside[ticketNoCounter].ticketTier = ticketTier;

        balance[msg.sender] -= getamount(ticketTier);
        lotteryBalance += getamount(ticketTier);
        lotteryInfos[lottery_no].ticketNosInLottery.push(ticketNoCounter);
        moneyCollectedForEachLottery[lottery_no] += getamount(ticketTier);
    }

    function revealRndNumber(uint ticket_no, uint random_number) public {
        // require(lotteryNoCounter > 1, "early");
        require(ticket_no <= ticketNoCounter, "There is no ticket with this number in the system");
        require(ticketsFromOutside[ticket_no].owner == msg.sender, "You are not the owner of this ticket");
        require(ticketsFromOutside[ticket_no].lotteryNo == (lotteryNoCalculator() -1), "incorrect time to reveal" );
        require(ticketsFromOutside[ticket_no].status == 0, "Sorry, you have already revealed" );
        bytes32 hash = keccak256(abi.encodePacked(msg.sender, random_number));
        (uint lottery_no, uint index) = findTicketInfosFromNo(ticket_no);
        if(hash == ticketsFromOutside[ticket_no].ticketHash) {
            ticketsFromOutside[ticket_no].status =1;
            tickets[msg.sender][lottery_no][index].status = 1;
        }
    }

    function getamount(TicketTier tier) public pure returns (uint) {
        uint amount;
        if (tier == TicketTier.Full) {
            amount = 8 * (10 );
        } else if (tier == TicketTier.Half) {
            amount = 4 * (10 );
        } else if (tier == TicketTier.Full) {
            amount = 2 * (10 );
        }
        else {
            amount = 0;
        }
        return amount;
    }

    function collectTicketRefund(uint ticket_no) public {
        require(ticket_no <= ticketNoCounter, "There is no ticket with this number in the system");
        require(ticketsFromOutside[ticket_no].owner == msg.sender, "You are not the owner of this ticket");
        require(ticketsFromOutside[ticket_no].lotteryNo == (lotteryNoCalculator()), "You cannot refund anymore" );
        require(ticketsFromOutside[ticket_no].status == 0, "You cannot refund anymore, ticket is already revealed" );
        uint lottery_no;
        uint ticket_index;
        (lottery_no, ticket_index) = findTicketInfosFromNo(ticket_no);
        TicketTier tier = tickets[msg.sender][lottery_no][ticket_index]
            .ticketTier;
        uint amount = getamount(tier);
        balance[msg.sender] += amount;
        moneyCollectedForEachLottery[lottery_no] -= amount;
        lotteryBalance -= amount;
        tickets[msg.sender][lottery_no][ticket_index].active = false;
        ticketsFromOutside[ticket_no].active = false;
    }

    function getIthOwnedTicketNo(
        uint i,
        uint lottery_no
    ) public returns (uint, uint8 status) {
        require(lottery_no <= (lotteryNoCalculator()), "Lottery you are requesting has not started yet" );
        require(tickets[msg.sender][lottery_no].length >= i, "You don`t have that many tickets");
        Ticket memory targetTicket;
        targetTicket = tickets[msg.sender][lottery_no][i];
        uint ticketNo = targetTicket.ticketNo;
        uint8 ticketStatus = targetTicket.status;
        return (ticketNo, ticketStatus);
    }



    function getLastOwnedTicketNo(
        uint lottery_no
    ) public view returns (uint, uint8) {
     require(tickets[msg.sender][lottery_no].length > 0, "You don`t have any tickets");
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
            tickets[msg.sender][lottery_no][index].status,
            tickets[msg.sender][lottery_no][index].active,
            tickets[msg.sender][lottery_no][index].ticketTier
        );
    }

    function getRandomNumber() internal view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp)));
    }

    // function pickWinner(uint lottery_no) private {
    //     if (lotteryInfos[lottery_no].ticketNosInLottery.length <= 3) {
    //         revert("not enough tickets");
    //         // TODO: make the tickets refundable here
    //     }
    //     uint numberofTickets = lotteryInfos[lottery_no]
    //         .ticketNosInLottery
    //         .length;
    //     uint index1 = getRandomNumber() %
    //         lotteryInfos[lottery_no].ticketNosInLottery.length;
    //     uint index2 = getRandomNumber() %
    //         lotteryInfos[lottery_no].ticketNosInLottery.length;
    //     uint index3 = getRandomNumber() %
    //         lotteryInfos[lottery_no].ticketNosInLottery.length;

    //     while ((index1 == index2) || (index2 == index3) || (index1 == index3)) {
    //         if (index1 == index2) {
    //             if (index1 != numberofTickets - 1) {
    //                 index1 = index2 + 1;
    //             } else {
    //                 index1 = 0;
    //             }
    //         } else if (index2 == index3) {
    //             if (index2 != numberofTickets - 1) {
    //                 index2 = index3 + 1;
    //             } else {
    //                 index2 = 0;
    //             }
    //         } else if (index1 == index3) {
    //             if (index1 != numberofTickets - 1) {
    //                 index1 = index3 + 1;
    //             } else {
    //                 index1 = 0;
    //         }
    //             }
    //         lotteryInfos[lottery_no].winningTickets.push(index1);
    //         lotteryInfos[lottery_no].winningTickets.push(index2);
    //         lotteryInfos[lottery_no].winningTickets.push(index3);

    //     }

    //     totalPrizeMoney[lottery_no] = calculateTotalPriceValue(lottery_no);
    // }

    function pickWinner(uint lottery_no) private {
        if (lotteryInfos[lottery_no].ticketNosInLottery.length < 3) {
            revert("There is not enough ticket for picking winners, lottery is cancelled!");
            // TODO: make the tickets refundable here
        }
        if (lotteryInfos[lottery_no].winningTickets.length == 3) {
            revert("Winners are already selected.");
            // TODO: make the tickets refundable here
        }
        require(lottery_no <= lotteryNoCalculator(), "Invalid lottery number!");


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

        // totalPrizeMoney[lottery_no] += calculateTotalPriceValue(lottery_no);
    }

    /**
    This Function calculates the value of a specific winning tickets, used in calculateTotalPriceValue() and checkIfTiketWon
     */
    function calculateSinglePriceValue(
        uint thPrice,
        uint lottery_no
    ) public returns (uint) {

        require(thPrice==1||thPrice==2||thPrice==3, "Invalid price type!");
        require(lottery_no <= lotteryNoCalculator(), "Invalid lottery number!");

        uint prize;

        uint winnerTicketNo = lotteryInfos[lottery_no].ticketNosInLottery[
            lotteryInfos[lottery_no].winningTickets[thPrice - 1]
        ];
        if (thPrice == 1) {
            if (
                ticketsFromOutside[winnerTicketNo].ticketTier == TicketTier.Full
            ) {
                //prize = lotteryBalance / 2;
                prize = moneyCollectedForEachLottery[lottery_no] / 2;
            } else if (
                ticketsFromOutside[winnerTicketNo].ticketTier == TicketTier.Half
            ) {
                //prize = lotteryBalance / 4;
                prize = moneyCollectedForEachLottery[lottery_no] / 4;
            } else if (
                ticketsFromOutside[winnerTicketNo].ticketTier ==
                TicketTier.Quarter
            ) {
                //prize = moneyCollectedForEachLottery[lottery_no] / 8;
                prize = moneyCollectedForEachLottery[lottery_no] / 8;
            } else {
                revert("Invalid operation.");
            }
        } else if (thPrice == 2) {
            if (
                ticketsFromOutside[winnerTicketNo].ticketTier == TicketTier.Full
            ) {
                //prize = moneyCollectedForEachLottery[lottery_no] / 4;
                prize = moneyCollectedForEachLottery[lottery_no] / 4;
            } else if (
                ticketsFromOutside[winnerTicketNo].ticketTier == TicketTier.Half
            ) {
                //prize = moneyCollectedForEachLottery[lottery_no] / 8;
                prize = moneyCollectedForEachLottery[lottery_no] / 8;
            } else if (
                ticketsFromOutside[winnerTicketNo].ticketTier ==
                TicketTier.Quarter
            ) {
                //prize = moneyCollectedForEachLottery[lottery_no] / 16;
                prize = moneyCollectedForEachLottery[lottery_no] / 16;
            } else {
                revert("Invalid operation.");
            }
        } else if (thPrice == 3) {
            if (
                ticketsFromOutside[winnerTicketNo].ticketTier == TicketTier.Full
            ) {
                //prize = moneyCollectedForEachLottery[lottery_no] / 8;
                prize = moneyCollectedForEachLottery[lottery_no] / 8;
            } else if (
                ticketsFromOutside[winnerTicketNo].ticketTier == TicketTier.Half
            ) {
                //prize = moneyCollectedForEachLottery[lottery_no] / 16;
                prize = moneyCollectedForEachLottery[lottery_no] / 16;
            } else if (
                ticketsFromOutside[winnerTicketNo].ticketTier ==
                TicketTier.Quarter
            ) {
                //prize = moneyCollectedForEachLottery[lottery_no] / 32;
                prize = moneyCollectedForEachLottery[lottery_no] / 32;
            } else {
                revert("Invalid operation.");
            }
        } else {
            prize = 0;
        }
        return (prize);
    }

    /**
    this function calculates the total value of the winners tickets in a specifiv lottery, has to be substracted from the total lottery balance when
     */
    //needs more requirements, for example if the winners tickets have been determined
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
        require(lottery_no <= (lotteryNoCalculator()), "Lottery you are requesting has not started yet!" );
        require(lotteryInfos[lottery_no].winningTickets.length == 3, "There is no winning ticket selected yet!");
        require(i==1||i==2||i==3, "Invalid number of winning ticket!");
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
        require(lottery_no <= (lotteryNoCalculator()), "Lottery you are requesting has not started yet!" );
        require(ticket_no <= ticketNoCounter, "Lottery you are requesting has not started yet!" );
        require(ticketsFromOutside[ticket_no].owner == msg.sender, "You are not the owner!");
        require(ticketsFromOutside[ticket_no].status == 1, "You have not revealed the random number yet!");

        //picks winners tickets if they haven`t been chosen before
        if (!(lotteryInfos[lottery_no].winningTickets.length == 3)) {
            pickWinner(lottery_no);
            totalPrizeMoney[lottery_no] = calculateTotalPriceValue(lottery_no);
            transferAmount(lottery_no, totalPrizeMoney[lottery_no]);
        }
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
        //ToDo Add won prize to users balance
    }

    /**
    This function transferes the leftover Money (substracted by the Price Money) to the actual round, is called in BuyTicket() and
     */
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

    function collectTicketPrize(
        uint lottery_no,
        uint ticket_no
    ) public returns (uint) {
        require(ticketsFromOutside[ticket_no].status == 1, "not revealed");
        if (!(lotteryInfos[lottery_no].winningTickets.length == 3)) {
            pickWinner(lottery_no);
            totalPrizeMoney[lottery_no] = calculateTotalPriceValue(lottery_no);
            transferAmount(lottery_no, totalPrizeMoney[lottery_no]);
        }
        uint prizeIndex;
        for (uint i = 0; i < 3; i++) {
            if (
                lotteryInfos[lottery_no].ticketNosInLottery[
                    lotteryInfos[lottery_no].winningTickets[i]
                ] == ticket_no
            ) {
                prizeIndex = i;
                break; // Exit the loop if the ticket is found
            }
        }

        uint prize = calculateSinglePriceValue(prizeIndex + 1, lottery_no);

        lotteryBalance -= prize;
        moneyCollectedForEachLottery[lottery_no] -= prize;
        balance[msg.sender] += prize;
        return prize;
    }

    function getMoneyCollected() public view returns (uint amount) {
        return lotteryBalance;
    }

    function getTotalPrizeMoney(
        uint lottery_no
    ) public view returns (uint amount) {
        return totalPrizeMoney[lottery_no];
    }

    function getLotteryMoneyCollected(
        uint lottery_no
    ) public view returns (uint) {
        return moneyCollectedForEachLottery[lottery_no];
    }

    function getWinningTicket1(uint lottery_no) public view returns (uint) {
        return (
            lotteryInfos[lottery_no].ticketNosInLottery[
                lotteryInfos[lottery_no].winningTickets[0]
            ]
        );
    }

    function getWinningTicket2(uint lottery_no) public view returns (uint) {
        return (
            lotteryInfos[lottery_no].ticketNosInLottery[
                lotteryInfos[lottery_no].winningTickets[0]
            ]
        );
    }

    function getWinningTicket3(uint lottery_no) public view returns (uint) {
        return (
            lotteryInfos[lottery_no].ticketNosInLottery[
                lotteryInfos[lottery_no].winningTickets[0]
            ]
        );
    }

    function getBalance() public view returns (uint) {
        return balance[msg.sender];
    }

    function getTicketPrize(
        uint lottery_no,
        uint ticket_no
    ) public view returns (uint) {
        uint prize;
        for (uint i = 0; i < 3; i++) {
            if (
                lotteryInfos[lottery_no].ticketNosInLottery[
                    lotteryInfos[lottery_no].winningTickets[i]
                ] == ticket_no
            ) {
                prize = (i + 1) * 500000;
            }
        }
        return prize;
    }

    function ticketCount(uint lottery_no) public view returns (uint) {
        return lotteryInfos[lottery_no].ticketNosInLottery.length;
    }



    function getTicketInfos(uint ticket_no) public view returns(address,uint,uint,bytes32,uint8,bool,TicketTier) {
        return (
            ticketsFromOutside[ticket_no].owner,
            ticketsFromOutside[ticket_no].ticketNo,
            ticketsFromOutside[ticket_no].lotteryNo,
            ticketsFromOutside[ticket_no].ticketHash,
            ticketsFromOutside[ticket_no].status,
            ticketsFromOutside[ticket_no].active,
            ticketsFromOutside[ticket_no].ticketTier
        );
    }

    function getOwner(uint ticket_no) public view returns(address) {
        return ticketsFromOutside[ticket_no].owner;
    }

    function ticketNosInLotteryGetter(uint lottery_no) public view returns (uint[] memory) {
        return lotteryInfos[lottery_no].ticketNosInLottery;
    }

    function hashOfANum(uint num) public view returns(bytes32) {
        return keccak256(abi.encodePacked(msg.sender, num));

    }

}

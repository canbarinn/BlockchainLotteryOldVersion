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

    mapping(address => uint[]) public ticketNosArray; //address => Ticketno
    // mapping(address => mapping(uint => Ticket[])) public tickets; //address => lotteryNo => Ticket // DELETABLE
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

    /// @notice add money on users account balance
    function depositEther() public payable {
        // amountu cikar
        balance[msg.sender] += msg.value;

        // console.log(msg.value);
        // console.log(balance[msg.sender]);
    }

    /// @notice transfers the left-over money from a certain lottery to the following lottery after the prize amount has been substracted
    /// @param lottery_no actual lottery number
    /// @param  prize prize which will be add to amount of winnable money in that lottery
    function transferAmount(uint lottery_no, uint prize) public {
        totalPrizeMoney[lottery_no] += prize;
        require(
            moneyCollectedForEachLottery[lottery_no] >= prize,
            "Lottery is invalid, because there is not enough money in the Lottery for the prizes"
        );
        uint transferAmnt = moneyCollectedForEachLottery[lottery_no] - prize;
        moneyCollectedForEachLottery[lottery_no + 1] += transferAmnt;
    }

    /// @notice substracts the amount of given ether and sends it back und the user
    /// @param amount of ether to be withdrawn
    function withdrawEther(uint amount) public payable {
        require(balance[msg.sender] >= amount, "insufficient balance");
        balance[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    /// @notice function by which user can buy ticket by his choice, checks tier first and creates a Ticket 
    /// @param hash_rnd_number random hash number which is given by the user to buy the ticket
    /// @param tier chosen type of ticket, can be 2 , 4 , 8
    function buyTicket(bytes32 hash_rnd_number, int tier) public {
        ticketNoCounter += 1;
        uint lottery_no = lotteryNoCalculator();
        TicketTier ticketTier;

        if (tier == 3) {
            require(
                balance[msg.sender] > 2 * 10 ** 10,
                "insufficient balance for quarter ticket"
            );
            ticketTier = TicketTier.Quarter;
        } else if (tier == 2) {
            require(
                balance[msg.sender] > 4 * 10 ** 10,
                "insufficient balance for half ticket"
            );
            ticketTier = TicketTier.Half;
        } else if (tier == 1) {
            require(
                balance[msg.sender] > 8 * 10 ** 10,
                "insufficient balance for full ticket"
            );
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

        // tickets[msg.sender][lottery_no].push(
        //     Ticket(
        //         msg.sender,
        //         ticketNoCounter,
        //         lottery_no,
        //         hash_rnd_number,
        //         0,
        //         true,
        //         ticketTier
        //     )
        // ); //DELETABLE

        ticketsFromOutside[ticketNoCounter].owner = msg.sender;
        ticketsFromOutside[ticketNoCounter].ticketNo = ticketNoCounter;
        ticketsFromOutside[ticketNoCounter].lotteryNo = lottery_no;
        ticketsFromOutside[ticketNoCounter].ticketHash = hash_rnd_number;
        ticketsFromOutside[ticketNoCounter].status = 0;
        ticketsFromOutside[ticketNoCounter].active = true;
        ticketsFromOutside[ticketNoCounter].ticketTier = ticketTier;

        //Todo this gives error
        ticketNosArray[msg.sender].push(ticketNoCounter);
        balance[msg.sender] -= getamount(ticketTier);
        lotteryBalance += getamount(ticketTier);
        lotteryInfos[lottery_no].ticketNosInLottery.push(ticketNoCounter);
        moneyCollectedForEachLottery[lottery_no] += getamount(ticketTier);
    }

    /// @notice revealing the number that user provided us at reveal stage
    /// @param ticket_no users ticket number
    /// @param random_number number he used to buy the ticket
    function revealRndNumber(uint ticket_no, uint random_number) public {
        // require(lotteryNoCounter > 1, "early");
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
        (uint lottery_no, uint index) = findTicketInfosFromNo(ticket_no);
        if (hash == ticketsFromOutside[ticket_no].ticketHash) {
            ticketsFromOutside[ticket_no].status = 1;
            // tickets[msg.sender][lottery_no][index].status = 1; // DELETABLE
        } else {
            revert("Incorrect number!");
        }
    }

    /// @notice helper function to calculate the buy-price of a ticket given by its tier
    /// @param tier type of ticket (Full, Half, Quarter)
    /// @return amount buy-value of the ticket
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

    /// @notice function which enables users to get a ticket refund. Sends back amount to his account and decreases balance of lottery
    /// @param ticket_no number of ticket user wants to withdraw
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
        uint lottery_no;
        uint ticket_index;
        (lottery_no, ticket_index) = findTicketInfosFromNo(ticket_no);
        TicketTier tier = ticketsFromOutside[ticket_no].ticketTier;
        uint amount = getamount(tier);
        balance[msg.sender] += amount;
        moneyCollectedForEachLottery[lottery_no] -= amount;
        lotteryBalance -= amount;
        // tickets[msg.sender][lottery_no][ticket_index].active = false; // DELETABLE
        ticketsFromOutside[ticket_no].active = false;
    }

    /// @notice function which gives user the number of the ticket by a given index and lottery number
    /// @param i th ticket user wants to get
    /// @param lottery_no number of lottery user is referring to
    /// @return ticketNo number of the wanted ticket
    /// @return status status, if the ticket is revealed or not
    function getIthOwnedTicketNo( 
        uint i,
        uint lottery_no
    ) public returns (uint, uint8) {
        require(
            lottery_no <= (lotteryNoCalculator()),
            "Lottery you are requesting has not started yet"
        );
        require(
            ticketNosArray[msg.sender].length >= i,
            "You don`t have that many tickets"
        );
        // Ticket memory targetTicket;
        // targetTicket = tickets[msg.sender][lottery_no][i];
        // uint ticketNo = targetTicket.ticketNo;
        // uint8 ticketStatus = targetTicket.status; // DELETABLE

        uint ticketNum = ticketNosArray[msg.sender][i - 1];
        uint8 status = ticketsFromOutside[ticketNum].status;
        return (ticketNum, status);
    }

    /// @notice gives back the last bought ticket`s ticket number and it`s status
    /// @param lottery_no number of lottery user is referring to
    /// @return uint number of the wanted ticket
    /// @return uint8 status, if the ticket is revealed or not
    function getLastOwnedTicketNo(
        uint lottery_no
    ) public view returns (uint, uint8) {
        require(
            ticketNosArray[msg.sender].length > 0,
            "You don`t have any tickets"
        );
        uint lastOwnedTicketNo;

        // DO BINARY SEARCH HERE ya da LOTTERY TICKETLARININ EN BASINDAKINDEN HESAPLA
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

        // uint lastIndex = tickets[msg.sender][lottery_no].length - 1;
        // return (
        //     tickets[msg.sender][lottery_no][lastIndex].ticketNo,
        //     tickets[msg.sender][lottery_no][lastIndex].status
        // ); // DELETABLE
    }

    /// @notice helper function to get properties of a ticket by it`s ticket number
    /// @param ticket_number ticket number user is referring to
    function getTicketInfo(uint ticket_number) public {
        (uint lottery_no, uint index) = findTicketInfosFromNo(ticket_number);

        // emit TicketInfo(
        //     tickets[msg.sender][lottery_no][index].ticketNo,
        //     tickets[msg.sender][lottery_no][index].lotteryNo,
        //     tickets[msg.sender][lottery_no][index].ticketHash,
        //     tickets[msg.sender][lottery_no][index].status,
        //     tickets[msg.sender][lottery_no][index].active,
        //     tickets[msg.sender][lottery_no][index].ticketTier
        // ); // DELETABLE
        emit TicketInfo(
            ticketsFromOutside[ticket_number].ticketNo,
            ticketsFromOutside[ticket_number].lotteryNo,
            ticketsFromOutside[ticket_number].ticketHash,
            ticketsFromOutside[ticket_number].status,
            ticketsFromOutside[ticket_number].active,
            ticketsFromOutside[ticket_number].ticketTier
        );
    }

    /// @notice helper function to get a ranrom number 
    /// @return uint 
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

    /// @notice picks three random winner tickets of a lottery by the given lottery number. Those winner tickets can be then found 
    ///         in WinningTickets Array in which we save the ticket number of the three winners ticket
    /// @param lottery_no number of lottery we are referring to
    function pickWinner(uint lottery_no) private {
        if (lotteryInfos[lottery_no].ticketNosInLottery.length < 3) {
            revert(
                "There is not enough ticket for picking winners, lottery is cancelled!"
            );
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

    /// @notice calculates the won price of the th-winning ticket. We determine which winning ticket is referred to and then compute the won prize 
    /// on the amount of ether existing in the givin lottery number.
    /// @param thPrice the th-price which`s value we want to calculate
    /// @param lottery_no number of lottery we are referring to
    /// @return uint amount won by the ticket
    function calculateSinglePriceValue(
        uint thPrice,
        uint lottery_no
    ) public returns (uint) {
        require(
            thPrice == 1 || thPrice == 2 || thPrice == 3,
            "Invalid price type!"
        );
        require(lottery_no <= lotteryNoCalculator(), "Invalid lottery number!");
        require(
            lotteryInfos[lottery_no].winningTickets.length == 3,
            "There is no winning ticket selected yet!"
        );
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
        emit SinglePriceVal(prize);
        return (prize);
    }

    /// @notice this function calculates the total value of the winners tickets in a specifiv lottery
    /// @param lottery_no number of lottery we are referring to
    /// @return uint amount won by the ticket
    function calculateTotalPriceValue(uint lottery_no) private returns (uint) {
        uint firstprice = calculateSinglePriceValue(1, lottery_no);
        uint secondprice = calculateSinglePriceValue(2, lottery_no);
        uint thirdprice = calculateSinglePriceValue(3, lottery_no);
        uint totalpricevalue = firstprice + secondprice + thirdprice;
        return totalpricevalue;
    }

    /// @notice this function finds the i-th winning ticket in a given lottery. By using findTicketInfosFromNo function
    /// information about the ticket can be easily found
    /// @param i i-th ticket index
    /// @param lottery_no number of lottery we are referring to
    /// @return ticket_no number of the i-th won ticket 
    /// @return amount amount of money won by the ticket
    function getIthWinningTicket(
        uint i,
        uint lottery_no
    ) public returns (uint ticket_no, uint amount) {
        require(
            lottery_no <= (lotteryNoCalculator()),
            "Lottery you are requesting has not started yet!"
        );
        require(
            lotteryInfos[lottery_no].winningTickets.length == 3,
            "There is no winning ticket selected yet!"
        );
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

    /// @notice checks if a ticket given by it`s ticket number and the lottery number is a winning ticket. Since we safe the winning ticket in a specific 
    ///         array (winningTickets[]), we can easily compare the ticket numbers
    /// @param lottery_no number of lottery we are referring to
    /// @param ticket_no number of ticket we are referring to
    /// @return prize amount of money won by the ticket if it is a winning ticket, zero if not
    function checkIfTicketWon(
        uint lottery_no,
        uint ticket_no
    ) public returns (uint) {
        //this requirement assures that the buyer is already allowed to check his ticket /buying phase is over because he has to wait until buying time is over
        require(
            lottery_no <= (lotteryNoCalculator()),
            "Lottery you are requesting has not started yet!"
        );
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
                index < ticketNosArray[msg.sender].length;
                index++
            ) {
                if (ticketsFromOutside[ticket_no].ticketNo == ticket_no) {
                    return (lottery_no, index);
                }
            }
        }
    } // DELETABLE



    /// @notice collects the price of a winning ticket, adds it to the senders balance then
    /// @param lottery_no number of lottery we are referring to
    /// @param ticket_no number of ticket we are referring to
    /// @return uint amount of money won by the ticket 
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
        require(ticketsFromOutside[ticket_no].status == 1, "not revealed");
        require(
            ticketsFromOutside[ticket_no].owner == msg.sender,
            "You are not the owner!"
        );
        require(
            lotteryInfos[lottery_no].winningTickets.length == 3,
            "Winners ticket have not been selected yet"
        );

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

    //BELOW ARE GETTERS, SHOULD BE REMOVED TO OTHER CONTRACTS

    ///@notice getter function for the total lottery balance
    ///@return amount of money in the lottery
    function getMoneyCollected() public view returns (uint amount) {
        return lotteryBalance;
    }

    ///@notice getter function for the value of all three prizes inside a lottery given by it`s lottery number
    ///@return amount of prize money in the lottery with lottery number No
    function getTotalPrizeMoney(
        uint lottery_no
    ) public view returns (uint amount) {
        return totalPrizeMoney[lottery_no];
    }

     ///@notice getter function for the total lottery inside a certain lottery given by it`s lottery number
    ///@return amount of money in the lottery with given lottery number No
    function getLotteryMoneyCollected(
        uint lottery_no
    ) public view returns (uint) {
        return moneyCollectedForEachLottery[lottery_no];
    }

    ///@notice getter function to receive the ticket number of the first winning ticket inside a certain lottery
    ///@return uint ticket number of the first winning ticket
    function getWinningTicket1(uint lottery_no) public view returns (uint) {
        return (
            lotteryInfos[lottery_no].ticketNosInLottery[
                lotteryInfos[lottery_no].winningTickets[0]
            ]
        );
    }

    ///@notice getter function to receive the ticket number of the second winning ticket inside a certain lottery
    ///@return uint ticket number of the second winning ticket
    function getWinningTicket2(uint lottery_no) public view returns (uint) {
        return (
            lotteryInfos[lottery_no].ticketNosInLottery[
                lotteryInfos[lottery_no].winningTickets[0]
            ]
        );
    }

    ///@notice getter function to receive the ticket number of the third winning ticket inside a certain lottery
    ///@return uint ticket number of the third winning ticket
    function getWinningTicket3(uint lottery_no) public view returns (uint) {
        return (
            lotteryInfos[lottery_no].ticketNosInLottery[
                lotteryInfos[lottery_no].winningTickets[0]
            ]
        );
    }

    ///@notice getter function for the balance of a sender
    ///@return uint sender`s balance
    function getBalance() public view returns (uint) {
        return balance[msg.sender];
    }


    ///@notice returns the prize of a ticket given by the lottery number and the winning ticket number. Has to check if given ticket matches with the existing winning tickets
    ///@param lottery_no  number of lottery we are referring to
    ///@param ticket_no  number of ticket we are referring to
    ///@return uint prize of the ticket
    function getTicketPrize(
        uint lottery_no,
        uint ticket_no
    ) public view returns (uint) {
        // require(lottery_no <= (lotteryNoCalculator()), "Lottery you are requesting has not started yet!" );
        require(
            ticket_no <= ticketNoCounter,
            "The ticket you are requesting does not exist"
        );
        require(ticketsFromOutside[ticket_no].status == 1, "not revealed");
        require(
            ticketsFromOutside[ticket_no].owner == msg.sender,
            "You are not the owner!"
        );
        require(
            lotteryInfos[lottery_no].winningTickets.length == 3,
            "Winners ticket have not been selected yet"
        );
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

    ///@notice helper function to count the tickets inside a given lottery
    ///@param lottery_no number of lottery we are referring to
    function ticketCount(uint lottery_no) public view returns (uint) {
        return lotteryInfos[lottery_no].ticketNosInLottery.length;
    }

    ///@notice helper function to receive all the attributes of a ticket
    ///@param ticket_no number of ticket we are referring to
    function getTicketInfos(
        uint ticket_no
    )
        public
        view
        returns (address, uint, uint, bytes32, uint8, bool, TicketTier)
    {
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

    ///@notice helper function to find the owner of a ticket by sending back the owner`s address
    ///@param ticket_no number of ticket we are referring to
    function getOwner(uint ticket_no) public view returns (address) {
        return ticketsFromOutside[ticket_no].owner;
    }

    ///@notice helper function to get all the ticket numbers (safed in an array) existing in the given lottery number
    ///@param lottery_no number of lottery we are referring to
    function ticketNosInLotteryGetter(
        uint lottery_no
    ) public view returns (uint[] memory) {
        return lotteryInfos[lottery_no].ticketNosInLottery;
    }

    function hashOfANum(uint num) public view returns (bytes32) {
        return keccak256(abi.encodePacked(msg.sender, num));
    }
}

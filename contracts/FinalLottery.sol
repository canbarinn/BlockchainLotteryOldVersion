// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract DALottery {
    uint ticketNoCounter;
    uint lotteryNoCounter = 1;

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
        TicketTier ticketTier; //0 = full ticket, 1 = half ticket, 2 = quarter ticket
    }

    struct LotteryInfo {
        uint lotteryNo;
        uint startTimestamp;
        uint[] winningTickets; //0 = full ticket, 1 = half ticket, 2 = quarter ticket
        uint[] ticketNosInLottery;
        uint lotteryBalance;
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
        require(tier = 1 || tier = 2 ||  tier = 3, "Wrong Input");
        ticketNoCounter += 1;
        if(tier == 1) {
                    ticketTier = TicketTier.Full
                }
                else if(tier == 2) {
                    ticketTier = TicketTier.Half

                }
                else if(tier == 3) {
                    ticketTier = TicketTier.Quarter
                }   
    
        tickets[msg.sender][lotteryNoCounter].push(
            Ticket(
                ticketNoCounter,
                lotteryNoCounter,
                hash_rnd_number,
                block.timestamp,
                0,
                TicketTier = tier
            )
        );
        lotteryInfos[lotteryNoCounter].ticketNosInLottery.push(ticketNoCounter);
    }
}

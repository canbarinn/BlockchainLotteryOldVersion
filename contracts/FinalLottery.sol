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
        uint[] winningTickets; //0 = full ticket, 1 = half ticket, 2 = quarter ticket
        uint[] ticketNosInLottery;
        uint lotteryBalance;
    }

    function lotteryNoCalculator() public returns(uint){
        uint currentTime = block.timestamp;
        uint timePassed = currentTime - lotteryDeploymentTime;
        uint lotteryNo = (timePassed / (60*60*24*7))+1;
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
        require(tier == 1 || tier == 2 ||  tier == 3, "Wrong Input");
        ticketNoCounter += 1;
        if(tier == 1) {
                    ticketTier = TicketTier.Full;
                }
                else if(tier == 2) {
                    ticketTier = TicketTier.Half;

                }
                else if(tier == 3) {
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
    }


    function collectTicketRefund(uint ticket_no) public {
        uint lottery_no;
        uint ticket_index;
        
        (lottery_no, ticket_index) = findTicketInfosFromNo(ticket_no);
        TicketTier tier = tickets[msg.sender][lottery_no][ticket_index].ticketTier;
        uint amount;
        if (tier == TicketTier.Full) {
            amount = 8;
        }
        else if (tier == TicketTier.Half) {
            amount = 4;
        }
        else if (tier == TicketTier.Full) {
            amount = 2;
        }
        balance[msg.sender] += amount;
        tickets[msg.sender][lottery_no][ticket_index].active = false;
}
    function getIthOwnedTicketNo(uint i,uint lottery_no) public view returns(uint,uint8 status){
        Ticket memory targetTicket;
        targetTicket = tickets[msg.sender][lottery_no][i];
        uint ticketNo = targetTicket.ticketNo;
        uint8 ticketStatus = targetTicket.status;
        return (ticketNo, ticketStatus);
}

   


    function findTicketInfosFromNo(uint ticket_no)  public returns(uint, uint){
    uint lotteryNoCounter = lotteryNoCalculator();
    for(uint lottery_no=0; lottery_no<lotteryNoCounter+1; lottery_no++) {
        for (uint index=0; index<tickets[msg.sender][lottery_no].length; index++) {
            if(tickets[msg.sender][lottery_no][index].ticketNo == ticket_no){
                return(lottery_no,index);
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



function getTicketInfo(uint ticketNo) public view returns(Ticket memory){ 

}
}

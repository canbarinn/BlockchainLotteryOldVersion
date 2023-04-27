// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract DALottery {
    uint ticketNoCounter;
    uint lotteryNoCounter;
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
    
        tickets[msg.sender][lotteryNoCounter].push(
            Ticket(
                ticketNoCounter,
                lotteryNoCounter,
                hash_rnd_number,
                block.timestamp,
                0,
                ticketTier
            )
        );
        lotteryInfos[lotteryNoCounter].ticketNosInLottery.push(ticketNoCounter);
    }


    function collectTicketRefund(uint ticket_no) public {

}
    function findTicketInfosFromNo(uint ticket_no)  public view returns(uint, uint){
    for(uint lottery_no=0; lottery_no<lotteryNoCounter+1; lottery_no++) {
        for (uint index=0; index<tickets[msg.sender][lottery_no].length; index++) {
            if(tickets[msg.sender][lottery_no][index].ticketNo == ticket_no){
                return(lottery_no,index);
            }
        } 
    }
}
}

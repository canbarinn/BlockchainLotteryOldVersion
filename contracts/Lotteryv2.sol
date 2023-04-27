// import "hardhat/console.sol";
// import "@openzeppelin/contracts/utils/Strings.sol";

// //https://www.youtube.com/watch?v=8ElPDw0laIo
// // lottery no => address => ticket

// //IDEAS and TODOS
// // lottery nos should be decided when you buy ticket accordingly by calculating the timestamp difference as week. Constructor can be taken as timestamp
// // lottery no and timestamp relation will be used as the determining relationships between timelines
// // there will be no loop, lottery nos and times will be completed with requires, such as the ticket you are trying to reveal is no longer available etc. 
// // user will give 1 number and the hash will be taken from the javascript code
// // lottery no counter is useless in this case, contract need to be changed greatly, STORAGE SYSTEMS NEEDS TO BE ORGANIZED
// // STORAGE SYSYTEM IDEA: you can have lottery no getter which determines lottery no and do the necessary adjustments accordingly. 
// // TIER will be selected in the buy ticket fuinction, you will need to add that. 


// contract DALottery {
//     uint ticketNoCounter;
//     uint lotteryNoCounter = 1;

//     enum TicketTier {
//         Full,
//         Half,
//         Quarter,
//         Invalid
//     }
//     mapping(address => mapping(uint => Ticket[])) tickets; //address => lotteryNo => Ticket
//     mapping(address => uint256) public balance;
//     mapping(uint => LotteryInfo) lotteryInfos; //lotteryNo => LotteryInfo

//     struct Ticket {
//         uint ticketNo;
//         uint lotteryNo;
//         bytes32 ticketHash;
//         uint ticketTimestamp;
//         uint8 status;
//         TicketTier ticketTier; //0 = full ticket, 1 = half ticket, 2 = quarter ticket
//     }

//     struct LotteryInfo {
//         uint lotteryNo;
//         uint startTimestamp;
//         uint[] winningTickets; //0 = full ticket, 1 = half ticket, 2 = quarter ticket
//         uint[] ticketNosInLottery;
//         uint lotteryBalance;
//     }

//     event RandomNumber(bytes32 hash);
//     event WeekNos(uint weekno1, uint weekno2);

//     function depositEther() public payable { // amountu cikar 
//         balance[msg.sender] += msg.value;

//         // console.log(msg.value);
//         // console.log(balance[msg.sender]);
//     }

//     function withdrawEther(uint amount) public payable {
//         require(balance[msg.sender] >= amount, "insufficient balance");
//         balance[msg.sender] -= amount;
//         payable(msg.sender).transfer(amount);
//     }

//     function getBalance() public view returns (uint) {
//         return balance[msg.sender];
//     }

//     function getTicket(uint lottery_no) public view returns (TicketTier) {
     

//     // function setTicketTier(uint8 tier, uint lottery_no_counter, uint index) public {
//     //     getLastOwnedTicketNo(lottery_no_counter);
//     //     if(tier == 0) {
//     //         tickets[msg.sender][lottery_no_counter][index].ticketTier = 0;
//     //     } else if (tier == 1) {
//     //         tickets[msg.sender][lottery_no_counter][index].ticketTier = 1;
//     //     } else if (tier == 2) {
//     //         tickets[msg.sender][lottery_no_counter][index].ticketTier = 2;

//     //     } else {
//     //         tickets[msg.sender][lottery_no_counter][index].ticketTier = 404;
//     //     }
//     // }

//     function lotteryStarter() public {
//         lotteryInfos[lotteryNoCounter].lotteryNo = lotteryNoCounter;
//         lotteryInfos[lotteryNoCounter].startTimestamp = block.timestamp;
//     }

//     function getLottery(
//         uint lottery_no
//     ) public view returns (LotteryInfo memory) {
//         return lotteryInfos[lottery_no];
//     }

//     function getIthOwnedTicketNo(
//         uint i,
//         uint lottery_no
//     ) public view returns (uint, uint8) {
//         return (
//             tickets[msg.sender][lottery_no][i - 1].ticketNo,
//             tickets[msg.sender][lottery_no][i - 1].status
//         );
//     }

//     function getLastOwnedTicketNo(
//         uint lottery_no
//     ) public view returns (uint, uint8) {
//         uint lastIndex = tickets[msg.sender][lottery_no].length - 1;
//         return (
//             tickets[msg.sender][lottery_no][lastIndex].ticketNo,
//             tickets[msg.sender][lottery_no][lastIndex].status
//         );
//     }

//     function revealRndNumber(uint ticket_no, uint random_number) public {
//         require(lotteryNoCounter > 1, "early");
//         uint ticketIndex;
//         for (
//             uint i = 0;
//             i < tickets[msg.sender][lotteryNoCounter - 1].length;
//             i++
//         ) {
//             if (
//                 tickets[msg.sender][lotteryNoCounter - 1][i].ticketNo ==
//                 ticket_no
//             ) {
//                 ticketIndex = i;
//             }
//         }
//         bytes32 hash = keccak256(abi.encodePacked(random_number));

//         require(
//             tickets[msg.sender][lotteryNoCounter - 1][ticketIndex].ticketHash ==
//                 keccak256(abi.encodePacked(random_number))
//         ); // lotteryNoCounter-1 because we are in reveal time
//         tickets[msg.sender][lotteryNoCounter - 1][ticketIndex].status = 1;

//         emit RandomNumber(hash);
//     }

//     function setLotteryNo(uint lottery_no) public {
//         lotteryNoCounter = lottery_no;
//     }

//     function buyTicket(bytes32 hash_rnd_number, TicketTier tier) public {
//         ticketNoCounter += 1;
//         tickets[msg.sender][lotteryNoCounter].push(
//             Ticket(
//                 ticketNoCounter,
//                 lotteryNoCounter,
//                 hash_rnd_number,
//                 block.timestamp,
//                 0,
//                 TicketTier.Quarter
//             )
//         );
//         lotteryInfos[lotteryNoCounter].ticketNosInLottery.push(ticketNoCounter);
//     }

//     function getLotteryNos(uint unixtimeinweek) public returns (uint, uint) {
//         uint amountOfSecs = unixtimeinweek - lotteryInfos[1].startTimestamp;
//         uint firstLottery = (amountOfSecs / (60 * 60 * 24 * 7)) + 1;
//         emit WeekNos(firstLottery, firstLottery + 1);
//         return (firstLottery, firstLottery + 1);
//     }

//     function decideWinningNumbers(
//         uint fullWinner,
//         uint halfWinner,
//         uint quarterWinner,
//         uint lottery_no
//     ) public {
//         lotteryInfos[lottery_no].winningTickets.push(fullWinner);
//         lotteryInfos[lottery_no].winningTickets.push(halfWinner);
//         lotteryInfos[lottery_no].winningTickets.push(quarterWinner);
//     }

//     function amountReturn(
//         uint lottery_no,
//         uint index
//     ) public view returns (uint) {
//         if (
//             tickets[msg.sender][lottery_no][index].ticketTier == TicketTier.Full
//         ) {
//             return 8;
//         } else if (
//             tickets[msg.sender][lottery_no][index].ticketTier == TicketTier.Half
//         ) {
//             return 4;
//         } else if (
//             tickets[msg.sender][lottery_no][index].ticketTier ==
//             TicketTier.Quarter
//         ) {
//             return 2;
//         } else {
//             return 0;
//         }
//     }

//     function checkIfTicketWon(
//         uint256 lottery_no,
//         uint256 ticket_no
//     ) public view returns (uint256 amount) {
//         uint index;

//         for (uint i = 0; i < tickets[msg.sender][lottery_no].length; i++) {
//             if (tickets[msg.sender][lottery_no][i].ticketNo == ticket_no) {
//                 index = i;
//             }
//         }

//         if (
//             tickets[msg.sender][lottery_no][index].ticketHash ==
//             keccak256(
//                 abi.encodePacked(lotteryInfos[lottery_no].winningTickets[0])
//             )
//         ) {
//             return 8;
//         } else if (
//             tickets[msg.sender][lottery_no][index].ticketHash ==
//             keccak256(
//                 abi.encodePacked(lotteryInfos[lottery_no].winningTickets[1])
//             )
//         ) {
//             return 4;
//         } else if (
//             tickets[msg.sender][lottery_no][index].ticketHash ==
//             keccak256(
//                 abi.encodePacked(lotteryInfos[lottery_no].winningTickets[2])
//             )
//         ) {
//             return 2;
//         } else {
//             return 0;
//         }
//     }

//     function getIthWinningTicket(
//         uint256 i,
//         uint256 lottery_no
//     ) public view returns (uint256 ticket_no, uint256 amount) {
//         return (
//             tickets[msg.sender][lottery_no][i - 1].ticketNo,
//             amountReturn(lottery_no, i - 1)
//         );
//     }

//     function findTicketInfosFromNo(uint ticket_no)  public view returns(uint, uint){
//         for(uint lottery_no=0; lottery_no<lotteryNoCounter+1; lottery_no++) {
//             for (uint index=0; index<tickets[msg.sender][lottery_no].length; index++) {
//                 if(tickets[msg.sender][lottery_no][index].ticketNo == ticket_no){
//                     return(lottery_no,index);
//                 }
//             } 
//         }
//     }

//     function collectTicketRefund(uint256 ticket_number) public {
//         (uint lottery_no, uint index) = findTicketInfosFromNo(ticket_number);
//         balance[msg.sender] += amountReturn(lottery_no, index);
//     }

//     function getTotalLotteryMoneyCollected(uint256 lottery_no) public view returns(uint256 amount) {
//         return lotteryInfos[lottery_no].lotteryBalance;
//         }



//     //  function withdrawEther(uint256 amount) public {}

//     //  function buyTicket(bytes32 hash_rnd_number) public

//     // function checkIfTicketWon(uint256 lottery_no, uint256 ticket_no) public view returns(uint256 amount) {}

//     //function collectTicketRefund(uint256 ticket_number) public {}

//     // function getLastOwnedTicketNo(uint256 lottery_no) public view returns(uint256,uint8 status) {}

//     // function getIthOwnedTicketNo(uint256 i, uint256 lottery_no) public view returns(uint256 ticket_no, uint256 amount) {}

//     //function getIthWinningTicket(uint256 i, uint256 lottery_no) public view returns(uint256 ticket_no, uint256 amount) {}

//     // function getLotteryNos(uint256 unixtimeinweek) public view returns(uint256 lottery_no1, uint256 lottery_no2) {}

//     // function getTotalLotteryMoneyCollected(uint256 lottery_no) public view returns(uint256 amount) {}
// }

// // The lottery system consists of rounds that last for two weeks,
// // with a new round starting right after the previous round's purchase stage
// // is completed. During the purchase stage, lottery tickets are offered in
// // three forms: full tickets costing 8 finneys, half tickets costing 4 finneys, and quarter tickets costing 2 finneys.

// // To determine the three unique winner tickets for each round,
// // three random numbers are required, which are to be supplied by
// // the ticket purchasers during the purchase and submission stage of the
// // lottery round. The submission stage lasts for one week, after which the reveal stage starts.

// // During the reveal stage, the previously submitted random numbers are verified
// // for accuracy. If any random number is not submitted correctly, the chance of
// // winning is lost, and no ticket refund is made. The reveal stage also lasts for one week.

// // To generate secure random numbers, the details provided in the link given
// // in the instructions should be followed. It involves using a combination of
// // the current block's hash, the address of the person submitting the random
// // number, and a secret phrase to generate a hash that can be used as a random number.

// // In summary, the lottery system operates in rounds, with each round lasting two
// // weeks. During the first week of the round, ticket purchasers can buy full, half,
// // or quarter tickets and submit three random numbers. During the second week of the round,
// // the submitted random numbers are verified, and the winners are selected. To ensure secure
// // random number generation, the method described in the provided link should be followed.

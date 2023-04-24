// import "hardhat/console.sol";
// import "@openzeppelin/contracts/utils/Strings.sol";

// //https://www.youtube.com/watch?v=8ElPDw0laIo
// // lottery no => address => ticket

// contract DALottery {
//     mapping(address => User) users;
//     mapping(address => Ticket[]) tickets;
//     mapping(uint => Lottery) lotteries; // lotteryNo => Lottery

//     uint ticketNoCounter;
//     uint lotteryNoCounter;

//     struct Lottery {
//         uint lotteryNo;
//         uint startTimeStamp;
//         uint[] ticketsNosPurchased;
//     }

//     struct Ticket {
//         uint ticketNo;
//         uint ticketLotteryNo;
//         bytes32 threeNumberHash;
//         uint ticketTimeStamp;
//         uint ticketTier;
//         uint knownNo1;
//         uint knownNo2;
//         uint ticketIndex;
//         bool isRevealed;
//         uint givenRandNumber;
//     }

//     struct User {
//         uint balance;
//         uint[] ownedTicketsNos;
//     }

//     function depositEther(uint256 amount) public payable {
//         //require(msg.value == amount, "hata");
//         console.log(msg.value);
//         console.log(amount);
//     }

//     function startLotteryRound() public {
//         lotteryNoCounter += 1;
//         lotteries[lotteryNoCounter].lotteryNo = lotteryNoCounter;
//         lotteries[lotteryNoCounter].startTimeStamp = block.timestamp;
//     }

//     function lotteryCalculator(uint ticketIndex) public returns(uint) {
//         uint timeStamp = tickets[msg.sender][ticketIndex].ticketTimeStamp;
//         uint lotteryInitialTime = lotteries[1].startTimeStamp;
//         uint lotteryNo = ((timeStamp - lotteryInitialTime) / 604800)+1;
//         return lotteryNo;

//     }

//     function tierSelector(uint tier) public returns (uint) {
//         if (tier == 1) {
//             return 1;
//         } else if (tier == 2) {
//             return 2;
//         } else if (tier == 3) {
//             return 3;
//         } else {
//             return 0;
//         }
//     }

//     function threeNumbersHash(uint a, uint b, uint c) public returns (bytes32) {
//         string memory strSumAfter = string.concat(
//             Strings.toString(a),
//             Strings.toString(b),
//             Strings.toString(c)
//         );
//         return keccak256(abi.encodePacked(strSumAfter));
//     }

//     function buyTicket(bytes32 hash_rnd_number) public {
//         //you are supposed to send the hash from outside the smart contract
//         ticketNoCounter += 1;
//         uint willBeChanged = 1;
//         uint indexCounter = tickets[msg.sender].length + 1;
//         tickets[msg.sender][indexCounter].ticketNo = ticketNoCounter;
//         tickets[msg.sender][indexCounter].threeNumberHash = hash_rnd_number;
//         tickets[msg.sender][indexCounter].ticketTimeStamp = block.timestamp;
//         tickets[msg.sender][indexCounter].ticketIndex = indexCounter;
//         tickets[msg.sender][indexCounter].ticketLotteryNo = lotteryCalculator(indexCounter);

//         users[msg.sender].ownedTicketsNos.push(
//             tickets[msg.sender][indexCounter].ticketNo
//         );
//         lotteries[lotteryNoCounter].ticketsNosPurchased.push(
//             tickets[msg.sender][indexCounter].ticketNo
//         );
//     }

//     //  function withdrawEther(uint256 amount) public {}

//     //  function buyTicket(bytes32 hash_rnd_number) public

//     function revealRndNumber(uint256 ticket_no, uint256 rnd_number) public {
//         uint index;
//         for (uint i = 0; i < tickets[msg.sender].length; i++) {
//             if (tickets[msg.sender][i].ticketNo == ticket_no) {
//                 index = tickets[msg.sender][i].ticketIndex;
//             }
//         }
//         uint no1 = tickets[msg.sender][index].knownNo1;
//         uint no2 = tickets[msg.sender][index].knownNo2;
//         bytes32 hashedNos = tickets[msg.sender][index].threeNumberHash;
//         bytes32 hashChecker = keccak256(abi.encodePacked(no1, no2, rnd_number));
//         if (hashedNos == hashChecker) {
//             tickets[msg.sender][index].isRevealed = true;
//             tickets[msg.sender][index].givenRandNumber = rnd_number;
//         }
//     }

//     function ownTicket(uint a, uint b, uint c, uint tier) public {
//         bytes32 ticketHash = threeNumbersHash(a, b, c);
//         buyTicket(ticketHash);
//         uint index;
//         for (uint i = 0; i < tickets[msg.sender].length; i++) {
//             if (tickets[msg.sender][i].threeNumberHash == ticketHash) {
//                 index = tickets[msg.sender][i].ticketIndex;
//             }
//         }
//         tickets[msg.sender][index].knownNo1 = a;
//         tickets[msg.sender][index].knownNo2 = b;
//         tickets[msg.sender][index].ticketTier = tier;

//     }

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

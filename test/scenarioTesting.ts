import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
import { FinalLottery } from "../typechain-types";
import { Signer, providers, utils } from "ethers";
import BigNumber from 'bignumber.js';

describe("Lock", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.

  describe("Deployment", function () {
    let owner: SignerWithAddress;
    let accounts: SignerWithAddress[];
    let Lottery: FinalLottery;
    beforeEach(async () => {
      [owner, ...accounts] = await ethers.getSigners();
      const LotteryFactory = await ethers.getContractFactory("FinalLottery");
      Lottery = (await LotteryFactory.deploy()) as FinalLottery;
    });
    
    //test if the right lottery number is being calculated
    it("Scenario 1", async function () {

        //In our first scenario, we have 20 Users. Each buys a ticket and each deposits 1000 on their balance
        for (let i = 0; i < 20; i++) {
            let A = 1;
            await Lottery.connect(accounts[i]).depositEther({ value: 10000 });
            const userAddress = `${accounts[i].address}`; // Replace with the actual user address
            const providedNumber = i; // Replace with the actual provided number
    
            const types = ["address", "uint256"];
            const values = [userAddress, providedNumber];
    
            const hash = await ethers.utils.solidityKeccak256(types, values);
            
            // console.log("Hash:", hash);
            if (A == 1) {
              await Lottery.connect(accounts[i]).buyTicket(`${hash}`, 1);
              const Usericket: [BigNumber, BigNumber] = await Lottery.connect(accounts[i]).getIthOwnedTicketNo(1,1);
              console.log("Ticket number and status" ,Usericket);
              A = 2;
            } else if (A == 2) {
              await Lottery.connect(accounts[i]).buyTicket(`${hash}`, 2);
              const Usericket: [BigNumber, BigNumber] = await Lottery.connect(accounts[i]).getIthOwnedTicketNo(1,1);
              console.log("Ticket number and status" ,Usericket);
              A = 3;
            } else if (A == 3) {
              await Lottery.connect(accounts[i]).buyTicket(`${hash}`, 3);
              const Usericket: [BigNumber, BigNumber] = await Lottery.connect(accounts[i]).getIthOwnedTicketNo(1,1);
              console.log("Ticket number and status" ,Usericket);
              A = 1;
            }
          }

          //lets get the ticket number and its status if it has been revealed
          const User7Ticket: [BigNumber, BigNumber] = await Lottery.connect(accounts[6]).getIthOwnedTicketNo(1,1);
          console.log("User 7`s first Ticket number and status" ,User7Ticket);
          expect(User7Ticket[0]).to.be.eq(7);
          expect(User7Ticket[1]).to.be.eq(0);

          
          //user 11 might want to withdraw back again, since he started and bought a ticket for 80, the remaining should be 10000-80-500 = 9420
          await Lottery.connect(accounts[10]).withdrawEther(500);
          const afterwithdrawEther = await Lottery.connect(accounts[10]).getBalance();
          console.log("balance after user 11 withdraws 500", afterwithdrawEther);
          console.log("")
          expect(afterwithdrawEther).eq(9420);


          //User 13 wants to reveal his number, tries it on a number which is not belonging to him
          await expect(Lottery.connect(accounts[12]).revealRndNumber(10, 12)).to.be.revertedWith("You are not the owner of this ticket")
            

          //User 13 wants to reveal his number which belongs to him, but it is not revealing time yet
          await expect(Lottery.connect(accounts[12]).revealRndNumber(13, 12)).to.be.revertedWith("incorrect time to reveal")

          //let one week pass
          await time.increase(60*60*24*7 +10000);

          //User 13 wants to reveal his number which belongs to him
          await Lottery.connect(accounts[12]).revealRndNumber(13, 12);

          //lets reveal them all
          for (let i = 0; i < 20; i++) {
            
            if (i == 12) {
              //User 13 already had revealed, so we expect an revert
              await expect(Lottery.connect(accounts[i]).revealRndNumber(i +1, i)).to.be.revertedWith("Sorry, you have already revealed")
            }else {
              //reveal all the others
              await Lottery.connect(accounts[i]).revealRndNumber(i+1, i);
            }
          }

          //let every second account buy a second ticket in the second lottery round
          for (let i = 0; i < 20; i++) {
            await Lottery.connect(accounts[i]).depositEther({ value: 10000 });
            const userAddress = `${accounts[i].address}`; // Replace with the actual user address
            const providedNumber = i + 20; // Replace with the actual provided number
            console.log("provided", providedNumber);
            const types = ["address", "uint256"];
            const values = [userAddress, providedNumber];
            const hash = await ethers.utils.solidityKeccak256(types, values);
            await Lottery.connect(accounts[i]).buyTicket(`${hash}`, 2);
           
            const Usericket: [BigNumber, BigNumber] = await Lottery.connect(accounts[i]).getIthOwnedTicketNo(2,2);
            console.log("Ticket number and status" ,Usericket);
            i++;
          
            }

          //test, if getIthOwnedTicketNo function on user no. 4 gives back the right ticket number and it`s status
          const expectedOutputUser4: [number, number] = [5, 1];
          const actualoutputUser4 = await Lottery.connect(accounts[4]).getIthOwnedTicketNo(1,1)

          console.log("")
          console.log("User4`s first ticket in lottery round 1",actualoutputUser4);
          console.log("")
          expect(Number(actualoutputUser4[0]) == expectedOutputUser4[0] && Number(actualoutputUser4[1]) == expectedOutputUser4[1]);
          
        
          //test, if getIthOwnedTicketNo function on user no. 3 in Lottery 2 gives back the right ticket number and it`s status
          //we bought 20 tickets in the first round, 10 in the second round. Every second account, so the first, the third, the fith... has a second ticket.
          // Therefore user 3 should have a second ticket too, which is the 22th ticket
            const expectedOutputUser7: [number, number] = [22, 0];
            const actualoutputUser7 = await Lottery.connect(accounts[2]).getIthOwnedTicketNo(2,2)
            const myTicket: [BigNumber, BigNumber] =  await Lottery.connect(accounts[2]).getIthOwnedTicketNo(2,2);
            console.log("the stupid ticket: ", myTicket);
            console.log("")
            console.log("User13`s first ticket in lottery round 2",actualoutputUser7);
  
            expect(Number(actualoutputUser7[0])).to.be.eq(expectedOutputUser7[0]) 
            expect(Number(actualoutputUser7[1])).to.be.eq(expectedOutputUser7[1]);


          //lets say user 9 wants to see his last owned ticket in lottery nr 2
          const expectedOutputUser9: [number, number] = [24, 0];
          const actualoutputUser9 = await Lottery.connect(accounts[8]).getLastOwnedTicketNo(2);
        
          //expect(Number(actualoutputUser9[0])).to.be.eq(expectedOutputUser9[0]) 
          //expect(Number(actualoutputUser9[1])).to.be.eq(expectedOutputUser9[1]);
          
          for (let i = 0; i < 20; i++) {
            
            await Lottery.connect(accounts[i]).checkIfTicketWon(1,i+1);
          }

          for (let i = 0; i < 20; i++) {
            
            console.log("Prize:" , await Lottery.connect(accounts[i]).collectTicketPrize(1,i+1));
          }
    });


   });
});

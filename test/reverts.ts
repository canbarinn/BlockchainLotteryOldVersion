import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
import { FinalLottery } from "../typechain-types";
import { Signer, providers, utils } from "ethers";
import { keccak256 } from "ethers/lib/utils";

describe("Lock", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshxot that state,
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

    const WEEK_IN_SECS = 60*60*24*7;

 
    it("buyTicket reverts", async function () {
        // COMPLETED
      await Lottery.connect(accounts[1]).depositEther({ value: 1 * 10 ** 10 });
      await expect(Lottery.connect(accounts[1]).buyTicket("0x1364421c30895d0949d8f03614ad49766d67b19169eea8ec69551b7559a1539c", 3)).to.be.revertedWith("insufficient balance for quarter ticket");
      await Lottery.connect(accounts[1]).depositEther({ value: 1 * 10 ** 10 });
      await expect(Lottery.connect(accounts[1]).buyTicket("0x1364421c30895d0949d8f03614ad49766d67b19169eea8ec69551b7559a1539c", 2)).to.be.revertedWith("insufficient balance for half ticket");
      await Lottery.connect(accounts[1]).depositEther({ value: 3 * 10 ** 10 });
      await expect(Lottery.connect(accounts[1]).buyTicket("0x1364421c30895d0949d8f03614ad49766d67b19169eea8ec69551b7559a1539c", 1)).to.be.revertedWith("insufficient balance for full ticket");
    });

    it("revealRndNumber reverts", async function () {
        // COMPLETED
        const nonExistingTicketNumber = 1000;
        const incorrectNumber = 2

      await Lottery.connect(accounts[1]).depositEther({ value: 10 * 10 ** 10 });
      await Lottery.connect(accounts[1]).buyTicket("0x1364421c30895d0949d8f03614ad49766d67b19169eea8ec69551b7559a1539c", 2)
      await expect(Lottery.connect(accounts[1]).revealRndNumber(1,1)).to.be.revertedWith("incorrect time to reveal")
      await time.increase(60*60*24*7+1000)// increasing the time for one week in seconds
      await expect(Lottery.connect(accounts[1]).revealRndNumber(nonExistingTicketNumber,1)).to.be.revertedWith("There is no ticket with this number in the system")
      await expect(Lottery.connect(accounts[2]).revealRndNumber(1,1)).to.be.revertedWith("You are not the owner of this ticket")
      await expect(Lottery.connect(accounts[1]).revealRndNumber(1,incorrectNumber)).to.be.revertedWith("Incorrect number!")
      await Lottery.connect(accounts[1]).revealRndNumber(1,3)
      await expect(Lottery.connect(accounts[1]).revealRndNumber(1,3)).to.be.revertedWith("Sorry, you have already revealed")
    });

    it("collectTicketRefund reverts", async function () {

        const nonExistingTicketNumber = 1000;
        
        await Lottery.connect(accounts[1]).depositEther({ value: 10 * 10 ** 10 });
        await Lottery.connect(accounts[1]).buyTicket("0x1364421c30895d0949d8f03614ad49766d67b19169eea8ec69551b7559a1539c", 2)
      await expect(Lottery.connect(accounts[1]).collectTicketRefund(nonExistingTicketNumber)).to.be.revertedWith("There is no ticket with this number in the system")
      await expect(Lottery.connect(accounts[2]).collectTicketRefund(1)).to.be.revertedWith("You are not the owner of this ticket")
      await time.increase(60*60*24*7+1000)// increasing the time for one week in seconds
      await expect(Lottery.connect(accounts[1]).collectTicketRefund(1)).to.be.revertedWith("You cannot refund anymore")

    xit("getIthOwnedTicketNo and getLastOwnedTicketNo reverts", async function () {
      const existingTicket = 1;
      const nonExistingTicket = 5;
      const existingLotteryNumber = 1;
      const nonExistingLotteryNumber = 2;
      await expect(Lottery.connect(accounts[1]).getLastOwnedTicketNo(1)).to.be.revertedWith("You don`t have any tickets");
      await Lottery.connect(accounts[1]).depositEther({ value: 10 * 10 ** 10 });
      await Lottery.connect(accounts[1]).buyTicket("0x1364421c30895d0949d8f03614ad49766d67b19169eea8ec69551b7559a1539c", 2);
      await expect(Lottery.connect(accounts[1]).getIthOwnedTicketNo(existingTicket, nonExistingLotteryNumber)).to.be.revertedWith("Lottery has not started yet");
      await expect(Lottery.connect(accounts[1]).getIthOwnedTicketNo(nonExistingTicket, existingLotteryNumber)).to.be.revertedWith("You don`t have that many tickets");
    });

    xit("checkIfTicketWon and pickWinner reverts", async function () {
      // COMPLETED
      const existingTicket = 1;
      const nonExistingTicket = 5;
      const existingLotteryNumber = 1;
      const nonExistingLotteryNumber = 2;
      await expect(Lottery.connect(accounts[1]).checkIfTicketWon(nonExistingLotteryNumber,existingTicket)).to.be.revertedWith("Lottery you are requesting has not started yet!");
      await expect(Lottery.connect(accounts[1]).checkIfTicketWon(existingLotteryNumber,nonExistingTicket)).to.be.revertedWith("The ticket you are requesting does not exist");
      await Lottery.connect(accounts[1]).depositEther({ value: 10 * 10 ** 10 });
      await Lottery.connect(accounts[1]).buyTicket("0x1364421c30895d0949d8f03614ad49766d67b19169eea8ec69551b7559a1539c", 2);
      await expect(Lottery.connect(accounts[3]).checkIfTicketWon(existingLotteryNumber, existingTicket)).to.be.revertedWith("You are not the owner!");
      await time.increase(WEEK_IN_SECS + 1000);
      await expect(Lottery.connect(accounts[1]).checkIfTicketWon(existingLotteryNumber, existingTicket)).to.be.revertedWith("You have not revealed the random number yet!");
      await Lottery.connect(accounts[1]).revealRndNumber(1, 3)
      await expect(Lottery.connect(accounts[1]).checkIfTicketWon(existingLotteryNumber, existingTicket)).to.be.revertedWith("There is not enough ticket for picking winners, lottery is cancelled!");
      await expect(Lottery.connect(accounts[1]).checkIfTicketWon(nonExistingLotteryNumber, existingTicket)).to.be.revertedWith("There is not enough ticket for picking winners, lottery is cancelled!");

    });
    xit("calculateSinglePriceValue reverts", async function () {
      // COMPLETED
      const existingThPrice = 1;
      const nonExistingThPrice = 5;
      const existingLotteryNumber = 1;
      const nonExistingLotteryNumber = 2;
      await Lottery.connect(accounts[1]).depositEther({ value: 10 * 10 ** 10 });
      await Lottery.connect(accounts[1]).buyTicket("0x1364421c30895d0949d8f03614ad49766d67b19169eea8ec69551b7559a1539c", 2);
      await expect(Lottery.connect(accounts[1]).calculateSinglePriceValue(nonExistingThPrice, existingLotteryNumber)).to.be.revertedWith("Invalid price type!");
      await expect(Lottery.connect(accounts[1]).calculateSinglePriceValue(existingThPrice, existingLotteryNumber)).to.be.revertedWith("There is no winning ticket selected yet!");
      await expect(Lottery.connect(accounts[1]).calculateSinglePriceValue(existingThPrice, nonExistingLotteryNumber)).to.be.revertedWith("Invalid lottery number!");
   

    });

    it("getIthWinningTicket reverts", async function () {
      // COMPLETED
      const existingIthWinningTicket = 1;
      const nonExistingIthWinningTicket = 5;
      const existingLotteryNumber = 1;
      const nonExistingLotteryNumber = 6;
      await Lottery.connect(accounts[1]).depositEther({ value: 10 * 10 ** 10 });
      await Lottery.connect(accounts[1]).buyTicket("0x1364421c30895d0949d8f03614ad49766d67b19169eea8ec69551b7559a1539c", 2);
      await Lottery.connect(accounts[1]).buyTicket("0x1364421c30895d0949d8f03614ad49766d67b19169eea8ec69551b7559a1539c", 2);
      await Lottery.connect(accounts[1]).buyTicket("0x1364421c30895d0949d8f03614ad49766d67b19169eea8ec69551b7559a1539c", 2);
      await Lottery.connect(accounts[1]).buyTicket("0x1364421c30895d0949d8f03614ad49766d67b19169eea8ec69551b7559a1539c", 2);
      await Lottery.connect(accounts[1]).buyTicket("0x1364421c30895d0949d8f03614ad49766d67b19169eea8ec69551b7559a1539c", 2);

      await time.increase(WEEK_IN_SECS + 1000);
      await time.increase(WEEK_IN_SECS + 1000);

      await expect(Lottery.connect(accounts[1]).getIthWinningTicket(existingIthWinningTicket, nonExistingLotteryNumber)).to.be.revertedWith("Lottery you are requesting has not started yet!");
      await expect(Lottery.connect(accounts[1]).getIthWinningTicket(nonExistingIthWinningTicket, existingLotteryNumber)).to.be.revertedWith("Invalid number of winning ticket!");
   

    });
    it("collectTicketPrize reverts", async function () {
      // COMPLETED
      const existingIthWinningTicket = 1;
      const nonExistingIthWinningTicket = 5;
      const existingLotteryNumber = 1;
      const nonExistingLotteryNumber = 6;
      await Lottery.connect(accounts[1]).depositEther({ value: 10 * 10 ** 10 });
      await Lottery.connect(accounts[1]).buyTicket("0x1364421c30895d0949d8f03614ad49766d67b19169eea8ec69551b7559a1539c", 2);
      await Lottery.connect(accounts[1]).buyTicket("0x1364421c30895d0949d8f03614ad49766d67b19169eea8ec69551b7559a1539c", 2);
      await Lottery.connect(accounts[1]).buyTicket("0x1364421c30895d0949d8f03614ad49766d67b19169eea8ec69551b7559a1539c", 2);
      await Lottery.connect(accounts[1]).buyTicket("0x1364421c30895d0949d8f03614ad49766d67b19169eea8ec69551b7559a1539c", 2);
      await Lottery.connect(accounts[1]).buyTicket("0x1364421c30895d0949d8f03614ad49766d67b19169eea8ec69551b7559a1539c", 2);

      await time.increase(WEEK_IN_SECS + 1000);
      await time.increase(WEEK_IN_SECS + 1000);

      await expect(Lottery.connect(accounts[1]).getIthWinningTicket(existingIthWinningTicket, nonExistingLotteryNumber)).to.be.revertedWith("Lottery you are requesting has not started yet!");
      await expect(Lottery.connect(accounts[1]).getIthWinningTicket(nonExistingIthWinningTicket, existingLotteryNumber)).to.be.revertedWith("Invalid number of winning ticket!");
   

    });

  });
});
});

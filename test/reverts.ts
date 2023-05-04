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

});

    it("Should set the right unlockTime", async function () {
        const number = 3;
        const hash = await ethers.utils.solidityKeccak256(["address","uint"], [accounts[1].address, number]);
        console.log(hash);
        const hash2 = await Lottery.connect(accounts[1]).hashOfANum(3);
        console.log(hash2);
      });

    });

 




   
});

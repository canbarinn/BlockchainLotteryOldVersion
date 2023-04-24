import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
import { DALottery } from "../typechain-types";
import { Signer } from "ethers";

describe("Lock", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.

  describe("Deployment", function () {
    let owner: SignerWithAddress;
    let accounts: SignerWithAddress[];
    let Lottery: DALottery;
    beforeEach(async () => {
      [owner, ...accounts] = await ethers.getSigners();
      const LotteryFactory = await ethers.getContractFactory("DALottery");
      Lottery = (await LotteryFactory.deploy()) as DALottery;
    });

    xit("Should set the right unlockTime", async function () {
      console.log("owner balance1: ", await ethers.provider.getBalance(owner.address));
      console.log("contract balance1: ", await ethers.provider.getBalance(Lottery.address));
      await Lottery.depositEther(1, { value: 2 });
      console.log("owner balance: ", await ethers.provider.getBalance(owner.address));
      console.log("contract balance: ", await ethers.provider.getBalance(Lottery.address));
    });
    xit("number string trials", async function () {
      const user = await Lottery.connect(accounts[0]);
      await user.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a");
      await user.buyTicket("0xef2d127de37b942baad06145e54b0c619a1f22327b2ebbcfbec78f5564afe39d");
      const ticket = await user.getIthOwnedTicketNo(0, 1);
      const ticket2 = await user.getIthOwnedTicketNo(1, 1);
      await user.setLotteryNo(1);
      await user.buyTicket("0xf0b5c2c2211c8d67ed15e75e656c7862d086e9245420892a7de62cd9ec582a06");
      const ticket3 = await user.getIthOwnedTicketNo(0, 1);
      console.log(ticket);
      console.log(ticket2);
      console.log(ticket3);
    });
    xit("number string trials", async function () {
      const user = await Lottery.connect(accounts[0]);
      await user.buyTicket("0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6"); //hash of 1
      await user.buyTicket("0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6"); //hash of 1
      await user.buyTicket("0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6"); //hash of 1
      const ticket = await user.getIthOwnedTicketNo(0, 1);
      console.log("before reveal", ticket);
      const tx = await user.revealRndNumber(1, 1);
      const ticket3 = await user.getIthOwnedTicketNo(0, 1);

      // expect(await ticket4).to.emit(Lottery, "RandomNumber").withArgs("0x53c234e5e8472b6ac51c1ae1cab3fe06fad053beb8ebfd8977b010655bfdd3c3")
      const receipt = await tx.wait();
      console.log(receipt.events[0].args.hash);
      console.log("after reveal", ticket3);

      const lastOwnTicket = await user.getLastOwnedTicketNo(1);
      console.log(lastOwnTicket);
    });
    xit("number string trials", async function () {
      const user = await Lottery.connect(accounts[0]);

      await user.lotteryStarter();
      await user.buyTicket("0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6"); //hash of 1
      const info1 = await user.getLottery(1);
      console.log("first", info1);

      await time.increase(60 * 60 * 60);
      await user.setLotteryNo(2);
      await user.lotteryStarter();
      await user.buyTicket("0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6"); //hash of 1
      await user.buyTicket("0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6"); //hash of 1
      const timestamp = (await ethers.provider.getBlock(await ethers.provider.getBlockNumber())).timestamp;
      const lotteryNos1 = await user.getLotteryNos(timestamp);
      const receipt = await lotteryNos1.wait();
      console.log("lottery bnilgileri1", receipt.events[0].args);
      const info2 = await user.getLottery(2);
      console.log("second", info2);

      await time.increase(60 * 60 * 24 * 7 * 5);
      await user.setLotteryNo(3);
      await user.lotteryStarter();
      await user.buyTicket("0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6"); //hash of 1
      await user.buyTicket("0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6"); //hash of 1
      await user.buyTicket("0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6"); //hash of 1
      await user.buyTicket("0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6"); //hash of 1
      const timestamp2 = (await ethers.provider.getBlock(await ethers.provider.getBlockNumber())).timestamp;
      const lotteryNos2 = await user.getLotteryNos(timestamp2);
      const info3 = await user.getLottery(3);
      console.log("third", info3);

      const receipt2 = await lotteryNos2.wait();
      console.log("lottery bilgileri2", receipt2.events[0].args);
    });
    it("Should set the right unlockTime", async function () {
      const user = await Lottery.connect(accounts[0]);
      console.log("user balance1: ", await ethers.provider.getBalance(user.address));
      console.log("contract balance1: ", await ethers.provider.getBalance(Lottery.address));
      await user.depositEther( ethers.utils.parseEther("100"),{ value:  ethers.utils.parseEther("100") });
      console.log("user balance: ", await ethers.provider.getBalance(user.address));
      console.log("contract balance: ", await ethers.provider.getBalance(Lottery.address));
      await user.lotteryStarter();
      const balance = await user.getBalance();
      console.log("balance", balance);
      await user.makeTicketPayment("0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6", ethers.utils.parseEther("2")); //hash of 1
      await user.makeTicketPayment("0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6", ethers.utils.parseEther("4")); //hash of 1
      const ticket = await user.getLastOwnedTicketNo(1);
      const balance2 = await user.getTicket(1);

      console.log("tickettttt", balance2)
      console.log("withdraw before ", await user.getBalance());
      await user.withdrawEther(ethers.utils.parseEther("11"));
      console.log("withdraw after", await user.getBalance());
    });
  });
});

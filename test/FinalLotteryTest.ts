import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
import { FinalLottery } from "../typechain-types";
import { Signer } from "ethers";

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

    xit("Should set the right unlockTime", async function () {
      console.log("owner balance1: ", await ethers.provider.getBalance(owner.address));
      console.log("contract balance1: ", await ethers.provider.getBalance(Lottery.address));
      await Lottery.depositEther();
      console.log("owner balance: ", await ethers.provider.getBalance(owner.address));
      console.log("contract balance: ", await ethers.provider.getBalance(Lottery.address));
    });

    it("We can buy ticket", async function () {
      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 2);
      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 3);
      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 1);
      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 3);
      
      const amount = await Lottery.getLotteryMoneyCollected(1);
      console.log(amount)
      await time.increase(60*60*24*7 + 10000)
      
      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 2);
      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 3);
      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 1);
      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 1);
      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 3);
      const amount2 = await Lottery.getLotteryMoneyCollected(2);
      console.log(amount2)
      // await expect(await tx).to.emit(Lottery, "AmountOfPrize").withArgs("prizename",0);
      
      await time.increase(60*60*24*7 + 10000)
      
      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 2);
      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 3);
      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 1);
      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 1);
      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 3);

      const winningTicket = await Lottery.getIthWinningTicket(1,1)
      console.log(winningTicket)
      await expect(Lottery.getIthWinningTicket(1,1))
      .to.emit(Lottery, 'WinningTicket')
      .withArgs(4, 1);

    });
  });
});

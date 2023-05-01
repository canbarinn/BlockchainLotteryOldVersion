import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
import { FinalLottery } from "../typechain-types";
import { Signer, providers, utils } from "ethers";

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
      
      await Lottery.depositEther( { value: 100 * 10**12 });
   
      const mon = await Lottery.getMoneyCollected();
      console.log("money collected",mon)

      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 1);
      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 1);
      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 1);
      await Lottery.buyTicket("0x9abc19dab27cd34d3fcdee5db435600ca1a7c8f6e33e8201215db86aa4b96795", 1);
      await Lottery.buyTicket("0x13600b294191fc92924bb3ce4b969c1e7e2bab8f4c93c3fc6d0a51733df3c060", 1);
      await Lottery.buyTicket("0xe455bf8ea6e7463a1046a0b52804526e119b4bf5136279614e0b1e8e296a4e2d", 1);
      await Lottery.buyTicket("0x55b33ce565978561a1247ccce87003f6ddd588298f404e747ed025a86773536d", 1);
      
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
      
      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 1);
      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 1);
      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 1);
      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 1);
      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 1);
      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 1);
      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 1);
      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 1);
      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 1);
      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 1);
      await Lottery.buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 3);

      const winningTicket = await Lottery.collectTicketPrize(1,1);
      // console.log("ticket1",winningTicket)
      const winningTicket2 = await Lottery.collectTicketPrize(1,2);
      // console.log("ticket2",winningTicket2)
      const winningTicket3 = await Lottery.collectTicketPrize(1,3);
      // console.log("ticket3",winningTicket3)
      const winningTicket4 = await Lottery.collectTicketPrize(1,4);
      // console.log("ticket4",winningTicket4)
      const winningTicket5 = await Lottery.collectTicketPrize(1,5);
      // console.log("ticket5",winningTicket5)
      const ams = await Lottery.getTotalPrizeMoney(1)
      console.log("prize money",ams)

      const balance = await Lottery.getBalance();
    
      console.log(balance)
      
      const price = await Lottery.getTicketPrize(1,1);
      console.log("ticket price",price)
      
      const money = await Lottery.getLotteryMoneyCollected(1);
      console.log(money);

      
      const balance2 = await Lottery.getBalance();
    
      console.log("balance after collection",balance2)

      const mon2 = await Lottery.getMoneyCollected();
      console.log("money collected",mon2)

      // await expect(await winningTicket).to.emit(Lottery, "Winner").withArgs(2,1);


    });
  });
});

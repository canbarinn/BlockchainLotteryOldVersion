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
    xit("lotteryNoCalculator", async function () {
    await time.increase(60*60*24*7 * 3 +10000);
    expect(await Lottery.lotteryNoCalculator()).to.be.eq(4);
    });


    xit("depostiEther", async function () {
    
      //first we log the amount of money at account number 1
      const  firstBalance = await Lottery.connect(accounts[1]).getBalance();
      console.log("first account balance:", await Lottery.connect(accounts[1]).getBalance());

      //then we add 100 to the balance
      await Lottery.connect(accounts[1]).depositEther( { value: 10**11});

      //this is the balance after we deposit
      const afterwardsBalance = await Lottery.connect(accounts[1]).getBalance();
      console.log("first account afterwards we deposit:", await Lottery.connect(accounts[1]).getBalance());
      
      //we compute difference
      const difference = afterwardsBalance.sub(firstBalance); 
      console.log("difference", difference);
      expect(difference).eq(10**11);
      
      //we withdraw 100 ether back again
      await Lottery.connect(accounts[1]).withdrawEther(10**11);
      const lastBalance = await Lottery.connect(accounts[1]).getBalance();
      
      //We test if it's zero again
      expect(lastBalance).eq(0);
      
    });
      
    xit("withdrawEther", async function () {
      const  beforeDeposit = await Lottery.connect(accounts[2]).getBalance();
      console.log("balance before a deposit", beforeDeposit);

      await Lottery.connect(accounts[2]).depositEther( { value: 10 ** 11});

      const  afterDeposit = await Lottery.connect(accounts[2]).getBalance();
      console.log("balance after the deposit", afterDeposit);

      await Lottery.connect(accounts[2]).withdrawEther(5 ** 11);
      
      const afterwithdrawEther = await Lottery.connect(accounts[2]).getBalance();
      console.log("balance after user withdraws", afterwithdrawEther);
      //10^11 - 5^11 = 99951171875
      expect(afterwithdrawEther).eq(99951171875);
    });


    xit("buyTicket", async function () {
      await Lottery.connect(accounts[3]).depositEther( { value: 10 ** 11});
      await Lottery.connect(accounts[3]).buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 1);
      const  afterfirstticket = await Lottery.connect(accounts[3]).getBalance();
      console.log("balance after first buy", afterfirstticket);
      expect(afterfirstticket).eq(99999999920);

      await Lottery.connect(accounts[3]).buyTicket("0x9abc19dab27cd34d3fcdee5db435600ca1a7c8f6e33e8201215db86aa4b96795", 1);
      const  aftersecondticket = await Lottery.connect(accounts[3]).getBalance();
      console.log("balance after second buy", aftersecondticket);
      expect(aftersecondticket).eq(99999999840);

      await Lottery.connect(accounts[3]).buyTicket("0xe455bf8ea6e7463a1046a0b52804526e119b4bf5136279614e0b1e8e296a4e2d", 1);
      const afterthirdticket = await Lottery.connect(accounts[3]).getBalance();
      console.log("balance after third buy", afterthirdticket);
      expect(afterthirdticket).eq(99999999760);

      const NosInLottery = await Lottery.ticketNosInLotteryGetter(1);

      expect(NosInLottery[0]).eq(1);
      console.log("first Ticket:", NosInLottery[0])

      expect(NosInLottery[2]).eq(3);
      console.log("third Ticket:", NosInLottery[2])

      const moneyInLotteryNoOne = await Lottery.getLotteryMoneyCollected(1);
      
      //We bought 3 Tickets for 80 each, so there must be 240 in Lottery No 1
      expect(moneyInLotteryNoOne).eq(240);
      console.log("Money Collected in Lottery Nr. 1", moneyInLotteryNoOne);
    });



    xit("collectTicketRefund", async function () {
        await Lottery.connect(accounts[4]).depositEther( { value: 10000});

        await Lottery.connect(accounts[4]).buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 1);
        await Lottery.connect(accounts[4]).buyTicket("0x9abc19dab27cd34d3fcdee5db435600ca1a7c8f6e33e8201215db86aa4b96795", 1);
        await Lottery.connect(accounts[4]).buyTicket("0xe455bf8ea6e7463a1046a0b52804526e119b4bf5136279614e0b1e8e296a4e2d", 1);
        
        const  ownersbalance  = await Lottery.connect(accounts[4]).getBalance();
        console.log("Owners balance:", ownersbalance);
        
        const moneyInLotteryNoOnee = await Lottery.getLotteryMoneyCollected(1);
        console.log("Money Collected in Lottery Nr. 1 after three tickets have been bought", moneyInLotteryNoOnee);


        const totalLottaryBalance = await Lottery.getMoneyCollected();
        console.log("total lottery balance after three tickets have been bought", totalLottaryBalance);

        // we refund the third ticket

        await Lottery.connect(accounts[4]).collectTicketRefund(3);

        const  ownersbalanceafter  = await Lottery.connect(accounts[4]).getBalance();
        console.log("Owners balance after refund:", ownersbalanceafter);


        const totalLottaryBalance1 = await Lottery.getMoneyCollected();
        console.log("total lottery balance after refund", totalLottaryBalance1);

        const shit = await Lottery.getLotteryMoneyCollected(1);
        console.log("Money Collected in Lottery Nr. 1 after refund", shit);


        //We print the attribute of the ticket
        console.log("TicketInfo",await  Lottery.connect(accounts[4]).getTicketInfos(3));
        const myTuple: [string, BigNumber, BigNumber,string, number, boolean, string] = await Lottery.connect(accounts[4]).getTicketInfos(3);
        
        //We bought three tickets for 240, we withdraw the third ticket, then there should be 160 left
        const moneyInLotteryNoOne = await Lottery.getLotteryMoneyCollected(1);
        expect(moneyInLotteryNoOne).eq(160);

        //we expect the active status to be false since the the ticket is withdrawn and not avaialbe anymore
        expect( myTuple[5]).eq(false);
        
    });

    xit("getIthOwnedTicketNo", async function () {

        await Lottery.connect(accounts[5]).depositEther( { value: 10000});

        await Lottery.connect(accounts[5]).buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 1);
        await Lottery.connect(accounts[5]).buyTicket("0x9abc19dab27cd34d3fcdee5db435600ca1a7c8f6e33e8201215db86aa4b96795", 1);
        await Lottery.connect(accounts[5]).buyTicket("0xe455bf8ea6e7463a1046a0b52804526e119b4bf5136279614e0b1e8e296a4e2d", 1);
      
        
        const myTicket: [BigNumber, BigNumber] =  await Lottery.connect(accounts[5]).getIthOwnedTicketNo(2,1);
        console.log(myTicket);
        expect(myTicket[0]).eq(2);
        expect(myTicket[1]).eq(0);
    });

    xit("getLastOwnedTicketNo", async function () {
        await Lottery.connect(accounts[6]).depositEther( { value: 100 * 10 ** 10});

        await Lottery.connect(accounts[6]).buyTicket("0x4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", 2);
        await Lottery.connect(accounts[6]).buyTicket("0x9abc19dab27cd34d3fcdee5db435600ca1a7c8f6e33e8201215db86aa4b96795", 2);
        await Lottery.connect(accounts[6]).buyTicket("0xe455bf8ea6e7463a1046a0b52804526e119b4bf5136279614e0b1e8e296a4e2d", 2);
        await Lottery.connect(accounts[6]).buyTicket("0x55b33ce565978561a1247ccce87003f6ddd588298f404e747ed025a86773536d", 2);


        const lastTicket: [BigNumber, BigNumber] = await Lottery.connect(accounts[6]).getLastOwnedTicketNo(1);
        expect(lastTicket[0]).eq(4);
        expect(lastTicket[1]).eq(0);
        
    });
    it("calculateSinglePriceValue", async function () {
      await Lottery.connect(accounts[6]).depositEther( { value: 300 * 10 ** 10});

      await Lottery.connect(accounts[6]).buyTicket("0x23be5b597bb2efbf6d693749acabd6f758f688025cc6ae14cc2a557d7790eeab", 2);
      await Lottery.connect(accounts[6]).buyTicket("0x23be5b597bb2efbf6d693749acabd6f758f688025cc6ae14cc2a557d7790eeab", 2);
      await Lottery.connect(accounts[6]).buyTicket("0x23be5b597bb2efbf6d693749acabd6f758f688025cc6ae14cc2a557d7790eeab", 2);
      await Lottery.connect(accounts[6]).buyTicket("0x23be5b597bb2efbf6d693749acabd6f758f688025cc6ae14cc2a557d7790eeab", 2);
      await Lottery.connect(accounts[6]).buyTicket("0x23be5b597bb2efbf6d693749acabd6f758f688025cc6ae14cc2a557d7790eeab", 2);
      await Lottery.connect(accounts[6]).buyTicket("0x23be5b597bb2efbf6d693749acabd6f758f688025cc6ae14cc2a557d7790eeab", 2);
      await Lottery.connect(accounts[6]).buyTicket("0x23be5b597bb2efbf6d693749acabd6f758f688025cc6ae14cc2a557d7790eeab", 2);
      //
      const NosInLottery = await Lottery.ticketNosInLotteryGetter(1);
      console.log(NosInLottery);

      await time.increase(60*60*24*7 + 1000);
      await Lottery.connect(accounts[6]).revealRndNumber(1, 3);
      await Lottery.connect(accounts[6]).revealRndNumber(2, 3);
      await Lottery.connect(accounts[6]).revealRndNumber(3, 3);
      await Lottery.connect(accounts[6]).revealRndNumber(4, 3);
      await Lottery.connect(accounts[6]).revealRndNumber(5, 3);
      await Lottery.connect(accounts[6]).revealRndNumber(6, 3);
      await Lottery.connect(accounts[6]).revealRndNumber(7, 3);
      await time.increase(60*60*24*7 *2 + 1000);

      const myTuple: [string, BigNumber, BigNumber,string, number, boolean, string] = await Lottery.connect(accounts[6]).getTicketInfos(1);
      console.log(myTuple);
      await Lottery.connect(accounts[6]).checkIfTicketWon(1,1);
      


  });

  xit("Testrsgergrdgb", async function () {
  const number = 3;
      const hash = await ethers.utils.solidityKeccak256(["address","uint"], [accounts[6].address,number]);
      console.log(hash);
      const hash2 = await Lottery.connect(accounts[6]).hashOfANum(3);
      console.log(hash2);
});});
});
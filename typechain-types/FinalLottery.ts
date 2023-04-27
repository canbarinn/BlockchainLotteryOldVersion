/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import type {
  BaseContract,
  BigNumber,
  BigNumberish,
  BytesLike,
  CallOverrides,
  ContractTransaction,
  Overrides,
  PayableOverrides,
  PopulatedTransaction,
  Signer,
  utils,
} from "ethers";
import type {
  FunctionFragment,
  Result,
  EventFragment,
} from "@ethersproject/abi";
import type { Listener, Provider } from "@ethersproject/providers";
import type {
  TypedEventFilter,
  TypedEvent,
  TypedListener,
  OnEvent,
  PromiseOrValue,
} from "./common";

export interface FinalLotteryInterface extends utils.Interface {
  functions: {
    "balance(address)": FunctionFragment;
    "buyTicket(bytes32,int256)": FunctionFragment;
    "collectTicketRefund(uint256)": FunctionFragment;
    "depositEther()": FunctionFragment;
    "findTicketInfosFromNo(uint256)": FunctionFragment;
    "getLastOwnedTicketNo(uint256)": FunctionFragment;
    "getTicketInfo(uint256)": FunctionFragment;
    "lotteryNoCalculator()": FunctionFragment;
    "withdrawEther(uint256)": FunctionFragment;
  };

  getFunction(
    nameOrSignatureOrTopic:
      | "balance"
      | "buyTicket"
      | "collectTicketRefund"
      | "depositEther"
      | "findTicketInfosFromNo"
      | "getLastOwnedTicketNo"
      | "getTicketInfo"
      | "lotteryNoCalculator"
      | "withdrawEther"
  ): FunctionFragment;

  encodeFunctionData(
    functionFragment: "balance",
    values: [PromiseOrValue<string>]
  ): string;
  encodeFunctionData(
    functionFragment: "buyTicket",
    values: [PromiseOrValue<BytesLike>, PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "collectTicketRefund",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "depositEther",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "findTicketInfosFromNo",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "getLastOwnedTicketNo",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "getTicketInfo",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "lotteryNoCalculator",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "withdrawEther",
    values: [PromiseOrValue<BigNumberish>]
  ): string;

  decodeFunctionResult(functionFragment: "balance", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "buyTicket", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "collectTicketRefund",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "depositEther",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "findTicketInfosFromNo",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getLastOwnedTicketNo",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getTicketInfo",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "lotteryNoCalculator",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "withdrawEther",
    data: BytesLike
  ): Result;

  events: {
    "TicketInfo(uint256,uint256,bytes32,uint256,uint8,bool,uint8)": EventFragment;
  };

  getEvent(nameOrSignatureOrTopic: "TicketInfo"): EventFragment;
}

export interface TicketInfoEventObject {
  ticketNo: BigNumber;
  lotteryNo: BigNumber;
  ticketHash: string;
  ticketTimestamp: BigNumber;
  status: number;
  active: boolean;
  ticketTier: number;
}
export type TicketInfoEvent = TypedEvent<
  [BigNumber, BigNumber, string, BigNumber, number, boolean, number],
  TicketInfoEventObject
>;

export type TicketInfoEventFilter = TypedEventFilter<TicketInfoEvent>;

export interface FinalLottery extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: FinalLotteryInterface;

  queryFilter<TEvent extends TypedEvent>(
    event: TypedEventFilter<TEvent>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TEvent>>;

  listeners<TEvent extends TypedEvent>(
    eventFilter?: TypedEventFilter<TEvent>
  ): Array<TypedListener<TEvent>>;
  listeners(eventName?: string): Array<Listener>;
  removeAllListeners<TEvent extends TypedEvent>(
    eventFilter: TypedEventFilter<TEvent>
  ): this;
  removeAllListeners(eventName?: string): this;
  off: OnEvent<this>;
  on: OnEvent<this>;
  once: OnEvent<this>;
  removeListener: OnEvent<this>;

  functions: {
    balance(
      arg0: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    buyTicket(
      hash_rnd_number: PromiseOrValue<BytesLike>,
      tier: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    collectTicketRefund(
      ticket_no: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    depositEther(
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    findTicketInfosFromNo(
      ticket_no: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    getLastOwnedTicketNo(
      lottery_no: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[BigNumber, number]>;

    getTicketInfo(
      ticket_number: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    lotteryNoCalculator(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    withdrawEther(
      amount: PromiseOrValue<BigNumberish>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;
  };

  balance(
    arg0: PromiseOrValue<string>,
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  buyTicket(
    hash_rnd_number: PromiseOrValue<BytesLike>,
    tier: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  collectTicketRefund(
    ticket_no: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  depositEther(
    overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  findTicketInfosFromNo(
    ticket_no: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  getLastOwnedTicketNo(
    lottery_no: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<[BigNumber, number]>;

  getTicketInfo(
    ticket_number: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  lotteryNoCalculator(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  withdrawEther(
    amount: PromiseOrValue<BigNumberish>,
    overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  callStatic: {
    balance(
      arg0: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    buyTicket(
      hash_rnd_number: PromiseOrValue<BytesLike>,
      tier: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    collectTicketRefund(
      ticket_no: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    depositEther(overrides?: CallOverrides): Promise<void>;

    findTicketInfosFromNo(
      ticket_no: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[BigNumber, BigNumber]>;

    getLastOwnedTicketNo(
      lottery_no: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[BigNumber, number]>;

    getTicketInfo(
      ticket_number: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    lotteryNoCalculator(overrides?: CallOverrides): Promise<BigNumber>;

    withdrawEther(
      amount: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;
  };

  filters: {
    "TicketInfo(uint256,uint256,bytes32,uint256,uint8,bool,uint8)"(
      ticketNo?: null,
      lotteryNo?: null,
      ticketHash?: null,
      ticketTimestamp?: null,
      status?: null,
      active?: null,
      ticketTier?: null
    ): TicketInfoEventFilter;
    TicketInfo(
      ticketNo?: null,
      lotteryNo?: null,
      ticketHash?: null,
      ticketTimestamp?: null,
      status?: null,
      active?: null,
      ticketTier?: null
    ): TicketInfoEventFilter;
  };

  estimateGas: {
    balance(
      arg0: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    buyTicket(
      hash_rnd_number: PromiseOrValue<BytesLike>,
      tier: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    collectTicketRefund(
      ticket_no: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    depositEther(
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    findTicketInfosFromNo(
      ticket_no: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    getLastOwnedTicketNo(
      lottery_no: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getTicketInfo(
      ticket_number: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    lotteryNoCalculator(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    withdrawEther(
      amount: PromiseOrValue<BigNumberish>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    balance(
      arg0: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    buyTicket(
      hash_rnd_number: PromiseOrValue<BytesLike>,
      tier: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    collectTicketRefund(
      ticket_no: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    depositEther(
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    findTicketInfosFromNo(
      ticket_no: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    getLastOwnedTicketNo(
      lottery_no: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getTicketInfo(
      ticket_number: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    lotteryNoCalculator(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    withdrawEther(
      amount: PromiseOrValue<BigNumberish>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;
  };
}

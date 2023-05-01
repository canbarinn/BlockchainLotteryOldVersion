/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PromiseOrValue } from "../common";
import type { FinalLottery, FinalLotteryInterface } from "../FinalLottery";

const _abi = [
  {
    inputs: [],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "string",
        name: "prizeName",
        type: "string",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "prize",
        type: "uint256",
      },
    ],
    name: "AmountOfPrize",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "ticketNo",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "lotteryNo",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "bytes32",
        name: "ticketHash",
        type: "bytes32",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "ticketTimestamp",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint8",
        name: "status",
        type: "uint8",
      },
      {
        indexed: false,
        internalType: "bool",
        name: "active",
        type: "bool",
      },
      {
        indexed: false,
        internalType: "enum FinalLottery.TicketTier",
        name: "ticketTier",
        type: "uint8",
      },
    ],
    name: "TicketInfo",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "ticketNo",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "WinningTicket",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "balance",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes32",
        name: "hash_rnd_number",
        type: "bytes32",
      },
      {
        internalType: "int256",
        name: "tier",
        type: "int256",
      },
    ],
    name: "buyTicket",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "thPrice",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "lottery_no",
        type: "uint256",
      },
    ],
    name: "calculateSinglePriceValue",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "lottery_no",
        type: "uint256",
      },
    ],
    name: "calculateTotalPriceValue",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "lottery_no",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "ticket_no",
        type: "uint256",
      },
    ],
    name: "checkIfTicketWon",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "lottery_no",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "ticket_no",
        type: "uint256",
      },
    ],
    name: "collectTicketPrize",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "ticket_no",
        type: "uint256",
      },
    ],
    name: "collectTicketRefund",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "depositEther",
    outputs: [],
    stateMutability: "payable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "ticket_no",
        type: "uint256",
      },
    ],
    name: "findTicketInfosFromNo",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "i",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "lottery_no",
        type: "uint256",
      },
    ],
    name: "getIthOwnedTicketNo",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        internalType: "uint8",
        name: "status",
        type: "uint8",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "i",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "lottery_no",
        type: "uint256",
      },
    ],
    name: "getIthWinningTicket",
    outputs: [
      {
        internalType: "uint256",
        name: "ticket_no",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "lottery_no",
        type: "uint256",
      },
    ],
    name: "getLastOwnedTicketNo",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        internalType: "uint8",
        name: "",
        type: "uint8",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "lottery_no",
        type: "uint256",
      },
    ],
    name: "getLotteryMoneyCollected",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getMoneyCollected",
    outputs: [
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getRandomNumber",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "ticket_number",
        type: "uint256",
      },
    ],
    name: "getTicketInfo",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "lottery_no",
        type: "uint256",
      },
    ],
    name: "getWinningTicket",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "enum FinalLottery.TicketTier",
        name: "tier",
        type: "uint8",
      },
    ],
    name: "getamount",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "pure",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "withdrawEther",
    outputs: [],
    stateMutability: "payable",
    type: "function",
  },
] as const;

const _bytecode =
  "0x60806040524260015534801561001457600080fd5b5042600181905550612f598061002b6000396000f3fe6080604052600436106101145760003560e01c806398ea5fca116100a0578063dbdff2c111610064578063dbdff2c1146103fb578063e3d670d714610426578063e54778b514610463578063f6789ca0146104a1578063ff99a063146104ca57610114565b806398ea5fca146102fc5780639c7278ca14610306578063a06cc71a14610343578063a6588af814610380578063cb4581d8146103bd57610114565b80633bed33ce116100e75780633bed33ce146101fa57806348367d1e1461021657806357ac796e146102545780635f2ff1cf1461027f578063775f1aec146102be57610114565b8063269dd947146101195780632b8bdc00146101565780632e1fe4501461019457806339f7958b146101bd575b600080fd5b34801561012557600080fd5b50610140600480360381019061013b9190612671565b6104f3565b60405161014d91906126ad565b60405180910390f35b34801561016257600080fd5b5061017d60048036038101906101789190612671565b61054b565b60405161018b9291906126e4565b60405180910390f35b3480156101a057600080fd5b506101bb60048036038101906101b69190612671565b6106b1565b005b3480156101c957600080fd5b506101e460048036038101906101df9190612732565b610883565b6040516101f191906126ad565b60405180910390f35b610214600480360381019061020f9190612671565b61092c565b005b34801561022257600080fd5b5061023d6004803603810190610238919061275f565b610a4e565b60405161024b9291906126e4565b60405180910390f35b34801561026057600080fd5b50610269610b93565b60405161027691906126ad565b60405180910390f35b34801561028b57600080fd5b506102a660048036038101906102a19190612671565b610b9d565b6040516102b59392919061279f565b60405180910390f35b3480156102ca57600080fd5b506102e560048036038101906102e09190612671565b610c4b565b6040516102f39291906127d6565b60405180910390f35b610304610d86565b005b34801561031257600080fd5b5061032d6004803603810190610328919061275f565b610dde565b60405161033a91906126ad565b60405180910390f35b34801561034f57600080fd5b5061036a6004803603810190610365919061275f565b610e88565b60405161037791906126ad565b60405180910390f35b34801561038c57600080fd5b506103a760048036038101906103a29190612671565b6110e2565b6040516103b491906126ad565b60405180910390f35b3480156103c957600080fd5b506103e460048036038101906103df919061275f565b6110ff565b6040516103f292919061288f565b60405180910390f35b34801561040757600080fd5b50610410611b3c565b60405161041d91906126ad565b60405180910390f35b34801561043257600080fd5b5061044d6004803603810190610448919061291d565b611b6d565b60405161045a91906126ad565b60405180910390f35b34801561046f57600080fd5b5061048a6004803603810190610485919061275f565b611b85565b6040516104989291906127d6565b60405180910390f35b3480156104ad57600080fd5b506104c860048036038101906104c391906129b6565b611c54565b005b3480156104d657600080fd5b506104f160048036038101906104ec9190612671565b611f4b565b005b6000806105016001846110ff565b91505060006105116002856110ff565b91505060006105216003866110ff565b91505060008183856105339190612a25565b61053d9190612a25565b905080945050505050919050565b60008060006001600360003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000868152602001908152602001600020805490506105b09190612a59565b9050600360003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000858152602001908152602001600020818154811061061457610613612a8d565b5b906000526020600020906005020160000154600360003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000868152602001908152602001600020828154811061068857610687612a8d565b5b906000526020600020906005020160040160009054906101000a900460ff169250925050915091565b6000806106bd83610c4b565b80925081935050506000600360003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000848152602001908152602001600020828154811061072957610728612a8d565b5b906000526020600020906005020160040160029054906101000a900460ff169050600061075582610883565b905080600460003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008282546107a69190612a25565b92505081905550806006600086815260200190815260200160002060008282546107d09190612a59565b9250508190555080600260008282546107e99190612a59565b925050819055506000600360003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000868152602001908152602001600020848154811061085457610853612a8d565b5b906000526020600020906005020160040160016101000a81548160ff0219169083151502179055505050505050565b6000806000600381111561089a57610899612abc565b5b8360038111156108ad576108ac612abc565b5b036108bb5760089050610923565b600160038111156108cf576108ce612abc565b5b8360038111156108e2576108e1612abc565b5b036108f05760049050610922565b6000600381111561090457610903612abc565b5b83600381111561091757610916612abc565b5b0361092157600290505b5b5b80915050919050565b80600460003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205410156109ae576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016109a590612b37565b60405180910390fd5b80600460003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008282546109fd9190612a59565b925050819055503373ffffffffffffffffffffffffffffffffffffffff166108fc829081150290604051600060405180830381858888f19350505050158015610a4a573d6000803e3d6000fd5b5050565b600080610a596125df565b600360003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008581526020019081526020016000208581548110610abb57610aba612a8d565b5b90600052602060002090600502016040518060e0016040529081600082015481526020016001820154815260200160028201548152602001600382015481526020016004820160009054906101000a900460ff1660ff1660ff1681526020016004820160019054906101000a900460ff161515151581526020016004820160029054906101000a900460ff166003811115610b5957610b58612abc565b5b6003811115610b6b57610b6a612abc565b5b8152505090506000816000015190506000826080015190508181945094505050509250929050565b6000600254905090565b600080600060056000858152602001908152602001600020600201600081548110610bcb57610bca612a8d565b5b906000526020600020015460056000868152602001908152602001600020600201600181548110610bff57610bfe612a8d565b5b906000526020600020015460056000878152602001908152602001600020600201600281548110610c3357610c32612a8d565b5b90600052602060002001549250925092509193909250565b6000806000610c586122ef565b905060005b600182610c6a9190612a25565b811015610d7e5760005b600360003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600083815260200190815260200160002080549050811015610d6a5785600360003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008481526020019081526020016000208281548110610d3257610d31612a8d565b5b90600052602060002090600502016000015403610d5757818194509450505050610d81565b8080610d6290612b57565b915050610c74565b508080610d7690612b57565b915050610c5d565b50505b915091565b34600460003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000828254610dd59190612a25565b92505081905550565b6000806000905060005b6003811015610e4e5783600560008781526020019081526020016000206002018281548110610e1a57610e19612a8d565b5b906000526020600020015403610e3b57610e3481866110ff565b9050809250505b8080610e4690612b57565b915050610de8565b5080600254610e5d9190612a59565b50806006600086815260200190815260200160002054610e7d9190612a59565b508091505092915050565b6000610e926122ef565b8303610ed3576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401610eca90612c11565b60405180910390fd5b6003600560008581526020019081526020016000206002018054905014610efe57610efd8361232f565b5b6000606060006005600087815260200190815260200160002060030160056000888152602001908152602001600020600201600081548110610f4357610f42612a8d565b5b906000526020600020015481548110610f5f57610f5e612a8d565b5b9060005260206000200154905060006005600088815260200190815260200160002060030160056000898152602001908152602001600020600201600181548110610fad57610fac612a8d565b5b906000526020600020015481548110610fc957610fc8612a8d565b5b90600052602060002001549050600060056000898152602001908152602001600020600301600560008a815260200190815260200160002060020160028154811061101757611016612a8d565b5b90600052602060002001548154811061103357611032612a8d565b5b9060005260206000200154905082870361105f576110526001896110ff565b809650819550505061109b565b81870361107e576110716002896110ff565b809650819550505061109a565b808703611099576110906003896110ff565b80965081955050505b5b5b7f47d11ec30af726942ac6508eadccdf4c14a1c898a0433e77427b8c40a3a4364484866040516110cc92919061288f565b60405180910390a1849550505050505092915050565b600060066000838152602001908152602001600020549050919050565b6060600080606060006005600087815260200190815260200160002060030160056000888152602001908152602001600020600201888154811061114657611145612a8d565b5b90600052602060002001548154811061116257611161612a8d565b5b90600052602060002001549050600061117a82610c4b565b915050600182036114b4576000600381111561119957611198612abc565b5b600360003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600089815260200190815260200160002082815481106111fb576111fa612a8d565b5b906000526020600020906005020160040160029054906101000a900460ff16600381111561122c5761122b612abc565b5b0361127e576002805461123f9190612c60565b93506040518060400160405280600a81526020017f46756c6c2046697273740000000000000000000000000000000000000000000081525092506114af565b6001600381111561129257611291612abc565b5b600360003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600089815260200190815260200160002082815481106112f4576112f3612a8d565b5b906000526020600020906005020160040160029054906101000a900460ff16600381111561132557611324612abc565b5b036113785760046002546113399190612c60565b93506040518060400160405280600a81526020017f48616c662046697273740000000000000000000000000000000000000000000081525092506114ae565b6002600381111561138c5761138b612abc565b5b600360003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600089815260200190815260200160002082815481106113ee576113ed612a8d565b5b906000526020600020906005020160040160029054906101000a900460ff16600381111561141f5761141e612abc565b5b036114725760086002546114339190612c60565b93506040518060400160405280600d81526020017f517561727465722046697273740000000000000000000000000000000000000081525092506114ad565b6040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016114a490612cdd565b60405180910390fd5b5b5b611b2b565b600282036117ec57600060038111156114d0576114cf612abc565b5b600360003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000898152602001908152602001600020828154811061153257611531612a8d565b5b906000526020600020906005020160040160029054906101000a900460ff16600381111561156357611562612abc565b5b036115b6576040518060400160405280600b81526020017f46756c6c205365636f6e64000000000000000000000000000000000000000000815250925060046002546115af9190612c60565b93506117e7565b600160038111156115ca576115c9612abc565b5b600360003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000898152602001908152602001600020828154811061162c5761162b612a8d565b5b906000526020600020906005020160040160029054906101000a900460ff16600381111561165d5761165c612abc565b5b036116b0576040518060400160405280600b81526020017f48616c66205365636f6e64000000000000000000000000000000000000000000815250925060086002546116a99190612c60565b93506117e6565b600260038111156116c4576116c3612abc565b5b600360003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000898152602001908152602001600020828154811061172657611725612a8d565b5b906000526020600020906005020160040160029054906101000a900460ff16600381111561175757611756612abc565b5b036117aa576040518060400160405280600e81526020017f51756172746572205365636f6e64000000000000000000000000000000000000815250925060106002546117a39190612c60565b93506117e5565b6040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016117dc90612cdd565b60405180910390fd5b5b5b611b2a565b60038203611b24576000600381111561180857611807612abc565b5b600360003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000898152602001908152602001600020828154811061186a57611869612a8d565b5b906000526020600020906005020160040160029054906101000a900460ff16600381111561189b5761189a612abc565b5b036118ee576040518060400160405280600a81526020017f46756c6c20546869726400000000000000000000000000000000000000000000815250925060086002546118e79190612c60565b9350611b1f565b6001600381111561190257611901612abc565b5b600360003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000898152602001908152602001600020828154811061196457611963612a8d565b5b906000526020600020906005020160040160029054906101000a900460ff16600381111561199557611994612abc565b5b036119e8576040518060400160405280600a81526020017f48616c6620546869726400000000000000000000000000000000000000000000815250925060106002546119e19190612c60565b9350611b1e565b600260038111156119fc576119fb612abc565b5b600360003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008981526020019081526020016000208281548110611a5e57611a5d612a8d565b5b906000526020600020906005020160040160029054906101000a900460ff166003811115611a8f57611a8e612abc565b5b03611ae2576040518060400160405280600d81526020017f517561727465722054686972640000000000000000000000000000000000000081525092506020600254611adb9190612c60565b9350611b1d565b6040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401611b1490612cdd565b60405180910390fd5b5b5b611b29565b600093505b5b5b828495509550505050509250929050565b600042604051602001611b4f9190612d1e565b6040516020818303038152906040528051906020012060001c905090565b60046020528060005260406000206000915090505481565b6000806000600560008581526020019081526020016000206002018581548110611bb257611bb1612a8d565b5b90600052602060002001549050600560008581526020019081526020016000206003018181548110611be757611be6612a8d565b5b90600052602060002001549250611bfd83610c4b565b905080915050611c0d85856110ff565b9050809250507f9ccbea8acda54bc998251706a6d0054e0a880c3f38e70c8eaf6bd9b383c99dad8383604051611c449291906127d6565b60405180910390a1509250929050565b6000611c5e6122ef565b905060038110611cac57600360056000600284611c7b9190612a59565b81526020019081526020016000206002018054905014611cab57611caa600282611ca59190612a59565b61232f565b5b5b60006001831480611cbd5750600283145b80611cc85750600383145b611d07576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401611cfe90612d85565b60405180910390fd5b6001600080828254611d199190612a25565b9250508190555060018303611d315760009050611d51565b60028303611d425760019050611d50565b60038303611d4f57600290505b5b5b600360003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008381526020019081526020016000206040518060e001604052806000548152602001848152602001868152602001428152602001600060ff168152602001600115158152602001836003811115611dec57611deb612abc565b5b81525090806001815401808255809150506001900390600052602060002090600502016000909190919091506000820151816000015560208201518160010155604082015181600201556060820151816003015560808201518160040160006101000a81548160ff021916908360ff16021790555060a08201518160040160016101000a81548160ff02191690831515021790555060c08201518160040160026101000a81548160ff02191690836003811115611eac57611eab612abc565b5b02179055505050611ebc81610883565b60026000828254611ecd9190612a25565b92505081905550600560008381526020019081526020016000206003016000549080600181540180825580915050600190039060005260206000200160009091909190915055611f1c81610883565b600660008481526020019081526020016000206000828254611f3e9190612a25565b9250508190555050505050565b600080611f5783610c4b565b915091507fbce7d9c77b584a77086d92f0e16950470c847bca6700cd4d91240c581f5a611a600360003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008481526020019081526020016000208281548110611fde57611fdd612a8d565b5b906000526020600020906005020160000154600360003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000858152602001908152602001600020838154811061205257612051612a8d565b5b906000526020600020906005020160010154600360003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600086815260200190815260200160002084815481106120c6576120c5612a8d565b5b906000526020600020906005020160020154600360003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000878152602001908152602001600020858154811061213a57612139612a8d565b5b906000526020600020906005020160030154600360003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600088815260200190815260200160002086815481106121ae576121ad612a8d565b5b906000526020600020906005020160040160009054906101000a900460ff16600360003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000898152602001908152602001600020878154811061222f5761222e612a8d565b5b906000526020600020906005020160040160019054906101000a900460ff16600360003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008a815260200190815260200160002088815481106122b0576122af612a8d565b5b906000526020600020906005020160040160029054906101000a900460ff166040516122e29796959493929190612e17565b60405180910390a1505050565b6000804290506000600154826123059190612a59565b90506000600162093a808361231a9190612c60565b6123249190612a25565b905080935050505090565b600360056000838152602001908152602001600020600301805490501161238b576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161238290612ed2565b60405180910390fd5b600060056000838152602001908152602001600020600301805490509050600060056000848152602001908152602001600020600301805490506123cd611b3c565b6123d79190612ef2565b9050600060056000858152602001908152602001600020600301805490506123fd611b3c565b6124079190612ef2565b90506000600560008681526020019081526020016000206003018054905061242d611b3c565b6124379190612ef2565b90505b8183148061244757508082145b8061245157508083145b156125b85781830361248e5760018461246a9190612a59565b83146124845760018261247d9190612a25565b9250612489565b600092505b6124fc565b8082036124c6576001846124a29190612a59565b82146124bc576001816124b59190612a25565b91506124c1565b600091505b6124fb565b8083036124fa576001846124da9190612a59565b83146124f4576001816124ed9190612a25565b92506124f9565b600092505b5b5b5b60056000868152602001908152602001600020600201839080600181540180825580915050600190039060005260206000200160009091909190915055600560008681526020019081526020016000206002018290806001815401808255809150506001900390600052602060002001600090919091909150556005600086815260200190815260200160002060020181908060018154018082558091505060019003906000526020600020016000909190919091505561243a565b6125c1856104f3565b60076000878152602001908152602001600020819055505050505050565b6040518060e0016040528060008152602001600081526020016000801916815260200160008152602001600060ff168152602001600015158152602001600060038111156126305761262f612abc565b5b81525090565b600080fd5b6000819050919050565b61264e8161263b565b811461265957600080fd5b50565b60008135905061266b81612645565b92915050565b60006020828403121561268757612686612636565b5b60006126958482850161265c565b91505092915050565b6126a78161263b565b82525050565b60006020820190506126c2600083018461269e565b92915050565b600060ff82169050919050565b6126de816126c8565b82525050565b60006040820190506126f9600083018561269e565b61270660208301846126d5565b9392505050565b6004811061271a57600080fd5b50565b60008135905061272c8161270d565b92915050565b60006020828403121561274857612747612636565b5b60006127568482850161271d565b91505092915050565b6000806040838503121561277657612775612636565b5b60006127848582860161265c565b92505060206127958582860161265c565b9150509250929050565b60006060820190506127b4600083018661269e565b6127c1602083018561269e565b6127ce604083018461269e565b949350505050565b60006040820190506127eb600083018561269e565b6127f8602083018461269e565b9392505050565b600081519050919050565b600082825260208201905092915050565b60005b8381101561283957808201518184015260208101905061281e565b60008484015250505050565b6000601f19601f8301169050919050565b6000612861826127ff565b61286b818561280a565b935061287b81856020860161281b565b61288481612845565b840191505092915050565b600060408201905081810360008301526128a98185612856565b90506128b8602083018461269e565b9392505050565b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b60006128ea826128bf565b9050919050565b6128fa816128df565b811461290557600080fd5b50565b600081359050612917816128f1565b92915050565b60006020828403121561293357612932612636565b5b600061294184828501612908565b91505092915050565b6000819050919050565b61295d8161294a565b811461296857600080fd5b50565b60008135905061297a81612954565b92915050565b6000819050919050565b61299381612980565b811461299e57600080fd5b50565b6000813590506129b08161298a565b92915050565b600080604083850312156129cd576129cc612636565b5b60006129db8582860161296b565b92505060206129ec858286016129a1565b9150509250929050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b6000612a308261263b565b9150612a3b8361263b565b9250828201905080821115612a5357612a526129f6565b5b92915050565b6000612a648261263b565b9150612a6f8361263b565b9250828203905081811115612a8757612a866129f6565b5b92915050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052603260045260246000fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052602160045260246000fd5b7f696e73756666696369656e742062616c616e6365000000000000000000000000600082015250565b6000612b2160148361280a565b9150612b2c82612aeb565b602082019050919050565b60006020820190508181036000830152612b5081612b14565b9050919050565b6000612b628261263b565b91507fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8203612b9457612b936129f6565b5b600182019050919050565b7f596f75206861766520746f207761697420666f72207468652072657665616c2060008201527f7374616765000000000000000000000000000000000000000000000000000000602082015250565b6000612bfb60258361280a565b9150612c0682612b9f565b604082019050919050565b60006020820190508181036000830152612c2a81612bee565b9050919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601260045260246000fd5b6000612c6b8261263b565b9150612c768361263b565b925082612c8657612c85612c31565b5b828204905092915050565b7f496e76616c6964206f7065726174696f6e2e0000000000000000000000000000600082015250565b6000612cc760128361280a565b9150612cd282612c91565b602082019050919050565b60006020820190508181036000830152612cf681612cba565b9050919050565b6000819050919050565b612d18612d138261263b565b612cfd565b82525050565b6000612d2a8284612d07565b60208201915081905092915050565b7f57726f6e6720496e707574000000000000000000000000000000000000000000600082015250565b6000612d6f600b8361280a565b9150612d7a82612d39565b602082019050919050565b60006020820190508181036000830152612d9e81612d62565b9050919050565b612dae8161294a565b82525050565b60008115159050919050565b612dc981612db4565b82525050565b60048110612de057612ddf612abc565b5b50565b6000819050612df182612dcf565b919050565b6000612e0182612de3565b9050919050565b612e1181612df6565b82525050565b600060e082019050612e2c600083018a61269e565b612e39602083018961269e565b612e466040830188612da5565b612e53606083018761269e565b612e6060808301866126d5565b612e6d60a0830185612dc0565b612e7a60c0830184612e08565b98975050505050505050565b7f6e6f7420656e6f756768207469636b6574730000000000000000000000000000600082015250565b6000612ebc60128361280a565b9150612ec782612e86565b602082019050919050565b60006020820190508181036000830152612eeb81612eaf565b9050919050565b6000612efd8261263b565b9150612f088361263b565b925082612f1857612f17612c31565b5b82820690509291505056fea264697066735822122019033f35ec258b8122abd4d3ec808c40c1e84bc4c42347fc7b2c9f9c741a24a964736f6c63430008120033";

type FinalLotteryConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: FinalLotteryConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class FinalLottery__factory extends ContractFactory {
  constructor(...args: FinalLotteryConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<FinalLottery> {
    return super.deploy(overrides || {}) as Promise<FinalLottery>;
  }
  override getDeployTransaction(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(overrides || {});
  }
  override attach(address: string): FinalLottery {
    return super.attach(address) as FinalLottery;
  }
  override connect(signer: Signer): FinalLottery__factory {
    return super.connect(signer) as FinalLottery__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): FinalLotteryInterface {
    return new utils.Interface(_abi) as FinalLotteryInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): FinalLottery {
    return new Contract(address, _abi, signerOrProvider) as FinalLottery;
  }
}

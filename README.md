# ICO Crypto Securities Token

# README

*CSX.sol* is a fixed supply contract with a fixed supply of 100000000, Out of which 51000000 Tokens are initially assigned to the owner of the contract and 49000000 Tokens are available for the Crowdsale.

The Contract is based on ERC20 Token Standard.

## What is this repository for?
*Crypto Securities Token* ICO contract.

## Flow Chart CSX Coin

### Coin specifications:

Token name - Crypto Securities Token

Token Symbol - CSX

Decimals allowed - 7

CSX Token Total Supply - 100,000,000

Price - 1 USD per Token

HardCap - 49000000 USD

## How Does A Crypto Securities Token Contract Work?

Deploy the above *CSX.sol* smart contract and obtain its address.
The address which deployed the Smart Contract becomes the Owner of the Smart Contract.

  
### Start PREICO  
**start_PREICO** function needs to be called by the Owner of the Smart Contract to start the PREICO. The preICO runs for 39 days.

1 USD = 1 CSX coin

Ether can be transferred to the Smart Contract address **(from account other than the Owner’s account)**.
Once hard Cap of 49000000 USD is reached or 39 days are completed, the smart contract can no more accept any ether.


### Start ICO
**start_ICO** function needs to be called by the Owner of the Smart Contract to start the ICO. The preICO runs for 31 days.

1 USD = 1 CSX coin

Ether can be transferred to the Smart Contract address **(from account other than the Owner’s account)**.
Once hard Cap of 49000000 USD is reached OR 31 days are completed, the smart contract can no more accept any ether.

### End ICO
**end_ICO** function needs to be called by the Owner of the Smart Contract to end the ICO. Any tokens left in the Smart Contract will be burnt here.

TotalSupply = 100,000,000  CSX Coins 

Balances Smart Contract = 0  CSX Coins 

**Note**:   end_ICO(  ) should be called only after  ICO crowdsale gets completed / Hard Cap of 49000000 USD is reached.

### Token Balance
To check the token balance of token holder, **balanceOf()** function needs to be used.
For example, assume the CSX contract has two token holders:
* 0x111 with a balance of 50 CSX
* 0x222 with a balance of 100 CSX

The **balanceOf()** will return following values:
* balanceOf(0x111) will return 50
* balanceOf(0x111) will return 100


### Transfer Token Balance
To transfer CSX tokens to different address, **transfer()** function needs to be used.

For example,If 0x111 wants to transfer 10 CSX to 0x222,
0x111 will execute the function:
* transfer(0x222, 10)

The **balanceOf()** will now return following values:
* balanceOf(0x111) will return 40
* balanceOf(0x222) will return 110

### Approve and TransferFrom Token Balance
If 0x222 wants to authorise 0x111 to transfer some tokens on his behalf, then 0x222 will  execute the **approve()** function

For example,If 0x222 wants to approve 30 CSX to 0x111,
0x222 will execute the function:
* approve(0x111, 30)

The approve data structure will now contain the following information:
* allowed[0x222][0x111] = 30
	
Now, if 0x111 wants to later transfer some tokens from 0x222 to itself, then 0x111 will execute **transferFrom()** function

For example, if 0x111 wants to transfer 20 CSX to itself,
0x111 will execute function:
* transferFrom(0x222, 0x111, 20)
 
The **balances** data structure will contain the following information:
* balances[0x111] = 60
* balances[0x222] = 90

And, approve data structure will now contain the following information:
* allowed[0x222][0x111] = 10

Thus, 0x111 can still spend 10 CSX from 0x222,

The **balanceOf()** will now return following values:
* balanceOf(0x111) will return 60
* balanceOf(0x222) will return 90

### Note : 
The above two addresses(0X111, 0X222) taken in Example are not Valid Ethereum Addresses, to make transaction you need to have a valid Ethereum Address.
     
## Important Functions
**PauseICO( )**: Only Owner of the Smart contract can call this function to Pause the Crowdsale at any phase.

**ResumeICO( )**: Only Owner of the Smart contract can call this function to Resume the Crowdsale at any phase.

**drain( )**: Owner can transfer all the Ether from the Smart contract anytime using this function in case there is any Ether left in the Smart Contract.




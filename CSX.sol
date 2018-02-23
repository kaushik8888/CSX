pragma solidity 0.4.20;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

contract ERC20 {
  function totalSupply()public view returns (uint total_Supply);
  function balanceOf(address who)public view returns (uint256);
  function allowance(address owner, address spender)public view returns (uint);
  function transferFrom(address from, address to, uint value)public returns (bool ok);
  function approve(address spender, uint value)public returns (bool ok);
  function transfer(address to, uint value)public returns (bool ok);
  event Transfer(address indexed from, address indexed to, uint value);
  event Approval(address indexed owner, address indexed spender, uint value);
}


contract CSX is ERC20
{ using SafeMath for uint256;
    // Name of the token
    string public constant name = "Crypto Securities Token";

    // Symbol of token
    string public constant symbol = "CSX";
    uint8 public constant decimals = 7;
    uint public _totalsupply = 100000000 * 10 ** 7; // 100 Million total supply muliplies dues to decimal precision
    address public owner;                    // Owner of this contract
    uint256 no_of_tokens;
    bool stopped = true;
    uint256 public constant price  = 100; // price is in cents
    uint256 public ico_startdate;
    uint256 public ico_enddate;
     uint256 public pre_startdate;
    uint256 public pre_enddate;
    uint256 maxCap_ICO = 4900000000; // $ 49 million in cents hardcap
    uint256 public totalreceived;
    uint256 contribution;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    uint public priceFactor;
    // uint constant public minimumInvestment = .1 ether; //  $100 is minimum minimumInvestment

    
     enum Stages {
        NOTSTARTED,
        PREICO,
        ICO,
        ENDED
    }
    Stages public stage;
    
    modifier atStage(Stages _stage) {
        if (stage != _stage)
            // Contract not in expected state
            revert();
        _;
    }
    
     modifier onlyOwner() {
        if (msg.sender != owner) {
            revert();
        }
        _;
    }
  
   function CSX(uint256 EtherPriceFactor) public
    {
        require(EtherPriceFactor != 0);
        owner = msg.sender;
        balances[owner] = 51000000 * 10 ** 7;    // 51 million to owner
        balances[address(this)] = 49000000 * 10 ** 7;  //49 million to smart contract
        stage = Stages.NOTSTARTED;
        priceFactor = EtherPriceFactor;
        Transfer(0, owner, balances[owner]);
        Transfer(0, address(this),balances[address(this)]);
    }
  
   function () public payable //atStage(Stages.ICO)
    {
       // require(msg.value >= minimumInvestment);
      require(totalreceived < maxCap_ICO ) ;
      require(!stopped && msg.sender != owner);
         if( stage == Stages.PREICO && now <= pre_enddate )
            { 
            contribution = (msg.value.mul(priceFactor)).mul(100); // in cents
            no_of_tokens = ((contribution.div(price))).div(10 ** 11);
            totalreceived = totalreceived.add(contribution);        
            transferTokens(msg.sender,no_of_tokens);
        
              }
           else if( stage == Stages.ICO && now <= ico_enddate )
            { 
                
        
            contribution = (msg.value.mul(priceFactor)).mul(100); // in cents
            no_of_tokens = ((contribution.div(price))).div(10 ** 11);
            totalreceived = totalreceived.add(contribution); 
            transferTokens(msg.sender,no_of_tokens);
              
            }
            else{
             revert();
            }
      
    }
   

    function start_PREICO() public onlyOwner atStage(Stages.NOTSTARTED)
      {
         
         stage = Stages.PREICO;
          stopped = false;
        //   balances[owner] = (balances[owner]).sub(_ICOcap);
        //   maxCap_ICO = _ICOcap;
        //   balances[address(this)] = (maxCap_ICO);
          pre_startdate = now;
          pre_enddate = now + 39 days;
         
          
      }

    function start_ICO() public onlyOwner atStage(Stages.NOTSTARTED)
      {
         
         stage = Stages.ICO;
          stopped = false;
        //   balances[owner] = (balances[owner]).sub(_ICOcap);
        //   maxCap_ICO = _ICOcap;
        //   balances[address(this)] = (maxCap_ICO);
          ico_startdate = now;
          ico_enddate = now + 31 days;
         
          
      }

    // called by the owner, pause ICO
    function PauseICO() external onlyOwner 
    {
         stopped = true;
       }

    // called by the owner , resumes ICO
    function ResumeICO() external onlyOwner 
    {
        stopped = false;
     
      }
      
      function setpricefactor(uint256 _pricefactor) external onlyOwner 
      {
          priceFactor = _pricefactor;
      }
   
   
      function end_ICO() external onlyOwner atStage(Stages.ICO)
     {
        
         require(now > ico_enddate || balances[address(this)] == 0);
         stage = Stages.ENDED;
         _totalsupply = (_totalsupply).sub(balances[address(this)]);
         balances[address(this)] = 0;
         Transfer(address(this), 0 , balances[address(this)]);
    }

    // what is the total supply of the ech tokens
     function totalSupply() public view returns (uint256 total_Supply) {
         total_Supply = _totalsupply;
     }
    
    // What is the balance of a particular account?
     function balanceOf(address _owner)public view returns (uint256 balance) {
         return balances[_owner];
     }
    
    // Send _value amount of tokens from address _from to address _to
     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
     // fees in sub-currencies; the command should fail unless the _from account has
     // deliberately authorized the sender of the message via some mechanism; we propose
     // these standardized APIs for approval:
     function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {
     require( _to != 0x0);
     require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
     balances[_from] = (balances[_from]).sub(_amount);
     allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
     balances[_to] = (balances[_to]).add(_amount);
     Transfer(_from, _to, _amount);
     return true;
         }
    
   // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
     // If this function is called again it overwrites the current allowance with _value.
     function approve(address _spender, uint256 _amount)public returns (bool success) {
         require( _spender != 0x0);
         allowed[msg.sender][_spender] = _amount;
         Approval(msg.sender, _spender, _amount);
         return true;
     }
  
     function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
         require( _owner != 0x0 && _spender !=0x0);
         return allowed[_owner][_spender];
   }

     // Transfer the balance from owner's account to another account
     function transfer(address _to, uint256 _amount)public returns (bool success) {
        require( _to != 0x0);
        require(balances[msg.sender] >= _amount && _amount >= 0);
        balances[msg.sender] = (balances[msg.sender]).sub(_amount);
        balances[_to] = (balances[_to]).add(_amount);
        Transfer(msg.sender, _to, _amount);
             return true;
         }
    
          // Transfer the balance from owner's account to another account
    function transferTokens(address _to, uint256 _amount) private returns(bool success) {
        require( _to != 0x0);       
        require(balances[address(this)] >= _amount && _amount > 0);
        balances[address(this)] = (balances[address(this)]).sub(_amount);
        balances[_to] = (balances[_to]).add(_amount);
        Transfer(address(this), _to, _amount);
        return true;
        }
    
    function drain() external onlyOwner {
        owner.transfer(this.balance);
    }
    
}
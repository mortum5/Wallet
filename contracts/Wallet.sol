pragma solidity >=0.7.0 <0.9.0;


/** @title Contract for checking owner
  * @author Andrey Gonchar
  */
contract Owner {

    address payable internal owner;

    modifier isOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }
    
    constructor() {
        owner = payable(msg.sender); // 'msg.sender' is sender of current call, contract deployer for a constructor
    }

    /** @notice Get owner address
      * @return address of owner
      */
    function getOwner() external view returns (address) {
        return owner;
    }
    
    
}

/** @title Token`s contract and methods
  * @author Andrey Gonchar
  */
contract Token is Owner {
    using SafeMath for uint256;
    
    string public constant NAME = "Mortum Coin";
    string public constant SYMBOL = "MCC";
    uint8 public constant DECIMALS = 0;
    
    uint256 private totalSupply;
    
    mapping(address => uint256) internal balances;
    mapping(address => mapping (address => uint256)) internal allowed;
    
    constructor (uint256 _totalSupply) isOwner() {
        totalSupply = _totalSupply;
        balances[owner] = totalSupply;
    }
    
    /** @notice returns the full amount of token
      * @return total Supply
      */
    function getTotalSupply() public view returns (uint256) {
        return totalSupply;
    }
    
    /** @notice get balance token
      * @return balance token
      */
    function getBalanceToken(address tokenOwner) public view returns (uint256) {
        return balances[tokenOwner];
    }
    
    /** @notice return how many tokens can the intermediary use 
      * @return how many tokens can the intermediary use 
      */
    function allowance(address tokenOwner, address delegate) public view returns (uint256) {
        return allowed[tokenOwner][delegate];
    }
    
    /** @notice transfer tokens to another holder
      * @dev mandatory check of the translation's validity 
      * @param to destination of transfer
      * @param tokens quantity of transfer tokens
      */
    function transfer(address to, uint tokens) public {
        require(tokens <= balances[msg.sender], "Now enough tokens for transfer!");
        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
    }
    
    /** @notice allow a third-party dispose of certain amount of tokens
      * @param delegate  address of delegate
      * @param tokens  quantity of approved tokens
      */
    function approve(address delegate, uint tokens)  public {
        allowed[msg.sender][delegate] = tokens;
    }
    
    /** @notice making transaction
      * @dev mandatory check of the translation's validity 
      * @param owner  owner of tokens
      * @param buyer  buyer of tokens
      * @param numTokens  quantity of tokens
      */
    function transferFrom(address owner, address buyer, uint numTokens) public {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);
        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
    }
    
}

/** @title Contract for working with Ethereum coins
  * @author Andrey Gonchar
  */
contract Ethereum is Owner {
    using SafeMath for uint256;
    
    uint256 private balanceOfEther;
    uint256 private balanceOfFee;
    uint256 private feeSize;
    
    constructor (uint256 _feeSize) {
        feeSize = _feeSize;
    }
    
    /** @notice
      * @return
      */
    function setFeeSize(uint256 _feeSize) public {
        feeSize = _feeSize;
    } 
    
     /** @notice
      * @return
      */
    function getBalanceEther() public view returns(uint256) {
        return balanceOfEther;
    }
    
    /** @notice
      * @return
      */
    function getBalanceFee() public view returns(uint256) {
        return balanceOfFee;
    }
    
    /** @notice
      * @return
      */
    receive() external payable {
        balanceOfEther = balanceOfEther.add(msg.value);
    }
    
    /** @notice
      * @return
      */
    function withdraw() public isOwner() {
        uint256 amount = balanceOfEther;
        balanceOfEther = 0;
        owner.transfer(amount);
    }
    
    /** @notice
      * @return
      */
    function withdrawFee() public isOwner() {
        uint256 amount = balanceOfFee;
        balanceOfFee = 0;
        owner.transfer(amount);
    }
    
    /** @notice
      * @dev
      * @param to address
      */
    function transferEther(address payable to, uint256 amount) public isOwner() {
        require(amount <= balanceOfEther, "Not enough ether for transfer!");
        require(amount <= balanceOfEther + feeSize, "Not enougn ether for feePay!");
        balanceOfEther = balanceOfEther.sub(amount).sub(feeSize);
        balanceOfFee = balanceOfFee.add(feeSize);
        to.transfer(amount);
        
    }
        
}

/** @title Main Contract
  * @author Andrey Gonchar
  */
contract Wallet is Token, Ethereum {
    uint256 private totalSupply = 10000;
    uint256 private feeSize = 100;
    
    constructor () Token(totalSupply) Ethereum(feeSize) {}
}

library SafeMath {
    
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


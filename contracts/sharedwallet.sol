 // SPDX-License-Identifier: GPL-3.0

   pragma solidity ^0.5.17;
  import "https://github.com/pkdcryptos/OpenZeppelin-openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol";

  contract Allowance is Ownable{
    event allowancechange(address indexed _forwho,address indexed _fromwhom,uint _oldamount , uint _newamount);

    mapping(address => uint) public allowance;
    
    function addallowance(address _who,uint _amount) public {
        emit allowancechange(_who,msg.sender,allowance[_who],_amount);
        allowance[_who]= _amount;
    }

        modifier ownerorallowed(uint _amount){
        require(isOwner() || allowance[msg.sender] >= _amount,"you are not allowed");
        _;
    }

    function reduceallowance(address _who,uint _amount) internal {
        emit allowancechange(_who,msg.sender,allowance[_who],_amount);
        allowance[_who]-=_amount;
    }
}
 pragma solidity ^0.5.17;
   // import "./Allowance.sol";

    contract Simplewallet is Allowance{

    //   address public owner;

    //  constructor() public {
    //      owner=msg.sender;
    //  }
    event moneysend(address indexed _beneficiary,uint _amount);
    event moneyreceived(address indexed _from,uint _amount);
    
     function withdrawMoney(address payable _to,uint _amount) public ownerorallowed(_amount){
         require(_amount <= address(this).balance,"not enough funds in smart contract");
        //  require(owner == msg.sender ,"you are not allowed");
        if(!isOwner()){
            reduceallowance(msg.sender,_amount);
        }
        emit moneysend(_to,_amount);
         _to.transfer(_amount);
     }

     function renounceOwnership() public onlyOwner {
         revert("can't renounce ownership");
     }


     function () external payable {
        emit moneyreceived(msg.sender,msg.value);
     }

 }

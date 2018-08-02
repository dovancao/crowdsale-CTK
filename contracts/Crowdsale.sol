pragma solidity ^0.4.24;
import './Token.sol';
import './ERC223.sol';
import './ERC20.sol';
import './SafeMath.sol';
import './ERC223ReceivingContract.sol';

contract Crowdsale {
    /** token creator */
    address public beneficiary = 0x4f4986B5EBC5fd6Cb1E43FEA54Fa6b1d28Cf9a23;
    uint constant private fundingGoal = 100 ether;
    uint constant public price = 0.01 ether;
    uint constant public limit = 1 ether;

    /** using safe math */
    using SafeMath for uint256;
    
    /** amout of ether raised */
    uint public amountRaised;
    /** crowdsale deadline */
    uint public deadline;
    Token private tokenReward;
    Funder[] public funders;

    /** mapping
        limit of purchaser
     */
    mapping (address => uint) private _limits;

    /** event
        check fundtransder
     */
    event FundTransfer(address backer, uint amount, bool IsContribution);

    /** 
        data structure to hold information about campaign contributors 
    */
    struct Funder {
        address addr;
        uint amount;
    }

    /** modifier
     check if deadline is came
     */
    modifier afterDeadline() {
        require(now >= deadline);
        _;
    }

    // limit of purchase
    modifier limitOfPurchase(address _beneficiary) {
        require(_limits[_beneficiary] < limit);
        _;
    }

    /** at initialization  setup user  */
    function Crowdsale(
        address _beneficiary, 
        uint _fundingGoal,
        uint _duration,
        uint _price,
        Token _reward
        ) public {
        beneficiary = _beneficiary;
        deadline = now.add(_duration.mul(1 minutes));
        tokenReward = _reward;
    }

    /** the function without name is
     default function that is called whenever anyone sends
     fund - fallback function
     */
     function () public {
         uint amount = msg.value;
         funders[funders.length++] = Funder({addr: msg.sender, amount: amount});
         amountRaised = amountRaised.add(amount);
         tokenReward.transfer(msg.sender, amount.div(price));
         emit FundTransfer(msg.sender, amount, true);
     }

     /** check if the goal 
        or time limit has been reached and ends the campaign 
     */
    function checkGoalReached() afterDeadline {
        if (amountRaised >= fundingGoal){
            beneficiary.transfer(amountRaised);
            emit FundTransfer(beneficiary, amountRaised, false);
        } else {
            emit FundTransfer(0, 11, false);
            for (uint i = 0; i <funders.length; i++){
                funders[i].addr.transfer(funders[i].amount);
                emit FundTransfer(funders[i].addr, funders[i].amount, false);
            }
        }
        selfdestruct(beneficiary);
        /** because selfdestruct was removed from v0.4.24 */
    }

}
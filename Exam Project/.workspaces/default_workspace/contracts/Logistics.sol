pragma solidity ^0.4.24;

contract logistics{

    ///////////////Variables//////////////////
    address Owner;
 
    struct package{
        bool isuidgenerated; // Every time a order is placed the smart contract generates a unique/authentic ID for the order
        uint itemid; // The identification number for the items ordered
        string itemname;
        address customer;
        uint ordertime;
        string transitstatus; //
        address carrier1;
        uint carrier1_time;
        uint orderstatus; // 1 = ordered, 2 = in-transit, 3 = delivered, 4 = cancelled
  }

    mapping (address => package) public packagemapping; //This packagemapping function is used to fill in all the orderdetail variables from the order placed in the OrderItem function. 
    mapping (address => bool) public carriers; // This ensures that only those carriers authorized to interact with the smart contract can do that. 

//////////////////Variables End//////////////////

//////////////////////Modifier//////////////////
    constructor(){
        Owner = msg.sender;

    }
    modifier onlyOwner(){
        require(Owner == msg.sender);
        _;
    }
////////////////////Modifier End//////////////////

//////////////////////Manage Carriers////////////////// 
// This function allows the administrator to edit the status of the carrier
    function ManageCarriers(address _carrierAddress) onlyOwner public returns (string){
        if(!carriers[_carrierAddress]){
            carriers[_carrierAddress] = true;
        } else {
            carriers[_carrierAddress] = false;
        }
        return "Carrier is Updated";
    }


   ///////////////OrderItem Function//////////////////
// This function appends the order information to the the order package

    function OrderItem(uint _itemid, string _itemname) public returns (address){ //
        address uniqueId = address(sha256(msg.sender, now)); // This ensures that UniqueID generates is unique

        packagemapping[uniqueId].isuidgenerated = true;
        packagemapping[uniqueId].itemid = _itemid;
        packagemapping[uniqueId].itemname = _itemname;
        packagemapping[uniqueId].transitstatus = "Your Package is ordered and is being processed";
        packagemapping[uniqueId].orderstatus = 1;

        packagemapping[uniqueId].customer = msg.sender;
        packagemapping[uniqueId].ordertime = now;

        return uniqueId;
    }
   ///////////////OrderItem Function END//////////////////


///////////Cancel Order ///////////////////
//This function allows the user to cancel the order
    function CancelOrder(address _uniqueId) public returns (string){
        require(packagemapping[_uniqueId].isuidgenerated = true); // built in function that throws error if uniqueId is not generated
        require(packagemapping[_uniqueId].customer == msg.sender); // This checks that it is the correct customer that is cancelling the order and not a different customer

        packagemapping[_uniqueId].orderstatus = 4;
        packagemapping[_uniqueId].transitstatus = "Your order has been cancelled";

        return "Your order has been cancelled successfully";
    }

//////////Carriers///////////////
//This function allows you to assign the order for dispatch to Carrier 1

    function Carrier1Report(address _uniqueId, string _transitStatus) public returns (string){
        require(packagemapping[_uniqueId].isuidgenerated=true);
        require(carriers[msg.sender]=true);
        require(packagemapping[_uniqueId].orderstatus == 1);

        packagemapping[_uniqueId].transitstatus = _transitStatus;
        packagemapping[_uniqueId].carrier1 = msg.sender;
        packagemapping[_uniqueId].carrier1_time = now;
        packagemapping[_uniqueId].orderstatus = 2;

        return "Order successfully dispatched with Carrier 1";
    } 

}


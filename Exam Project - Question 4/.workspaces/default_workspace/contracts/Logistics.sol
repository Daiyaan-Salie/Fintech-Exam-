pragma solidity ^0.4.24;

contract logistics{

//Variables
    address Owner;
 
    struct package{
        bool isuidgenerated; // Every time a order is placed the smart contract generates a unique/authentic ID for the order
        uint itemid; // The identification number for the items ordered
        string itemname;
        address customer;
        uint ordertime;
        string transitstatus;
        address carrier1;
        uint carrier1_time;
        uint orderstatus; // 1 = ordered, 2 = in-transit, 3 = delivered, 4 = cancelled
  }

    mapping (address => package) public packagemapping; //Id of package will key and the value of the key 
    mapping (address => bool) public carriers; // This ensures that only those carriers authorized to interact with the smart contract can interact. 

//Modifier
    constructor(){
        Owner = msg.sender; //The person deploying the contract will be the owner
    }
    modifier onlyOwner(){ //This modifier can be used in other functions as a condition where the function will only execute if the person caliing the function is the owner of the contract
        require(Owner == msg.sender);
        _;
    }

//Order an Item
// This function creates an address variable with the order information to be stored.

    function OrderItem(uint _itemid, string _itemname) public returns (address){
        address uniqueId = address(sha256(msg.sender, now)); // Sha256 has been used to encode the address of the person executing the contract to obtain a uniqueID

        packagemapping[uniqueId].isuidgenerated = true;
        packagemapping[uniqueId].itemid = _itemid;
        packagemapping[uniqueId].itemname = _itemname;
        packagemapping[uniqueId].transitstatus = "Your Package is ordered and is being processed";
        packagemapping[uniqueId].orderstatus = 1; //Update order status to ordered
        packagemapping[uniqueId].customer = msg.sender; // This is the address of the customer executing this contract
        packagemapping[uniqueId].ordertime = now;

        return uniqueId;
    }

//Cancel an Order
//This function allows the user to cancel the order
//This function satisifies the 4th user story.
    function CancelOrder(address _uniqueId) public returns (string){
        require(packagemapping[_uniqueId].isuidgenerated = true); // built in function that throws error if uniqueId is not generated/ does not exist
        require(packagemapping[_uniqueId].customer == msg.sender); // This checks that the customer cancelling the order is the same customer that placed the order.
        packagemapping[_uniqueId].orderstatus = 4; // Update order status to cancelled
        packagemapping[_uniqueId].transitstatus = "Your order has been cancelled";

        return "Your order has been cancelled successfully";
    }

//Manage Carriers
// This function allows the administrator to authorise new carriers
//This function satisifies the 2nd user story
    function ManageCarriers(address _carrierAddress) onlyOwner public returns (string){
        if(!carriers[_carrierAddress]){
            carriers[_carrierAddress] = true;
        } else {
            carriers[_carrierAddress] = false;
        }
        return "Carrier Updated";
    }

//Carriers
//This function allows you to assign the order for dispatch to Carrier 1
//This function enables the 1st User story to be satisfied
    function Carrier1Report(address _uniqueId, string _transitStatus) public returns (string){
        require(packagemapping[_uniqueId].isuidgenerated=true);
        require(carriers[msg.sender]=true);
        require(packagemapping[_uniqueId].orderstatus == 1); //this requires the the order status be "ordered"

        packagemapping[_uniqueId].transitstatus = _transitStatus;
        packagemapping[_uniqueId].carrier1 = msg.sender;
        packagemapping[_uniqueId].carrier1_time = now;
        packagemapping[_uniqueId].orderstatus = 2; //Set order status to in-transit

        return "Order successfully dispatched with Carrier 1";
    } 
}

//All the require functions in each of the functions ensure that only authorized individual can execute the function
//which satisfies the 3rd user story.

//The use of blockchain for this system ensures that data storage is reliable, data is transparant and maintains data integrity.
//The use of blockchain satisfies the 5th user story


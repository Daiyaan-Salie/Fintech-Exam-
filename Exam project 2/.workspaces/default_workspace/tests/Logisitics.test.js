// Right click on the script name and hit "Run" to execute
const { expect } = require("chai");
const { ethers } = require("hardhat");

//This tests to see that the contract was sucessfully deployed.
describe("Logistics Deployment", function () {
  it("Test successful deployment of contract", async function () {
    const Logistics = await ethers.getContractFactory("Logistics");
    const logistics = await Logistics.deploy();
    await logistics.deployed();
  });
});

//This tests to see if 







//This tests to see if the CancelOrder function successfullly runs.
describe("Order Cancelled", function () {
  it("tests successfull cancelation of order", async function () {
    const Logistics = await ethers.getContractFactory("Logistics");
    const logistics = await Logistics.deploy();
    await logistics.deployed();
    const ID = (await logistics.OrderItem(123,"iPhone"));
    expect(await logistics.CancelOrder(ID)).to.equal("Your order has been cancelled successfully");
  });
});



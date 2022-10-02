//SPDX-License-Identifier: GPL-3.0

pragma solidity >0.4.0 <0.9.0;


contract auction2{

// Develop a smart contract for Ethereum Blockchain for conducting an Auction. The smart contract should be able to do below mentioned activities: 
// 1) Let users create an Auction
// 2) Let users End an Auction
// 3) Let users place bid on the auction created by others
// 4) Let Auction Owners select a bid of their choice and mark auction as completed 
// 5) let Bid owners see details of their bids on a particular auction
// 6) Let Auction Owners see details of a particular auction created by them . 


    mapping(address=>uint) biddersData;
    uint highestBidAmount;
    address highestBidder;


    //Time Functionality
    // uint startTime=block.timestamp;
    // uint endTime;
    
    address owner;
    bool auctionEnded=false;

    constructor(){
        owner=msg.sender;
    }



    modifier onlyOwner(){require(msg.sender==owner, "you don't have access"); _;}
    modifier notOwner(){require(msg.sender!=owner, "Owner can't participate"); _;}

    function putBid() public payable notOwner{

        uint calculateAmount=biddersData[msg.sender]+msg.value;

        //require(block.timestamp<endTime,"Auction has been Ended");
        require(msg.value>0,"Bid cannot be zero");
        require(auctionEnded==false,"Auction has been Ended");

        biddersData[msg.sender]=calculateAmount;

        require(calculateAmount>highestBidAmount,"Amount is equal or smaller then the highest bid amount");
        biddersData[msg.sender]=calculateAmount;
        highestBidAmount=calculateAmount;
        highestBidder=msg.sender;


    }

    function getHighestBid() public view onlyOwner returns(uint){
        return highestBidAmount;
    }

    function getHighestBidder() public view returns(address){

        return highestBidder;
    }

    //End time of aution
    // function putTime(uint _endTime) onlyOwner public{
    //     require(auctionEnded==false,"Can't Change time, Auction has been Ended");
    //     endTime=_endTime;
    // }

    //Will end auction and make highest bidder the winner
    function endAuction() public onlyOwner {
        //require(msg.sender==owner,"Access Denied!");
        auctionEnded=true;
    }

    function withdrawBid() public payable notOwner{
        require(biddersData[msg.sender]>0 &&msg.sender!=highestBidder,"You did not bid or your amount has been returned");
        require(msg.sender!=highestBidder, "Winner can not withdraw.");

            address(msg.sender).transfer(biddersData[msg.sender]);
            biddersData[msg.sender]=0;
        
    }


    function getBiddersBid(address _address) public view onlyOwner returns(uint){

        return biddersData[_address];

    }

    //end auction and declare winner of owner's choice
    function declareWinner(address _address) public onlyOwner{
        highestBidder=_address;
        auctionEnded=true;
    }


    function myBid() public notOwner view returns(uint){
        return biddersData[msg.sender];
    }

}
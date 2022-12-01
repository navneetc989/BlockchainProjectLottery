//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Lottery {
    address payable[] public players;
    address manager; //change
    address payable public winner; //new change

    constructor() {
        manager = msg.sender;
    }

    receive() external payable {
        require(msg.value == 1 ether, "Please pay 1 ether only"); //change
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint256) {
        require(msg.sender == manager, "You are not the manager"); //change
        return address(this).balance;
    }

    function random() internal view returns (uint256) {
        uint size = 100;
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        size
                    )
                )
            );
    }
/*
    uint arrSize = (players.length*(players.length+1))/2;
    uint[arrSize] public arr;
    */

    uint[] public arr;
    uint count;
    uint temp;

    function pickWinner() public {
        //change
        //player length = players.length

        //Creating an array of size n(n+1)/2
      
        require(msg.sender == manager, "You are not the manager"); //change
        require(players.length >= 3, "Players are less than 3"); //change

        for(uint i = 0; i < players.length; i++) {
             temp = players.length-1-i;
             while(temp>=0) {
                 arr.push(i);
                 count++;
                 temp--;
             }
        }
        uint256 r = random();
        uint256 index = r % arr.length;
        uint arrIndex = arr[index];
        winner = players[arrIndex];
        winner.transfer(getBalance());
        players = new address payable[](0);
    }

    function allPlayers() public view returns(address payable[] memory) {
        return players;
    }
}



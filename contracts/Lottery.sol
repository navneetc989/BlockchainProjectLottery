//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Lottery {
    address payable[] public participants;
    address manager; //change
    address payable public winner; //new change

    constructor() {
        manager = msg.sender;
    }

    receive() external payable {
        require(msg.value == 1 ether, "Please pay 0.1 ether only"); //change
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint256) {
        require(msg.sender == manager, "You are not the manager"); //change
        return address(this).balance;
    }

    function random() internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        participants.length
                    )
                )
            );
    }

    function selectWinner() public {
        //change
        require(msg.sender == manager, "You are not the manager"); //change
        require(participants.length >= 3, "Participants are less than 3"); //change

        uint256 r = random();

        uint256 index = r % participants.length;

        winner = participants[index];

        winner.transfer(getBalance());

        participants = new address payable[](0);
    }

    function allParticipants() public view returns(address payable[] memory) {
        return participants;
    }
}

//Contract add - 0x80191032fB4d309501d2EBc09a1A7d7F2941C8C1

//Ganache contract add - 0x9B1D7bd063Be226c3FbafCEb43891552bD02DadE


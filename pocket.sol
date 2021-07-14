pragma solidity ^0.8.0;
import './otter.sol';
// Visit OtterPocket.io for more information!
// SPDX-License-Identifier: MIT

contract OtterPocket {
  uint256 public fee;
  address owneraddress;

  mapping ( address => User) public users;
  standardToken Otter = standardToken(0xE718EDA678AFF3F8d1592e784652BcbEeb49e352);
  struct User {
    uint count;
    mapping (uint => File) files;
  }
  struct File {
    uint fileID;
    string fileHash;
    uint fileSize;
    string fileType;
    string fileName;
    string fileDescription;
    uint uploadTime;
  }
   constructor() {
       owneraddress = msg.sender;
    }
    
  function changeFee(uint256 newFee) public {
      require(msg.sender == owneraddress);
      fee = newFee;
  }

  function uploadFile(string memory _fileHash, 
    uint _fileSize,
    string memory _fileType,
    string memory _fileName,
    string memory _fileDescription
  ) public {
    
    require(bytes(_fileHash).length > 0);
    require(bytes(_fileType).length > 0);
    require(bytes(_fileName).length > 0);
    require(bytes(_fileDescription).length > 0);
    require(_fileSize > 0);

    address feeWallet = address(0xd54CE8922eEbBeb76898d75015fCf09f6538640b);
    Otter.transferFrom(msg.sender,feeWallet, fee * 10 ** 18);
    users[msg.sender].count++;
    users[msg.sender].files[users[msg.sender].count] = File(users[msg.sender].count,_fileHash,_fileSize,_fileType,_fileName,_fileDescription, block.timestamp);
  }
  function getFile(address user, uint fileIndex) public view returns (uint[3] memory, string[4] memory){

      uint[3] memory numbers = [users[user].files[fileIndex].fileID, users[user].files[fileIndex].fileSize,users[user].files[fileIndex].uploadTime];
      string[4] memory strings = [users[user].files[fileIndex].fileHash,users[user].files[fileIndex].fileType, users[user].files[fileIndex].fileName, users[user].files[fileIndex].fileDescription];
      
      return (numbers, strings); 
    }
    
}

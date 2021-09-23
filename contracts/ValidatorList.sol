// SPDX-License-Identifier: UNLICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ValidatorList is Ownable {
    mapping(address => bool) validators;
    address[] validatorIndex;

    event ValidatorDeleted(address indexed validator);

    modifier onlyValidator() {
        require(validators[msg.sender], "ERROR: msg.sender isn't validator");
        _;
    }

    function _addValidator(address validator) internal onlyOwner {
        // todo проверка на адрес
        validators[validator] = true;
        validatorIndex.push(validator);
    }

    function removeValidator(address validator) internal onlyOwner {
        require(
            validatorIndex.length > 1,
            "ERROR: last validator cannot be deleted"
        );
        require(validators[validator] != false, "ERROR: wrong validator");

        for (uint256 i = 0; i < validatorIndex.length; i++) {
            if (validatorIndex[i] == validator) {
                validatorIndex[i] = validatorIndex[validatorIndex.length - 1];
                validatorIndex.pop();
                break;
            }
        }
        validators[validator] = false;

        emit ValidatorDeleted(validator);
    }

    // todo: зачем может понадобиться эта  функция ? и должна ли из отображения удалять?
    function removeByIndex(uint256 i) public onlyOwner {
        require(
            validatorIndex.length > 1,
            "ERROR: last validator cannot be deleted"
        );

        validatorIndex[i] = validatorIndex[validatorIndex.length - 1];
        validatorIndex.pop();
    }

    function _findIndex(address validator) internal view returns (uint256 i) {
        for (i = 0; i < validatorIndex.length; i++) {
            if (validatorIndex[i] == validator) {
                return i;
            }
        }
    }

    function _validatorNum() public view returns (uint256) {
        return validatorIndex.length;
    }
}

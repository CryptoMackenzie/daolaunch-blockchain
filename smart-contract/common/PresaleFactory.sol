// SPDX-License-Identifier: UNLICENSED

// This contract logs all presales on the platform

pragma solidity ^0.6.12;

import "../common/Ownable.sol";
import "../common/EnumerableSet.sol";

contract PresaleFactory is Ownable {
    using EnumerableSet for EnumerableSet.AddressSet;

    EnumerableSet.AddressSet private presales;
    EnumerableSet.AddressSet private presaleGenerators;

    mapping(address => EnumerableSet.AddressSet) private presaleOwners;

    event presaleRegistered(address presaleContract);

    function adminAllowPresaleGenerator(address _address, bool _allow)
        public
        onlyOwner
    {
        if (_allow) {
            presaleGenerators.add(_address);
        } else {
            presaleGenerators.remove(_address);
        }
    }

    /**
     * @notice called by a registered PresaleGenerator upon Presale creation
     */
    function registerPresale(address _presaleAddress) public {
        require(presaleGenerators.contains(msg.sender), "FORBIDDEN");
        presales.add(_presaleAddress);
        emit presaleRegistered(_presaleAddress);
    }

    /**
     * @notice Number of allowed PresaleGenerators
     */
    function presaleGeneratorsLength() external view returns (uint256) {
        return presaleGenerators.length();
    }

    /**
     * @notice Gets the address of a registered PresaleGenerator at specified index
     */
    function presaleGeneratorAtIndex(uint256 _index)
        external
        view
        returns (address)
    {
        return presaleGenerators.at(_index);
    }

    /**
     * @notice returns true if the presale address was generated by the DAOLaunch presale platform
     */
    function presaleIsRegistered(address _presaleAddress)
        external
        view
        returns (bool)
    {
        return presales.contains(_presaleAddress);
    }

    /**
     * @notice The length of all presales on the platform
     */
    function presalesLength() external view returns (uint256) {
        return presales.length();
    }

    /**
     * @notice gets a presale at a specific index. Although using Enumerable Set, since presales are only added and not removed, indexes will never change
     * @return the address of the Presale contract at index
     */
    function presaleAtIndex(uint256 _index) external view returns (address) {
        return presales.at(_index);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {Reclaim} from "../src/Reclaim.sol";

contract ReclaimScript is Script {
    string constant ADDRESSES_PATH = "deployments/addresses.json";

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        Reclaim reclaim = new Reclaim();

        vm.stopBroadcast();

        console.log("Reclaim deployed at:", address(reclaim));
        console.log("Owner:", reclaim.owner());
        console.log("Current epoch:", reclaim.currentEpoch());

        _saveDeployment(address(reclaim));
    }

    function _saveDeployment(address reclaim) internal {
        string memory chainId = vm.toString(block.chainid);
        string memory addrStr = vm.toString(reclaim);

        if (!vm.exists(ADDRESSES_PATH)) {
            vm.writeFile(ADDRESSES_PATH, "{}");
        }

        vm.writeJson(addrStr, ADDRESSES_PATH, string.concat(".", chainId));

        console.log("Saved deployment to", ADDRESSES_PATH, "for chain", chainId);
    }
}

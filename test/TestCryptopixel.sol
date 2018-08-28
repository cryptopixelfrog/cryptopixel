pragma solidity ^0.4.23;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Cryptopixel.sol";

contract TestCryptopixel {
    Cryptopixel cPixel = Cryptopixel(DeployedAddresses.Cryptopixel());
    address addr = 0x174B3C5f95c9F27Da6758C8Ca941b8FFbD01d330;

    function testGroup() public {
    	//address addr = cPixel.creatorAddr();

        uint returnedId = cPixel.group(addr, 4);
        uint expacted = 4;
        Assert.equal(returnedId, expacted, "4 should be recorded in group.");
    }


    // Testing mintWithMetadata
    function testMint() public {
    	//address addr = cPixel.creatorAddr();
    	uint256 expacted = 1;
    	string memory metadata = "[{index:0}]";

    	cPixel.mintWithMetadata(addr, 0, metadata);
    	uint256 total = cPixel.totalSupply();
    	
    	Assert.equal(total, expacted, "1 token have minted.");
    }


    // Testing mint with wrong address other then creators wallet address
    function testMintWithWrongAddr() public {
    	Assert.isFalse(execute('mintWithWrongAddr()'), "Should fail minting other than creator.");

    	// Check actual mint happens
    	uint256 expacted = 1;
    	uint256 total = cPixel.totalSupply();
    	Assert.equal(total, expacted, "1 token have minted.");
    }

    
    // Testing max token minting
    function testMintLimit() public {
    	//address addr = cPixel.creatorAddr();
    	string memory metadata = "[{index:0}]";

    	// Frist token have minted at testMint, so i start from 1.
    	for (uint i = 1; i <= 51; i++) {
    		cPixel.mintWithMetadata(addr, i, metadata);
    	}
    	// At this point, totalSupply is 52(0~51)
    	uint256 total = cPixel.totalSupply();
    	Assert.equal(total, 52, "52 token have minted.");

    	// Now, try to mint 53rd token, which has to be impossible.
    	Assert.isFalse(execute('mintOverLimit()'), "Should fail over limit.");
    }
	



    // Helper functions
    // https://github.com/trufflesuite/truffle/issues/708
    function execute(string signature) internal returns (bool) {
    	bytes4 sig = bytes4(keccak256(signature));
    	address self = address(this);
    	return self.call(sig);
    }
    function mintOverLimit() public {
    	//address addr = cPixel.creatorAddr();
    	string memory metadata = "[{index:0}]";
    	cPixel.mintWithMetadata(addr, 53, metadata);
    }
    function mintWithWrongAddr() public {
    	// This is not creators address
    	address wrongAddr = 0x194b3c5f95C9F27Da6758C8CA941B8fFBD01D330;
    	cPixel.mintWithMetadata(wrongAddr, 1, "[{index:0}]");
    }


    
}

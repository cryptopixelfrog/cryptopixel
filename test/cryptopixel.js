var Cryptopixel = artifacts.require("./Cryptopixel.sol");
var owner = '0x174b3c5f95c9f27da6758c8ca941b8ffbd01d330';

contract('Cryptopixel', function(accounts) {
  
  it("Testing name of token", function() {
    return Cryptopixel.deployed().then(function(instance) {
      return instance.name.call();
    }).then(function(result) {
      assert.equal(result, "CryptoPixel");
    });
  });
  
  //this is totalSupply before mint, so the totalSupply is 0
  it("Testing totalSupply", function() {
    return Cryptopixel.deployed().then(function(instance) {
      return instance.totalSupply.call();
    }).then(function(result) {
      assert.equal(result.valueOf(), 0);
    });
  });
  
});


describe("Testing mint: ", () => {
  
  it("Creates token with meta data 1", async () => {
    let instance = await Cryptopixel.deployed();
    let pixelId = 1
    let tokenUrl = "http://urltoimage" + pixelId;
    let token = await instance.mintWithMetadata(owner, pixelId, tokenUrl);
    let tokenId = await instance.totalSupply();
    let metaData = await instance.tokenMetadata(tokenId);
    assert.deepEqual(metaData, tokenUrl);
  });
  
  it("Creates token with meta data 2", async () => {
    let instance = await Cryptopixel.deployed();
    let pixelId = 2
    let tokenUrl = "http://urltoimage" + pixelId;
    let token = await instance.mintWithMetadata(owner, pixelId, tokenUrl);
    let tokenId = await instance.totalSupply();
    let metaData = await instance.tokenMetadata(tokenId);
    assert.deepEqual(metaData, tokenUrl);
  });
    
  it("Creates token with meta data 3", async () => {
    let instance = await Cryptopixel.deployed();
    let pixelId = 3
    let tokenUrl = "[{'id': 1,'name': 'Good1','image': 'images/08.gif','gifheader': 3,'imghash': 'Scottish Terrier','size': '140 x 180'}]";
    let token = await instance.mintWithMetadata(owner, pixelId, tokenUrl);
    let tokenId = await instance.totalSupply();
    let metaData = await instance.tokenMetadata(tokenId);
    assert.deepEqual(metaData, tokenUrl);
  });
  
  //This is after mint, so the totalSupply should be 3.
  it("Testing totalSupply", function() {
    return Cryptopixel.deployed().then(function(instance) {
      return instance.totalSupply.call();
    }).then(function(result) {
      assert.equal(result.valueOf(), 3);
    });
  });
  
  it("Testing ownerOf", async () => {
    let instance = await Cryptopixel.deployed();
    let ownerOf = await instance.ownerOf(1);
    assert.equal(ownerOf, owner);
  });
  
  // Total token limit is 52
  it("Testing creator group", async () => {
    let instance = await Cryptopixel.deployed();
    let group = await instance.getArtworkGroup();
    assert.equal(group.length, 52);
  });
  


});
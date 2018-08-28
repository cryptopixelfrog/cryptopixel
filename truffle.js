const HDWalletProvider = require("truffle-hdwallet-provider");
const NonceTrackerSubprovider = require("web3-provider-engine/subproviders/nonce-tracker");
const ropsteninfura = "https://ropsten.infura.io/v3/...";
const mainnetinfura = "https://mainnet.infura.io/v3/...";
const passphrase = "...";

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      gas: 6712388,
      gasPrice: 65000000000,
      network_id: "*" // Match any network id,
    },
    "ropsten-infura": {
      provider: () => new HDWalletProvider(passphrase, ropsteninfura),
      network_id: 3,
      gas: 4700000
    },
    "mainnet-infura": {
      network_id: 1,
      provider: function () {
        var wallet = new HDWalletProvider(passphrase, mainnetinfura)
        var nonceTracker = new NonceTrackerSubprovider()
        wallet.engine._providers.unshift(nonceTracker)
        nonceTracker.setEngine(wallet.engine)
        return wallet
      },
      gas: 3000000,
      gasPrice: 5000000000
    }
  }
};

const HDWalletProvider = require('truffle-hdwallet-provider');
const config = require('./config');
module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*",
      gas: 1000000,
      gasPrice: 10000000000,
    },
    infura: {
      provider: function() {
        return new HDWalletProvider(config.account.mnemonic, config.url)
      },
      network_id: 3,
      gas: 4700000,
      gasPrice: 10000000000
    }
  }
};
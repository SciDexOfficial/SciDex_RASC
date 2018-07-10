var HDWalletProvider = require("truffle-hdwallet-provider");

const mnemonic = process.env.MNEMONIC
const fromAddress = process.env.FROM_ADDRESS

module.exports = {
  networks: {
    local: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "5777",
      from: "0x32137f2A13eA73d5Fc45881565Fcf7Ed00c21eaf",
      gasPrice: 1,
      gas: 999999999999998
    },
    development: {
      host: "localhost",
      port: 8501,
      network_id: "*", 
      gasprice: 1
    },
    rinkeby: {
      provider : () => new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/3vj9Xnohf6SSZo69i0aH"), // TODO: change with our own node addres
      from: fromAddress.toLowerCase(),
      network_id: "4",
      gas: 6712390
    },   
    main: {
      provider : () => new HDWalletProvider(mnemonic, "https://mainnet.infura.io/3vj9Xnohf6SSZo69i0aH"), // TODO: change with our own node addres
      from: fromAddress.toLowerCase(),
      network_id: "1",
    }
  }
};
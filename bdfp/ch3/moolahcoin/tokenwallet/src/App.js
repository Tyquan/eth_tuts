import React from 'react';
import InstallMetamask from './Components/Core/InstallMetamask';
import "./App.css";

// Only using class based until end of project then switching to fuctional components
class App extends React.Component
{
  constructor() {
    super();
    this.appName = "MollahCoin Token Wallet";
    this.isWeb3 = true;
    this.state = {
      inProgress: false,
      tx20: null,
      tx721: null,
      network: 'Checking...',
      account: null,
      tokens20: [],
      tokens721: [],
      transferDetail20: {},
			transferDetail721: {},
			mintDetail20: {},
			mintDetail721: {},
			approveDetail20: {},
			approveDetail721: {},
      fields: {
        receiver: null,
        amount: null,
				metadata: null,
				tokenId: null,
        gasPrice: null,
        gasLimit: null,
      },
      defaultGasPrice: null,
      defaultGasLimit: 200000
    };
  }

  render() {
    if (this.isWeb3) {
      return (
        <h1>Web3 Available! Start Coding</h1>
      );
    } else {
      return (
        <InstallMetamask />
      );
    }
  }
}

export default App;

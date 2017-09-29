import React, { Component } from 'react';
import logo from './logo.svg';
import auction from './auction.jpg';
import './App.css';
import {auctionContract, ETHEREUM_CLIENT} from './EthereumSetup';

/* if (typeof web3 !== 'undefined') {
  web3 = new Web3(web3.currentProvider);
} else {
  // set the provider you want from Web3.providers
  web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
} */

class App extends Component {
  constructor(props) {
    super(props)
    this.state = {
      itemCount: 0,
      contract: auctionContract
    }
 }
 componentWillMount() {
  var data = auctionContract.itemCount()
  this.setState({
    itemCount: data
  });
 }
  myFunction() {
        console.log(this.state.itemCount)
        var increment = auctionContract.increment({from: '0xda0b37e1b4fc3238cdeac9e019f023e24fc80ddf'})
        console.log(increment)
    }
  render() {
    return (
      <div className="App">
        <header className="App-header">
          <img src={auction} className="App-logo" alt="logo" />
          <h1 className="App-title">Decentralized Auction</h1>
        </header>
        <p className="App-intro">
          Welcome to the Decentralized Auction, where you have total control and the payouts are instant.
        </p>
        <p className="App-text">
          Current number of items on sale: {this.state.itemCount.toString()}
        </p>
        <br/>
      <button id="sellButton" onClick={this.myFunction()}>Sell something!</button>
      </div>
    );
  }     
}

/* methods.increment({from: ETHEREUM_CLIENT.eth.accounts[0]}) */




export default App;

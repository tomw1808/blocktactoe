# Introduction
## CODE UPDATED Jan 29, 2019 -- SEE UPDATES SECTION BELOW!
This is the official repository for the Course "Ethereum Game Development: Build A Game On The Blockchain". In this course you learn how to build a simple, but fun game that runs on the blockchain from scratch: Tic Tac Toe.

We will cover everything from A to Z:

1. Solidity Basics, from the General File-Layout, Types, Events, Structs and Arrays and many more topics.
2. Development tools, such as Truffle, Web3/Truffle-Contract
3. Everything there is to know about different blockchains and nodes and how they operate
4. All you need to know about safely storing and sending/transferring Ether from or to Smart Contracts
5. And finally, how to test and publish this game live

4.5 hours of the course are pure hands-on and practical learning, while approx. 30 minutes are theory and general "good-to-knows". The Course is extremely hands-on and it's recommended to follow it's step-by-step structure.

# How To Run This Game
To run this game you and your opponent need access to the same blockchain. Either install MetaMask and choose the right network, or start your own blockchain node with go-ethereum or parity and connect to it.

Then go to https://tomw1808.github.io/blocktactoe/

# How To Install from the Repository

1. Install [Git](https://git-scm.com/downloads)
2. and [NodeJS](https://nodejs.org/en/download/) (including NPM) on Your Computer
3. Open a Terminal/Command Line and then `git clone https://github.com/tomw1808/blocktactoe.git"
4. `cd blocktactoe`
5. `npm install`
6. `npm install -g truffle`
7. `npm install -g ganache-cli`
8. Open Ganache: `ganache-cli`
9. Open a _second_ Terminal/Command Line in the same folder and type in
10. `truffle migrate` to deploy the smart contracts on Ganache
11. `npm run dev` to start the webpack dev server
12. Then open your browser

# Questions/Suggestions?

Feel free to reach out any time! Best is the Course Q&A Forum where dedicated staff is helping out.

# UPDATES Jan 29, 2019

All the code was updated to work with the latest Truffle 5 and Solidtiy 0.5.2. There is a minor warning about an older Webpack-dev-server which can be ignored for now.
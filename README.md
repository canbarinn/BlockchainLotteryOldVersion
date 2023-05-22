# LotteryChain



<!-- PROJECT LOGO -->
<br />
<div align="center">
   <p align="center">
<img src="https://github.com/canbarinn/BlockchainLotteryOldVersion/assets/57272836/e4a3d0fb-f1fe-47e6-abeb-5280c50f48dd">
 </p>

  <h3 align="center">Our Project ReadMe</h3>

  <p align="center">
    An awesome README to get along with our project for our CMPE 483 course
    <br />
    <a href="https://github.com/othneildrew/Best-README-Template"><strong>Explore the docs »</strong></a>
    <br />
    <br />

  </p>
</div>



<!-- TABLE OF CONTENTS -->

  ## Table of Contents
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#documentation">Built With</a></li>
       <li><a href="#built-with">Installation</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>




<!-- ABOUT THE PROJECT -->
## About The Project

This Repo gives a briefly insight about our implementation of an autonomous decentralized lottery system within a Blockchain environment. Herefore we used Solidity and the Ethereum Development Environment HardHad to deploy our contract on a ficticious node within a locally runned Ethereum Blockchain. 



### Documentation

You can download the documentation [here](https://github.com/canbarinn/BlockchainLotteryOldVersion/blob/main/Documentation.docx)

### Built With

* ![Solidity](https://img.shields.io/static/v1?style=for-the-badge&message=Solidity&color=363636&logo=Solidity&logoColor=FFFFFF&label=)
* ![npm](https://img.shields.io/static/v1?style=for-the-badge&message=npm&color=CB3837&logo=npm&logoColor=FFFFFF&label=)
* ![HardHat](https://img.shields.io/static/v1?style=for-the-badge&message=HardHat&color=FFEA00&logo=hardHat&logoColor=FFFF00&label=)




<!-- GETTING STARTED -->
## Getting Started

These are the instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

### Prerequisites

To run the project locally, we recommend to use visual studio code as an environment
* for linux Arch
  ```sh
  sudo pacman -S visual-studio-code-bin
  ```
* for linux Ubuntu
  ```sh
  sudo apt install code
  ```
* for Windows and Mac you can download it here [here](https://code.visualstudio.com/download)

  


In order to install hardhat into your local project you have to install npm 

* for linux Arch
  ```sh
  sudo pacman -S npm
  ```
* for linux Ubuntu
  ```sh
  sudo apt install npm
  ```
* for Windows and Mac you can follow these instrictions [here](https://radixweb.com/blog/installing-npm-and-nodejs-on-windows-and-mac)



### Installation

1. Clone the repo into a local folder
   ```sh
   git clone https://github.com/canbarinn/BlockchainLotteryOldVersion.git
   ```
   
2. Open your project in VS Code.

3. Open the Terminal by clicking on "Terminal" in the top menu and selecting "New Terminal."

4. In the Terminal, navigate to your project's directory using the cd command. For example, if your project is in the my-project directory, you would run cd my-project.

5.Once you're in your project's directory, run the following command to install Hardhat, Chai, and Mocha as dev dependencies:

 ```sh
   npm install --save-dev hardhat chai mocha
   ```


## Hardhat

We used HardHat to test our Solidity contract. 

"Hardhat is a development environment for Ethereum software. It consists of different components for editing, compiling, debugging and deploying your smart contracts and dApps, all of which work together to create a complete development environment."

You can find more informations about HardHat [here](https://hardhat.org/hardhat-runner/docs/getting-started#overview)

<!-- USAGE EXAMPLES -->
## Usage

In order to run our hardHat tests, you have to navigate into your local project.

Afterwards, you  can ran each test by
 ```sh
   npx test [test directory]
   ```

for example, to run the scenarioTest.ts file, you can use 
 ```sh
   npx hardhat test test/scenarioTesting.ts
   ```




<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.





<!-- CONTACT -->
## Contact

Marcel - [@github_Profil](https://github.com/Mercyrion) - marcel.nam@web.de

Can - [@github_Profil](https://github.com/canbarinn) - 

Project Link: [LotteryChain](https://github.com/canbarinn/BlockchainLotteryOldVersion)






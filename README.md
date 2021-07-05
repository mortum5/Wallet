# Wallet 
> Test task implementation of a smart contract for Манзони company 


Смарт контракт реализован с использование фреймворка Truffle для удобного деплоя в любую из сетей Ethereum. На домашней станции был развернут Ganache для тестирования на пустом домашнем блокчейне. В качестве дальнейшего улучшение возможно реализовать честную покупку токенов за эфир, сократить размер смарт контракта, а также использование more secure library e.g. [OpenZeppelin](https://github.com/OpenZeppelin/openzeppelin-contracts)

На данный момент реализован функционал:
* Хранение и снятие эфира без доп. комиссии. 
* Перевод на другие адресса эфир с комиссией, которую позже можно снять со счёта. 
* Изменение размера доп. комиссии.
* Создание токенов почти соответствующих стандарту ERC20
* Возможность прямой передачи токенов или с использование third-party механизма благодаря allowance механике.
* Использование ручного подобия SafeMath библиотеки настолько насколько я её понял.

## Getting started

### Prerequisites
---
[Truffle](https://www.trufflesuite.com/docs/truffle/getting-started/installation)

### Installing
---
```bash
~$ git clone https://github.com/mortum5/Wallet.git
~$ cd Wallet
```

Edit truffle-config.js

```bash
~$ truffle compile
~$ truffle migrate --reset 
~$ truffle console
```

### Example of usage
---
```nodejs
truffle(development)> let instance = await Wallet.deployed()
truffle(development)> instance.getOwner()
'0x78b59a...'
truffle(development)> let accounts = await web3.eth.getAccounts()
> truffle(development)> instance.getBalanceEther().then(function(balance) { 
>    console.log(web3.utils.fromWei(balance,'ether'));
> })

```




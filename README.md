
## Welcome to capturethefoundry

_capturethefoundry_ is a platform to practice foundry skills like writing PoCs and debugging. Every module relates to a real life exploit, and a successful completion of the task will mean reproducing an actual hack.

## Introduction

Hey there, researcher! I've tried to write a test for the exploit but I can't seem to get it working. I'm quite new to this foundry thing and I don't know what I am doing wrong. My boss is breathing down my neck every minute and I don't want to lose my job. Please help me! I think there are **10 issues** to fix.

## Objectives

I believe the main invocation flow is correct, so please do not change the core functionalities (eg using another flashloan provider, using a different swap function). Look out for issues like typos, missing/wrong parameters, wrong function names etc.

1. Clone this repository locally (Make sure you have foundry installed)
2. Run the following command. The command should fail because of several compiler errors.  

```
    forge build
```
3. There are 10 issues in the current test file. Run this command when you have finished rectifying all the mistakes in the test suite.

```
    forge test --match-path test/SUT.t.sol -vv
```

You should see this in your console once all the issues are fixed: 

![Sucessful Test](images/testsuccess.png)

## Focus

Debugging / Fixing compiler errors

## Hints

Hmmm... I would start with examining at the interface... I think there are two problems there? Oh, and typos, I'm quite prone to typos.  

There's probably nothing wrong with the contract addresses, I've checked it many times so I wouldn't advice changing anything there... maybe something to do with the swapping functionality, or the depositing? Oh, I forgot to mention, I think the exploit uses BNB instead of WBNB... maybe the contract needs to accept BNB.

My console is broken so I can't see anything, but do pay attention to your command line as it'll tell you about the issues you need to rectify. Fix the issues one at a time and you'll be fine!

## Solution

The solution will be posted in the [solutions](https://github.com/capturethefoundry/sut/tree/main/solution/solution.md) folder. You can also DM me on [Twitter](https://twitter.com/cryptostaker22) if you're stuck and I'll guide you through the process.

Good luck, researcher!

## Context 

The [SUT](https://twitter.com/bulu4477/status/1682983956080377857) token was hacked on the [Binance Smart Chain](https://bscscan.com/tx/0xfa1ece5381b9e2b2b83cb10faefde7632ca411bb38dd6bafe1f1140b1360f6ae) and the attacker ran away with 32 BNB (~8k USD).


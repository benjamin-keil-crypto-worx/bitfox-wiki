## Installation

```shell
$ npm i bitfox@latest
$ npm install -g bitfox@lates
```

## Debugging & Tooling 

BitFox can be very overwhelming when it is used for the first time due to the complex nature of Trading Bots and 
the comprehensive feature list of  BitFox. 

In order to make life a little easier we have included debugging 
utilities that users of BitFox can leverage to start getting familiar with the library and ramp up quickly.

We **Highly** recommend that you read and got through the below Tutorial step by step.

**Import Bitfox into your Project**

```js
let {builder, BitFoxEngine} = require("bitfox").bitfox;
```

**Use The Builder interface to construct a bitfox Engine instance.**

```js
const engine = builder().requiredCandles(200)
    .sidePreference("long")
    .type("Telegram")
    .backtest(false)
    .pollRate(10)
    .public(true)
    .exchange("bybit")
    .symbol("BTCUSDT")
    .timeframe("4h")
    .amount(100)
    .profitPct(0.03)
    .stopLossPct(0.02)
    .fee(0.002)
    .key("FAKE_KEY")
    .secret("FAKE_SECRET")
    .life(false)
    .interval(10)
    .strategyExtras({period:12,stDev:3})
    .alertExtras({condition:"gt", targetPrice:20000})
    .notifyOnly(false)
    .build();
```

**Initialize the engine with the current config**

```js
await engine.setupAndLoadClient();
```
**Check Available Exchanges**

````js
console.log(BitFoxEngine.getExchanges());
````

**Check What Credentials are required for the given exchange**

````js
console.log(engine.getRequiredCredentials());
````

**Check What time frames are supported on the given exchange**

````js
console.log(engine.getTimeFrames());
````

**Check What Timeout is configured on the Exchange**

````js
console.log(engine.getTimeout());
````

**Check What API Rate Limits are in place on the given exchange**

````js
console.log(engine.getRateLimit());
````

**Check Markets on the Given Exchange**

````js
console.log(engine.getMarkets());
````

**Check What Symbols are available on the given exchange**

````js
console.log(engine.getSymbols());
````

**Check What Currencies are available on the given exchange**

````js
console.log(engine.getCurrencies());
````

## Starting a Simple Bot 

```js
let {BitFoxEngine, SuperTrend} = require("bitfox").bitfox;

let options = {
    "requiredCandles": 200,
    "sidePreference": "long",
    "backtest": true,
    "pollRate":10,
    "public": true,
    "exchangeName": "bybit",
    "symbol": "ADAUSDT",
    "timeframe": "15m",
    "amount": 100,
    "profitPct": 0.003,
    "fee": 0.02,
    "key": "FAKE_KEY",
    "secret": "FAKE_SECRET",
    "life": false,
    "interval": 10
}

(async  () =>{
    
    // Initialize the Engine via options instance 
    let engine = BitFoxEngine.init(options);

    // Alternatively initialize engine via the builder interface (Recommended instantiation flow!!)
    let builder = require("bitfox").bitfox.builder; // import the builder interface
    let engine2 = builder()
        .requiredCandles(200)
        .sidePreference("long")
        .backtest(true)
        .pollRate(10)
        .public(true)
        .exchange("bybit")
        .symbol("ADAUSDT")
        .timeframe("15m")
        .amount(100)
        .profitPct(0.003)
        .fee(0.02)
        .key("FAKE_KEY")
        .secret("FAKE_SECRET")
        .life(false)
        .interval(10)
        .build(); 
        
    // Set up the Exchage Client
    await engine.setupAndLoadClient()
    
    // Leverage A Strategy from bitfoxes strategy repository
    engine.applyStrategy(SuperTrend)
    // or Alternatively 
    let bitfox = require("bitfox").bitfox;
    engine.applyStrategy(bitfox.SuperTrend)
    
    // Set Up Event Handlers 
    engine.on('onStrategyResponse', (eventArgs) => {
        console.log(eventArgs)
    });

    engine.on('onMessage', (eventArgs) => {
        console.log(eventArgs)
    });
    engine.on('onError', (eventArgs) => {
        console.log(eventArgs)
    });
    engine.on('onOrderPlaced', (eventArgs) => {
        console.log(eventArgs)
    });
    engine.on('onOrderFilled', (eventArgs) => {
        console.log(eventArgs)
    });
    engine.on('onTradeComplete', (eventArgs) => {
        console.log(eventArgs)
    });
    engine.on('onStopLossTriggered', (eventArgs) => {
        console.log(eventArgs)
    });
    // SetUp Custom Event Handler (You need to fire the event yourself BitFox doesn't know about your Custom Event")
    engine.on('MyCustomEvent', (eventArgs) => {
        console.log(eventArgs)
    });
    
    // You could get the Event handler and fire an event by using below code
    engine.getEventEmitter().fireEvent("MyCustomEvent", {customEventData:"YourCustomEventData"})
    
    // Start The BitFox Engine
    await engine.run();
})();
```
If you would like to enable Notification to either Email, Slack or Telegram you need to add below properties

````js

//All Notifications
.notificationToken(YOUR_NOTIFICATION_TOKEN)

//Telegram Notifications optional if you don't supply this you need to type \start on your chat input to initialize the Notifier
.telegramChatId(YOUR_NOTIFICATION_TOKEN)

//Email Notifications Required:
.emailFrom("YourFromEmailAddress")
.emailTo("YourToEmailAddress)

````
See [Alerting & Notifications](alertsAndNotifications.md) for notification prerequisites and setup.

## The BitFox Engine Builder Interface

We are providing on top of the normal options engine instantiation an interface that allows you a more _stream lined_ instantiation
using the BitFox builder interface.

The Builder Interface is just a helper class that allows you to be more in control of creating BitFox Engines
By Using interface methods that set dedicated fields on the Engine.


```js

// The import of the builder interface
let {builder} = require("bitfox").bitfox;

let engine = builder()

    /*----------------------------------------------------------------------------------*/
    /*                      Backtesting Parameters                                      */
    /*----------------------------------------------------------------------------------*/
    
    // Back Testing Specific Parameter to indicate how many Candles should be retrieved with 
    // With every poll.
    .requiredCandles(Number)

    // Back Testing Specific Parameter to indicate how many times should poll candles
    // from the Exchange
    .pollRate(pollRate)

    /*----------------------------------------------------------------------------------*/
    /*                      Engine and Trade Execution Parameters Parameters            */
    /*----------------------------------------------------------------------------------*/

    // Engine Specific Parameter if this is set to true the Engine will  execute send limit orders 
    // and wait for them to be fully filled other simple market orders aer made! the Default is false
    .useLimitOrder(Boolean)

    // Engine Specific Parameter if this is set to true the Engine will not execute trades and only Notify 
    // you of Trade Signals from the Strategy. The Default is false
    .notifyOnly(Boolean)
    
    // Engine Specific Parameter sets the general interval and time to execute Strategy Logic 
    .interval(Number)

    // Engine  Specific Parameter setting a flag that tells the Engine to back test the Strategy
    .backtest(Boolean)

    // Engine  Specific Parameter setting a flag that tells the Engine to not use private API's to Exchange 
    // prevent's real trades to be executed!
    .public(Boolean)

    // Engine  Specific Parameter setting a flag that tells the Engine not send real order requests to the Exchange 
    // orders are mocked if this flag is set to false.!
    .life(Boolean)

    /*----------------------------------------------------------------------------------*/
    /*                      Exchange Specific Parameters                                */
    /*----------------------------------------------------------------------------------*/

    //Exchange Parameter you need to add this inorder to Identify the Exchange you want to use
    .exchange(String) 
    // Exchange Specific Parameter sets you desired Trading Pair i.e. ADAUSDT|BTCUSDT|ETHUSDT etc.
    .symbol(String)
    
    // Exchange Specific Parameter sets you desired timeframe for ohlcv candle data,
    // that is to be fetched from the Exchange 
    .timeframe(String)

    // Exchange & Engine Specific Parameter sets your desired Base amount that is to be used for trades
    .amount(Number)

    // Exchange & Engine Specific Parameter sets your desired Profit Target to exit long/short positions
    // this is a percentage i.e. 0.01 would indicate 1% higher or lower of the current price 
    .profitPct(Number)
    
    // Exchange & Engine Specific Parameter sets your desired Stop Loss Target to exit long/short positions
    // this is a percentage i.e. 0.01 would indicate 1% higher or lower of the current price
    .stopLossPct(Number)
    
    // Exchange & Engine Specific Parameter setting the exchange fee used to calculate better long/short profit and stop targets
    // this is a percentage i.e. 0.01 would indicate 1% higher or lower of the current price
    .fee(Number)
    
    // Exchange Specific Parameter : {'defaultType': 'spot', 'adjustForTimeDifference': true,'recvwindow':7000 }; 
    // This is an Advanced usage and allows users to leverage different trading products | spot | futures | margins etc we recommend to stick with 
    // spot and the default options for now. {'defaultType': 'spot', 'adjustForTimeDifference': true,'recvwindow':7000 },
    .options(String)

    // Exchange Specific Parameters
    // In Most Cases it is sufficent to just supply this value
    
    .key(String)
    .secret(String)
    
    // In Most Cases it is sufficent to just supply above key,secret values
    // But Some Exchange require Additional Authentication 
    // Parameters you need to figure out what Authentication Parameters 
    // your selected Exchange requires!
    
    .uid(String)
    .login(String)
    .password(String)
    .twofa(String)
    .privateKey(String)
    .walletAddress(String)
    .exchangeToken(String)

    /*----------------------------------------------------------------------------------*/
    /*                      Strategy  Parameters                                        */
    /*----------------------------------------------------------------------------------*/
    
    // Strategy Specific Parameter setting the preferred trade direction long|short|biDrectional  
    .sidePreference(String)

    // Strategy Specific Parameter custom values for Strategies like moving average period's and other data that 
    // might be important or needed in the Strategy 
    .extras(Object)

    /*----------------------------------------------------------------------------------*/
    /*                      Alert & Notificaion  Parameters                             */
    /*----------------------------------------------------------------------------------*/

    // Alerting & Notification Specific Parameter setting the Alert Type to be used: Email|Slack|Telegram
    // might be important or needed in the Strategy 
    .type(String)

    // Alerting & Notification Specific Parameter setting the API token needed to call dedicated API's 
    // responsible to send out the Notification
    .notificationToken(String)

    // Alerting & Notification Telegram specific Parameter optional but useful if you forgot to sync
    // your phone after you started or restarted or a Bot. 
    // please checkout our Documentation on Alerting & Notification.
    .telegramChatId(String)

    // Alerting & Notification Email Specific Parameter to identify who send the email!
    .emailFrom(String)

    // Alerting & Notification Email Specific Parameter to identify where the email should be send to!
    .emailTo(String)
    
    // Alerting & Notification Specific Parameter setting custom data for Alerts
    .alertExtras(Object)

    // Final build call applies the data, creates a BitFoxEngine instance and returns it back to callee.
    .build()
```

##  Engine Options

To Instantiate a bitfox engine instance bitfox requires certain options to initialize all dependent components
Below is a list of all options that can be applied.

_(We recommend using the provided builder interface to initialize an engine below is is just a summary of possible options!!)_

```js
{
  /*----------------------------------------------------------------------------------*/
  /*                      Exchange Specific Parameters                                */
  /*----------------------------------------------------------------------------------*/


  // boolean true or false to idicates if the engine should
  // use public or private Api's .
  "public": true,
  
  // The Target Exchange 
  "exchange": "bybit",
  
  // The Quote & Base Symbole or your desired trading Pair.
  "symbol": "ADAUSDT",
  
  // The Candle Time Frame you want to use.
  "timeframe": "15m",
  
  // This is the API Authentication instance that you need to supply,
  // when you plan on executing Strategies and trades
  // We are relying heavily on ccxt's Unified Api's 
  // see their docs here https://docs.ccxt.com/#/README.md for more info.
  "requiredCredentials": {
    /** On most popular exchanges this is the default credential Parameters **/

    // Your API KEY
    "key": "FAKE_KEY",
    // Your API Secret
    "secret": "FAKE_SECRET",

    // Some Exchange require Additional Authentication 
    // Parameters you need to figure out what Authentication Parameters 
    // your selected Exchange requires!

    "uid": "FAKE_UID",
    "login": "FAKE_LOGIN",
    "password": "FAKE_PASSWORD",
    "twofa": "2FA",
    "privateKey": "PRIVATE_KEY",
    "walletAddress": "WALLET_ADDRESS",
    "token": "TOKEN"
  },
  
  // {'defaultType': 'spot', 'adjustForTimeDifference': true,'recvwindow':7000 }; 
  // This is an Advanced usage and allows users to leverage different trading products | spot | futures | margins etc we recommend to stick with 
  // spot and the default options for now.
  "options": {
    'defaultType': 'spot',
    'adjustForTimeDifference': true,
    'recvwindow': 7000
  },
  
  /*----------------------------------------------------------------------------------*/
  /*                      Backtesting Parameters                                      */
  /*----------------------------------------------------------------------------------*/
  
  // Back Testing boolean indicates to the Engine if a Back Test should be ran against the Strategy
  "backtest": true,
  
  // Back Testing Argument how many Candles you would like to retrieve with each poll 
  "requiredCandles": 200,
  
  // Back Testing Argument how many time you would like to poll Candles
  "pollRate": 10,
  
  /*----------------------------------------------------------------------------------*/
  /*                      Strategy    Parameters                                      */
  /*----------------------------------------------------------------------------------*/

  // side preferences i.e. (long | short | biDirectional)
  "sidePreference": "long",
  
  // additional parameters for Indicators that you would like to use in your Custom Strategies
  // This is an advacnced parameter and you should only use it if you know what you are doing!
  "strategyExtras": {},
  
  /*----------------------------------------------------------------------------------*/
  /*                      Alert & Notificaion  Parameters                             */
  /*----------------------------------------------------------------------------------*/

  // The Type of Notification to use we currently support Email|Slack|Telegram  
  "type": "Telegram",
  
  // the Authentication Tokens for any of the above
  "notificationToken": "TOKEN",
  "telegramChatId": "chatID",
  "emailFrom": "yourSender@someMail.com",
  "emailTo": "yourReceiver@someMail.com",

  // additional custom parameters for an Alert context 
  "alertExtras": {},
  
  /*----------------------------------------------------------------------------------*/
  /*                      Engine and Trade Execution Parameters Parameters            */
  /*----------------------------------------------------------------------------------*/


  // the base amount for any given trade i.e. 1 BTC 100 ADA etc..
  "amount": 100,
  // A Profit Target percentage in this example we are targeting a profit increas of 3%
  "profitPct": 0.03,
  // A StopLoss Target percentage in this example we are targeting a stop order to trigger at 1% loss
  "stopLossPct": 0.01,
  // Exchange Fee 
  "fee": 0.02,
  // Wether to execute real trades or Mock a Strategy Execution flow
  "life": false,
  // The Polling interval in seconds for the engine to retrieve candle Data, and verify your Strategy logic 
  "interval": 10
}
```

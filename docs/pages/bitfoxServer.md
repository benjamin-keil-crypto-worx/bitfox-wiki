# Bit Fox Server 


## A Simple Server and REST API 

BitFox provides a server instance with a pre-defined API for users to leverage some of its features through third party applications like TradingView for example.

Starting a Server instance is as simple as importing bitfox and starting the Server instance

````js

let {builder} = require("bitfox").bitfox;
let engine =  builder()
       .requiredCandles(200)
       .public(true)           // Set False if you want to use Private Exchange API API (Requires Authentication with Exchange) 
       .life(false)            // Set true if yu are want to make real Exchange Transactions 
       .exchange("bybit")
       .symbol("ADAUSDT")
       .timeframe("5m")
       .key("FAKE_KEY")        // API Credentials if you want to use private API calls 
       .secret("FAKE_SECRET")  // API Credentials if you want to use private API calls 
       .build();

(async  () =>{
    await engine.setupAndLoadClient()
    await engine.startServer();
})();

````
 Once the Server has started observe the standard output and take note of the API login key token generated with every new Server Start up.

 ````shell
[INFO] "Server running at: http://localhost:6661/bitfox"
[WARN] "Your Login Api Key is: eC1zZXNzaW9uLWlkOjc2MDg1YmQ5NmExYmIyNWNmNDAyZDIzYmUwNjNlNGQ1ZDM2NzUwZmUxMThlMDFmNjRjZWJlODFmNDQ2NjY3NzA="
 ````

This is a API Authorization Key that is generated every time a new Server instance is generated, meaning everytime you start up a new Server instance,
you also generate a new API key that you must provide to every API Request you are planning to make!

Once you have taken note of the API Login Key you can Start making request

The Server currently provides the following endpoinst 

````shell
POST   /ping        "Ping the server to see if it online",
POST   /health      "Simple Health check",
POST   /getballance "Returns available ballance on target exchange",
POST   /ticker      "Returns the current Ticker information of selected Currency Pair",
POST   /orderbook   "Returns the Current Order Book for a given Currency Pair",
POST   /candles     "Returns Historical Candle data from exchange for given  trading pair",
POST   /buy         "Execute a Market buy order ",
POST   /sell        "Execute a market Sell order",
POST   /shutdown    "Emergency Shut Down" 
````

A insomna colleaction can be downloaded [Here!](https://raw.githubusercontent.com/benjamin-keil-crypto-worx/bitfox-wiki/master/docs/pages/bitfox-api/Insomnia)

See the full [API Documentation](https://benjamin-keil-crypto-worx.github.io/bitfox-wiki/pages/bitfox-api/api/index.html)  for more information and usage 

## The REST API Client 

We also provide a Easy to Use client that can be leveraged if you want to make API calls from your own Application's

Getting started is as simple as importing the client 

````js
let {Client} = require("bitfox").bitfox;
````

Setting up the client with the required configurations.

````js
    // Instantiate the Client

    let client = Client.getInstance();

    // Set Up The Client to make successful REST calls 
    client.setExchangeName("bybit")
    .setLife(false)
    .setPublic(false)
    .setSymbol("BTCUSDT")
    .setTimeFrame("5m")
    .setUrl("http://localhost")
    .setPort(8080)
    .setXsession("xSession_token")
    
````

Making Request to the API(s)

````js
/** Make Ping Request */
client.ping().then(result => {
    console.log(result.data)
}).catch(error => {
    console.error(error);
})

/** Make Health Check Request */
client.health().then(result => {
    console.log(result.data)
}).catch(error => {
    console.error(error);
})

/** Make a Ballance Request (need to be Authenticated against the given exchange) */
client.getballance().then(result => {
    console.log(result.data)
}).catch(error => {
    console.error(error);
})

/** Fetch A Ticker  */
client.ticker().then(result => {
    console.log(result.data)
}).catch(error => {
    console.error(error);
})

/** Make a orderbook Request */
client.orderbook().then(result => {
    console.log(result.data)
}).catch(error => {
    console.error(error);
})

/** Make Historical Candlestick Data Request */
client.candles().then(result => {
    console.log(result.data)
}).catch(error => {
    console.error(error);
})

/** Make Buy Request (need to be Authenticated against the given exchange) */
client.buy().then(result => {
    console.log(result.data)
}).catch(error => {
    console.error(error);
})

/** Make Buy Request (need to be Authenticated against the given exchange) */
client.sell().then(result => {
    console.log(result.data)
}).catch(error => {
    console.error(error);
})

/** Sends out a Shutdown signal to the server! */
client.shutdown().then(result => {
    console.log(result.data)
}).catch(error => {
    console.error(error);
})

````
## Event Handlers

We provide a few out of the box event handlers and emitter's, below is 
a List of all BitFox event messages that you can subscribe to!

The whole Messaging Structure and event Data is not yet fully fleshed out and will be available
in the near Future.


```js

// Simple message from the engine you could use for logging ) 
engine.on('onMessage', (message) => {
    console.log(message)
    /**
     @ eventArgs obj
     {
         timestamp:1502962946216, 
         message: String 
     }
     */
    
});
// If there is a error in the engine we will send out an error event 
engine.on('onError', (error) => {
    console.error(error);
    /** Error Instance */
});

// This event is fired when the Engine has placed an buy|sell order
engine.on('onOrderPlaced', (eventArgs) => {
    console.log(eventArgs);
    /**
     @ eventArgs obj
     {
         timestamp:1502962946216, 
         order:order // see ccxt order structure
     }
     */
});

// This event is fired when the Engine has determined a limit order is filled on the exchange
engine.on('onOrderFilled', (eventArgs) => {
    console.log(eventArgs);
    /**
     @ eventArgs obj
     {
         timestamp:1502962946216, 
         order:order // see ccxt order structure
     }
     */
});

// This event is fired when the Engine has completed a whole trade cycle
engine.on('onTradeComplete', (eventArgs) => {
    console.log(eventArgs);
     /**
     @ eventArgs obj
     {
         timestamp:1502962946216, 
         trade:{entryOrder:{....}, exitOrder:{....}} // see ccxt order structure
     }
     */
});

// This event is fired when the Engine has determined a stoploss order has been triggered
engine.on('onStopLossTriggered', (eventArgs) => {
    console.log(eventArgs)
    /**
     @ eventArgs obj
     {
         timestamp:1502962946216, 
         trade:{entryOrder:{....}, exitOrder:{....}} // see ccxt order structure
     }
     */
});
engine.on('onStrategyResponse', (eventArgs) => {
    console.log(eventArgs)
    /**
     * 
     @ eventArgs obj: 
     { 
        state:state, 
        timestamp:1502962946216, 
        custom:{obj any}
     }
    */

});
// SetUp Custom Event Handler (You need to fire the event yourself BitFox doesn't know about your Custom Event")
engine.on('MyCustomEvent', (eventArgs) => {
    console.log(eventArgs)
});

```

The BitFox Engine is structured in such a way that it will make all Exchange based operations for you!

List of operations implicitly executed for you!

- Enter a Long Position 
- Enter a Short Position
- Trigger a Stop Loss Order
- Check if an Order is Filled
- Check if a long/short is in profit
- Take Long/short Profit

However Sometimes you might don't want to rely on the Engine to handle these things for you, in this case you 
can implement these flows yourself, keep in mind that you will lose all benefits of using the engine and the Exchange clients, 
meaning you need to implement Exchange API call's yourself!

You can tell the engine that you like to implement these operations yourself by calling 
```engine.turnOffTradeOperations()```

You can then subscribe to these implicit event's from the engine.

LKeep in mind that you are responsible to keep track of orders and exits and everything, as
the engine has no idea about your trade execution flow!

```js
engine.on('enterLong', ()   =>  { /**  Your logic to enter a long trade  **/ });
engine.on('enterShort', ()  =>  { /**  Your logic to enter a short trade **/ });
engine.on('triggerStop',()  =>  { /**  Your logic trigger a stop ordere  **/ });
engine.on('takeProfit', ()  =>  { /**  Your logic to exit a trade        **/ });
    
    
engine.on('checkOrderStatus',  () => {/**  Your Logic to fetch an order to check its status        */});
engine.on('checkProfitStatus', () => {/**  Your Logic to check if your ongoing trade is in profit! */});

```

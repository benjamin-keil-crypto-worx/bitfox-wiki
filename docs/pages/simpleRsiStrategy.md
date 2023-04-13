### Implementing a Simple RSI Strategy

In this little code example we are implementing Dirty RSI Strategy that triggers long entries when the RSI below 30
and Triggers Short Signals when the RSI is above 70

**No Keep in mind if you run this Strategy with Real Money on a Real Exchange and life.. well you might as well
just throw your money in the bin because you 100% guaranteed to lose this money!**

This Strategy does not implement Stop Loss handling we leave this to you as an Exercise and with everything discussed so far,
you should be well able to implement this yourself!

```js
// import bit fox 
let bitfox = require("bitfox").bitfox;

// retrieve the Base Class instance 
let BaseStrategy = bitfox.Strategy;

class MyAwesomeStrategy extends BaseStrategy {
    
    // Retrieve your desired Indicator
    static RSI = Strategy.INDICATORS.RsiIndicator.className;

    // A unified instantiation method you must implement this 
    static init(args) {
        return new MyAwesomeStrategy(args);
    }

    // provide a Constructor ALWAYS make sure you call super(args)!!!
    constructor(args) {
        super(args);
        // The Strategies filed to store the RSI indicator Data
        this.RSI = null;
    }

    // getter and setter for the strategy state 
    setState(state) {
        this.state = state;
    }

    getState() {
        return this.state
    }
    
    // getter for the indicator data 
    getIndicator() {
        return super.getIndicator()
    }

    // This method is called from the engine and Backtesting engine and sets up Candle & Indicator Data
    // You must implement this otherwise it will fail to execute properly!
    async setup(klineCandles) {
        this.setIndicator(klineCandles, {period: 14}, MyAwesomeStrategy.RSI);
        this.RSI = this.getIndicator()
        return this;
    }

    

    // The run method that iterates over current price and indicator data 
    /**
     * 
     * @param _index     
     * @param isBackTest
     * @returns {Promise<{custom: {}, state: *, timestamp: number}>}
     */
    async run(_index = 0, isBackTest = false) {

        // Simple Logic and example how you could leverage Strategy States and provided data to implement
        // Strategy Logic!

        let currRsi = this.RSI[isBackTest ? _index : this.RSI.length - 1];

        if (this.state === this.states.STATE_ENTER_LONG || this.state === this.states.STATE_ENTER_SHORT) {
            this.state = this.states.STATE_AWAIT_ORDER_FILLED;
            return this.getStrategyResult(this.state, {});
        }
        if (this.state === this.states.STATE_PENDING) {

            if (currRsi <= 30) {
                this.state = (this.sidePreference === 'long' || this.sidePreference === 'biDirectional') ? this.states.STATE_ENTER_LONG : this.state;
            }
            if (currRsi >= 70) {
                this.state = (this.sidePreference === 'short' || this.sidePreference === 'biDirectional') ? this.states.STATE_ENTER_SHORT : this.state;
            }

            return this.getStrategyResult(this.state, {
                rsi: currRsi,
            });
        }
        return this.getStrategyResult(this.state, {
            rsi: currRsi,
        });
    }
}
```
### Run Your Strategy

Once you have implemented your Strategy you can run it as follows:

```js
const config = {
    // your Configuratioon object
    .....
}

// instantiate a bitfoxengine instance
let engine = bitfox.BitFoxEngine.init(config);

// always make sure to call this method this will setup the Exchange Client and other engine dependencies and components
await engine.setupAndLoadClient()
engine.applyStrategy(MyAwesomeStrategy);

(async ()=>{
    await engine.run();
})
```

### Run Your Strategy with an event Emitter
Sometimes we like to get Some Data fom inside Strategy you can easily modify the Strategy so that it will emit an event,
and we can react to the event via a dedicated event listener

An example could be like below we want to send out an event message when the RSI is below 30 and above 70

Modify and add below into your Strategy implementation

```js

if (currRsi <= 30) {
    this.state = (this.sidePreference === 'long' || this.sidePreference === 'biDirectional') ? this.states.STATE_ENTER_LONG : this.state;
    if( this.eventHandler !== null){
        this.eventHandler.fireEvent("MyAwesomeStrategy.RSI.message",this.getStrategyResult())
    }
}
if (currRsi >= 70) {
    this.state = (this.sidePreference === 'short' || this.sidePreference === 'biDirectional') ? this.states.STATE_ENTER_SHORT : this.state;
    if( this.eventHandler !== null){
        this.eventHandler.fireEvent("MyAwesomeStrategy.RSI.message",this.getStrategyResult())
    }
}
```

Once you have implemented your Strategy changes, you can run it as follows:

```js
const config = {
    // your Configuratioon object
    .....
}

// instantiate a bitfoxengine instance
let engine = bitfox.BitFoxEngine.init(config);

// always make sure to call this method this will setup the Exchange Client and other engine dependencies and components
await engine.setupAndLoadClient()

// apply your Strategy
engine.applyStrategy(MyAwesomeStrategy);

// set the bitfox dedicated event handler
engine.getStrategy().setEventHandler(engine.getEventEmitter());

// now just create some listeners for event
engine.on("MyAwesomeStrategy.RSI.message",(eventArgs) => {
    console.log(eventArgs)
});

// Don't forget to register for default events as well
engine.on('onMessage', (eventArgs) => {
    console.log(eventArgs);
    // Do Something 
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

(async ()=>{
    await engine.run();
})
```

### Implementing a Simple RSI Strategy


#### Pre-Requisite and Project Setup

In this little tutorial, we are implementing Dirty RSI Strategy that triggers:

_ long signals when the RSI is below 30
_ short Signals when the RSI is above 70

Optionally, We are also going to implement custom event handlers, plus our custom strategy will be able to notify us on Telegram
see [Alerting & Notifications](https://benjamin-keil-crypto-worx.github.io/bitfox-wiki/pages/alertsAndNotifications.md) for notification prerequisites and setup.


Lets get Started creating our first bitfox strategy bot.

1. Create a new NodeJs project somewhere on your machine! 
``mkdir myAwesomeStrategyProject``

2. Initialize your Nodejs inside you project  ``cd myAwesomeStrategyProject && npm init``
Follow the on screen instruction's and provide input for all prompts

3. install the bitfox client, You can easily install it by running below command(s).

````shell
npm install --save bitfox@latest
````
or alternatively install it globally 

````shell
npm install -g bitfox@latest
````

4. Create new File Javascript inside you new project directory and call anything you like, in this example 
we are going to call our  file ``MyAwesomeStrategy.js``




#### Create the Initial Class Body

At the top the newly created Javascript file import the bitfox client and add the following code


- ``let bitfox = require("bitfox").bitfox;``
    
    This imports the bitfox client

- ``let BaseStrategy = bitfox.Strategy;``
    
    This is a important import as all Custom Strategies **must** extend the Base Strategy available trhough this import!

- ``class MyAwesomeStrategy extends BaseStrategy {}`` 
    
    The initial class declaration it is very important to **not** forget the ``extends BaseStrategy``

- ``module.exports = {MyAwesomeStrategy:MyAwesomeStrategy}``
   
   This is Optional, it is considered good practice to alway make sure that a class can be imported 
   into other Javascript modules through the ``require()`` directive


Your Class should Look like below now!

````js
let bitfox = require("bitfox").bitfox;

/* retrieve the Base Class instance */ 
let BaseStrategy = bitfox.Strategy;

class MyAwesomeStrategy extends BaseStrategy {
    /* This the body of you strategy */
}

module.exports = {MyAwesomeStrategy:MyAwesomeStrategy}

````

#### Create Constructors and Initialization methods

Now we make changes in your Strategy to make it usable for the bitfox engine. 

* Initialize a static field in your class, this is used later to initialize the indicator data

``
static RSI = Strategy.INDICATORS.RsiIndicator.className;
``

* Create a static method in your class **always**  provide this method with its signature ``init(args)``
This method is used by the Bitfox Engine to to construct your Strategy Instance

````js
static init(args) {
    return new MyAwesomeStrategy(args);
}
````

* Provide a Constructor for your Strategy, **Important** make sure you always call the ``super(args)`` method as it will initialize the ``BaseStrategy`` or the parent with the provided
options from the bitfox engine. Additionally we innitialy a class variable ``this.RSI`` which will hold our Relative Strength Index indicator data.


````js
constructor(args) {
    super(args);
    this.RSI = null;
} 
````


Once you have implemented all the code changes you current Strategy should like like below

Your Class should Look similiar like below now! (We added some comments just to emphasize the important code snippets!)


````js
let bitfox = require("bitfox").bitfox;

/* retrieve the Base Class instance */ 
let BaseStrategy = bitfox.Strategy;

class MyAwesomeStrategy extends BaseStrategy {
     // Retrieve your desired Indicator
    static RSI = Strategy.INDICATORS.RsiIndicator.className;

    // A unified instantiation method it is called from the engine context, you must implement this 
    static init(args) {
        return new MyAwesomeStrategy(args);
    }

    // provide a Constructor ALWAYS make sure you call super(args)!!!
    constructor(args) {
        super(args);
        // The Strategies class variable to store the RSI indicator Data
        this.RSI = null;
    }
}

module.exports = {MyAwesomeStrategy:MyAwesomeStrategy}

````

#### Create Basic Getters And Setters

When you have confirmed that your code looks like as outlined above you can start implementing a few important getters and setters 
_Alway ensure that you implement these methods as they are called from the bitfox engine context and must be available other wise you will
experience runtime failures._

* ``setState(state) { this.state = state; }``

    This method provides an interface for the bitfox engine to set the state of this strategy, this is a very important method that you always **should** provide

* ``getState() { return this.state}``
    
    This method provides an interface for the bitfox engine to get the state of this strategy, this is a very important method that you always **should** provide

* ``getIndicator() { return super.getIndicator() }``

    This method provides an interface that allows other class instances to access the current indicator data stored/cached in the Strategy context

When you are done implementing the ``getter`` and ``setters`` of this Strategy you are ready to to initialize your Indicator data this is a relative simple 
implementation as the BaseStrategy provides a unified wrapper and interface to initialize Indicator data in your Strategies. Your Code as of now  should look like as below:

````js
let bitfox = require("bitfox").bitfox;

/* retrieve the Base Class instance */ 
let BaseStrategy = bitfox.Strategy;

class MyAwesomeStrategy extends BaseStrategy {
     // Retrieve your desired Indicator
    static RSI = Strategy.INDICATORS.RsiIndicator.className;

    // A unified instantiation method it is called from the engine context, you must implement this 
    static init(args) {
        return new MyAwesomeStrategy(args);
    }

    // provide a Constructor ALWAYS make sure you call super(args)!!!
    constructor(args) {
        super(args);
        // The Strategies class variable to store the RSI indicator Data
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
}

module.exports = {MyAwesomeStrategy:MyAwesomeStrategy}
````

#### Implement Indicator data Initialization

If you are happy that your Code is matching with above code you are ready to initialize the Indicator data,
in our case the Relative Strength Index Indicator data! 

**This method must be always provided** because it is called from the bitfox engine context, The Engine is responsible
to fetch Historical Candle Stick data from from the exchange and pass the Candles to the Strategy to set up the Indicator data.

````js
async setup(klineCandles) {
        this.setIndicator(klineCandles, {period: 14}, MyAwesomeStrategy.RSI);
        this.RSI = this.getIndicator()
        return this;
}
````


Lets try and understand what is actually happening in this peace code

* `` this.setIndicator(klineCandles, {period: 14}, MyAwesomeStrategy.RSI);``

    This is a method in the Super or Parent class it will be available for you if you have ensured that your class extends the BaseStrategy.
    All it does is: 
    * take the Historical Candle Data ``klineCandles`` 
    * an _optional_ strategy options object ``{period:14}`` 
    * the class name of our target Indicator ``MyAwesomeStrategy.RSI`` 
   
    The ``MyAwesomeStrategy.RSI`` is if you remember the static field ``static RSI`` in our class that we created at the top of our class implementation!
    
    All it is, is a String variable of an Indicator that is used by the BaseStrategy to identify and initialize the Indicator data.

Now that you have implemented the Indicator data Initialization its time to focus on the Nuts & bolts of our Strategy the actual
runtime and Strategy Logic that we want to implement!

Before we do that ensure that your Strategy looks similiar to the code below and that you have all the Methods implemented as outlined in the above steps!

````js
let bitfox = require("bitfox").bitfox;

/* retrieve the Base Class instance */ 
let BaseStrategy = bitfox.Strategy;

class MyAwesomeStrategy extends BaseStrategy {
     // Retrieve your desired Indicator
    static RSI = Strategy.INDICATORS.RsiIndicator.className;

    // A unified instantiation method it is called from the engine context, you must implement this 
    static init(args) {
        return new MyAwesomeStrategy(args);
    }

    // provide a Constructor ALWAYS make sure you call super(args)!!!
    constructor(args) {
        super(args);
        // The Strategies class variable to store the RSI indicator Data
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

    async setup(klineCandles) {
        this.setIndicator(klineCandles, {period: 14}, MyAwesomeStrategy.RSI);
        this.RSI = this.getIndicator()
        return this;
    }
}

module.exports = {MyAwesomeStrategy:MyAwesomeStrategy}
````

#### Create the Strategies Logical Flow

Does everything look good for now ? 
If not please go over the above steps one by one and ensure that you have everything ready for the next step.

Now we are ready to focus on the actual logical flow of our Strategy.

**Strategy Summary** 

Remember this is just a tutorial do **not** execute this Strategy with real money and on a life exchange, now thats that out of the way, lets recall our strategy

* When the RSI is below 30 I want to enter a Long Trade
* When the RSI is above 70 I want to enter a Short Trade

Thats it .. yeh told ya this is not a good Strategy to become a instant millionaire .. 

Have a look at below code _(don't worry we will look at each block a little closer)_


````js
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
````

**The Code can be summarized as follows.**

We have a ``run`` method that takes some very weird looking parameters 

``async run(_index = 0, isBackTest = false) {}``

Plus there a 3 Conditional Blocks that seem to some magical stuff with States 

1. A State Check to identify has the Strategy signalled a ``long`` or a ``short`` entry

    ``if(this.state === this.states.STATE_ENTER_LONG || this.state === this.states.STATE_ENTER_SHORT){}``

2. A State Check to identifyr is the Strategy is in a ``pending`` state 

   ``if (this.state === this.states.STATE_PENDING) {}``

3. A default block that returns the Strategy result 

    `` return this.getStrategyResult(this.state, {rsi: currRsi,});``
    
The ``async run(_index = 0, isBackTest = false) {}`` method is again called from the bitfox engine, so it must always be implemented with the paramters shown above,
The ``_index`` and the ``isBackTest`` parameters are just used if you run this Strategy through a backtest.

If the Current context is a backtest of your Strategy, 
the ``_index`` variable is used to traverse historical candle stick data based on Array Index allowing us to have a 1 to 1 mapping between historical data,
and the indicator data.

This peace of code might highlight this a little better ``let currRsi = this.RSI[isBackTest ? _index : this.RSI.length - 1];``
if the Strategy is in back test mode we use an index to identify the current Indicator Data other wise we use the latest and greatest which is always the 
last Indicator data in the Indicator data Array!


The First Conditional Block your Strategy would enter is this code block below!

Strategies are always initialized with a state of ``pending`` so this condition is the first one executed in the Strategy flow:
If you are unsure about ``States`` please see [Custom Strategies](https://benjamin-keil-crypto-worx.github.io/bitfox-wiki/pages/customStrategies.md) to get a better understanding about states!

**This logic here is really simple** 

* Given  the current RSI is smaller or equal to 30 then the Strategy will change its state to `STATE_ENTER_LONG`
* Given  the current RSI is greater or equal to 70 then the Strategy will change its state to `STATE_ENTER_SHORT`

You might have noticed the ``this.sidePreference`` variabale this is a bitfox engine option that you provide when you create bitfox engines 
Sometimes we don't want to enter longs or shorts so this parameter is just a string value indicating to the Strategy the users preferrence 
about trade directions. If we initialize the engine with ``long`` for the ``sidePreference`` the Strategy would only enter longs, ``short`` 
would make Strategy signal only short trades, ``biDirectional`` which is the defaul setting would allow both trade directions ``long`` and ``short``

Soon as the Strategy has determined a ``long`` or ``short`` signal the state is changed and it is returned to the calling bitfox engine.
The engine then places limit and/or market buy/sell orders which is configurable through the bitfox engine initialization.


````js
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
````

Your Strategy at this stage, is really idle as it is now waiting for to the engine to place the orders, wait for order fills, and
evaluate the current trade i.e. wait for the profit target to reach or act upon stop loss orders. 
When a Profit target is reached or a Stop Order was executed the Engine will reset the Strategy to a ``pending`` state and the whole operation starts all over again 
   
The Code below is actually not necessary but we added it to show case how states are changing when you have initialized your bitfox engine with limit orders. 

Say your Strategy has signalled a ``long`` or ``short`` opportunity and the engine has placed a limit order, then we are required to wait for the order to be filled
i.e. the engine would periodically check the current status of the ongoing order on the target exchange and wait for it to be filled or closed. The ``STATE_AWAIT_ORDER_FILLED``
state is there to prevent the engine and the strategy to start signalling more trade signals without keeping track of the current ongoing trades, 
having said all that the logical runtime requiremnts vary across different Strategies and its really up to the user what logical flows they like to implement! 


````js
if (this.state === this.states.STATE_ENTER_LONG || this.state === this.states.STATE_ENTER_SHORT) {
            this.state = this.states.STATE_AWAIT_ORDER_FILLED;
            return this.getStrategyResult(this.state, {});
}
````

#### Running & Backtesting your Strategy

We are almost at a stage wehere we can actually run test our Strategy if you have followed the Tutorial so far your code should look like below:

````js
let bitfox = require("bitfox").bitfox;

/* retrieve the Base Class instance */ 
let BaseStrategy = bitfox.Strategy;

class MyAwesomeStrategy extends BaseStrategy {
     // Retrieve your desired Indicator
    static RSI = Strategy.INDICATORS.RsiIndicator.className;

    // A unified instantiation method it is called from the engine context, you must implement this 
    static init(args) {
        return new MyAwesomeStrategy(args);
    }

    // provide a Constructor ALWAYS make sure you call super(args)!!!
    constructor(args) {
        super(args);
        // The Strategies class variable to store the RSI indicator Data
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

module.exports = {MyAwesomeStrategy:MyAwesomeStrategy}
````

If you are happy with your current code lets continue and run it as a backtest.
We will be testing our Strategy against BTCUSDT pair with a timeframe of 4 Hours for our historical candle data,
we pretend that we have 10 BTC to start with as a starting amount and we wil set our  profitPct to 3% and our Stop loss at 1%
We want to retrieve alot of data so we will set the pollrate for historical data queries to 10.

Inside your Project directory create a new file called ``MyAwesomeStrategyBackTest.js`` 

and copy and Paste below code

```js

let {builder} = require("bitfox")
let {MyAwesomeStrategy} = require("./MyAwesomeStrategy")

// instantiate a bitfoxengine instance we are using the builder to create a new bitfox engine
let engine = builder()
       .requiredCandles(200)
       .sidePreference("short")
       .backtest(true)
       .pollRate(10)
       .public(true)
       .exchange("bybit")
       .symbol("BTCUSDT")
       .timeframe("4h")
       .amount(10)
       .profitPct(0.03)
       .stopLossPct(0.01)
       .strategyExtras({period:12})
       .fee(0.01)
       .key("FAKE_KEY")
       .secret("FAKE_SECRET")
       .life(false)
       .interval(10)
       .build();
}

// always make sure to call this method this will setup the Exchange Client and other engine dependencies and components
await engine.setupAndLoadClient()
engine.applyStrategy(MyAwesomeStrategy);


/** Now Run Your Strategy remember the bitfox engine runs asynchronously so always wrap the run method inside a async function  **/

(async ()=>{
    await engine.run();
})
```
#### Run Your Strategy with an event Emitter

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

Once you have implemented your Strategy changes, all you need to do is modify the ``MyAwesomeStrategyBackTest.js`` and add below code

```js
// Create Engine Instance 
let engine = builder()
       .requiredCandles(200)
       .sidePreference("short")
       .backtest(true)
       .pollRate(10)
       .public(true)
       .exchange("bybit")
       .symbol("BTCUSDT")
       .timeframe("4h")
       .amount(10)
       .profitPct(0.03)
       .stopLossPct(0.01)
       .strategyExtras({period:12})
       .fee(0.01)
       .key("FAKE_KEY")
       .secret("FAKE_SECRET")
       .life(false)
       .interval(10)
       .build();

// Initialize all dependent components 
// always make sure to call this method this will setup the Exchange Client and other engine dependencies and components
await engine.setupAndLoadClient()
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

Thats it It, We understand that it may be a little overwhelming at the start, but its actually really simple and easy to create and run Strategies when you get the hang of it. 

Now go little one.. create awesome Strategies that shall give you riches and wealth beyond the imaginable, and if you are successfull remember sharing is caring :-)

You can support bitfox development and we are greatfull for small token's of appreciation 

<code><span style="color:black">Bitcoin address: </span><span style="color:darkorange">bc1qs6rvwnx0wlrqlncm90kk7mu0xs6980t85avfll</span></code>

<code><span style="color:black">Ethereum address: </span><span style="color:blue">0x088667d218f5E5c4560cdcf21c4bd2b2377Df0C9</span></code>




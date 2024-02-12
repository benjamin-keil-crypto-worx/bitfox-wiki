Bitfox also alows user to start their trading bots on given schedules, we use [node-schedule](https://www.npmjs.com/package/node-schedule) to achieven this.

In a Normal bitfox engine instantion the engine is setup to use interval functions to execute the specified trading context!
The process manager allows users to finetune the schedule the process and have schedules executed on the minute,hour,days and even weeks and months! 

You can test and play around with the process manager before you decide to use in  a real trading environemnt!
```javascript



let modules = require("./sandbox-modules");

let {BitFoxEngine, Bollinger, ProcessManager} = require("bitfox").bitfox;

const getTestEngine = () =>{
   return builder()
       .requiredCandles(200)
       .sidePreference("short")
       .backtest(true)
       .pollRate(100)
       .public(true)
       .exchange("bybit")
       .symbol("ADAUSDT")
       .timeframe("5m")
       .amount(1000)
       .profitPct(1.03)
       .strategyExtras({periodFast:55, periodSlow:200})
       //.stopLossPct(0.98)
       //.fee(0.002)
       .key("FAKE_KEY")
       .secret("FAKE_SECRET")
       .life(false)
       .interval(10)
       .build();

/**
 * retrieve the test engine
 */

let engine getTestEngine();

(async  () =>{

    await engine.setupAndLoadClient()
    engine.applyStrategy(Bollinger)
    // Set Up Event Handlers
    engine.on('onStrategyResponse', (eventArgs) => {
        console.log(eventArgs)
    });
    engine.setAsProcess(ProcessManager.getProcessManager().setProcessSchedule("1m"))
})();
```
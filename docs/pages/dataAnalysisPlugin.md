## Data Analysis Engine & Plugins



### Exporting Data 

We provide a easy to use interface to export Historical Candle Data into your Applications

All you need to provide to the interface is

- ``exchangeName``    This is the target Exchange you would like to pull the Data from
- ``pollRate``        This is the number of time you would like to pull Data for a gtiven number of candles
- ``requiredCandles`` This is the number of candles to pull with every poll
- ``symbol``          This is the base/quote currency pair you would like to retrieve Historical data from
- ``timeFrame``       This is the candle period 
- ``verbose``         Simple logging to check status of polling

We added a simple builder interface for ease of use and you can retrieve Historical Data by using below Code

````js
let {dataLoaderEngineBuilder} = require("bitfox").bitfox;

let dataLoader = dataLoaderEngineBuilder()
    .setExchangeName("bybit")
    .setPollRate(100)
    .setRequiredCandles(200)
    .setSymbol("BTCUSDT")
    .setTimeFrame("5m")
    .setVerbose(true)
    .build();

let openHighLowCloseVolumes =  [];
const pullDataFromExchange = async () =>{
    await dataLoader.setUpClient()
    let openHighLowCloseVolumes = await dataLoader.load();
    console.log(openHighLowCloseVolumes);

    /**
     *    timestamp      open      high      low       close     volume
     * [  
        [ 1680972300000, 28011.13, 28011.14, 28003.92, 28003.92, 1.775426 ],
        [ 1680972600000, 28003.92, 28005.26, 28003.92, 28005.25, 0.845515 ],
        [ 1680972900000, 28005.25, 28005.26, 28005.02, 28005.24, 1.761649 ],
        [ 1680973200000, 28005.24, 28005.24, 28005.14, 28005.15, 0.537034 ]
        ]
     * 
    */
}

pullDataFromExchange();
````


param(
    [Parameter(Mandatory=$True, Position=0, ValueFromPipeline=$false)]
    [System.String]
    $bitfoxPath
)

jsdoc -c ./assets/config.json -t $bitfoxPath/node_modules/ink-docstrap/template  -d ./docs/pages/bitfox-documentation -R .\assets\BitFoxLanding.md

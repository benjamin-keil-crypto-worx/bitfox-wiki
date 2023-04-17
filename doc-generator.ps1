param(
    [Parameter(Mandatory=$True, Position=0, ValueFromPipeline=$false)]
    [System.String]
    $bitfoxPath
)

Write-Host "using $bitfoxPath directories to generate documentation"
jsdoc -c ./assets/config.json -t $bitfoxPath/node_modules/ink-docstrap/template  -d ./docs/pages/bitfox-documentation/docstrap -R .\assets\BitFoxLanding.md

Write-Host "adding changes to git (git add .)"
git add .
Write-Host "committing changes to git (git commit -m [Ben K] Automated Documentation Update)"
git commit -m "[Ben K] Automated Documentation Update"
Write-Host "pushing changes to git (git push)"
git push

# debug-symbol-fetcher
npm module to install a fetcher for brave debug symbols

# usage
```javascript
var minidump = require("minidump")
minidump.addSymbolPath.apply(minidump, require("debug-symbol-fetcher").pathsForVersion('x.x.x'))

// now when using minidump.walkStack, it would give a more understandable report due to having debug symbols
```

You can use MUON_VERSIONS and CORE_VERSIONS environment variables to make the module install custom versions, for example when deploying to Heroku.
```
heroku config:set MUON_VERSIONS="0.29.2 0.27.1" CORE_VERSIONS="0.50.8"
```

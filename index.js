var path = require("path")
var fs = require("fs")
var _ = require('underscore')

var platforms = [
  'darwin',
  'linux',
  'win32-ia32',
  'win32-x64'
]

module.exports = {
  // return all symbol directories (including all versions)
  paths: function () {
    var dirs = fs.readdirSync(path.join(__dirname, 'symbols'))
    return _.map(dirs, function (dir) {
      return path.join(__dirname, 'symbols', dir, 'brave.breakpad.syms')
    })
  },
  // return all symbol directories for a specific brave version
  pathsForVersion: function(ver) {
    return _.map(platforms, function (platform) {
      return path.join(__dirname, 'symbols', platform + '-' + ver, 'brave.breakpad.syms')
    })
  }
}

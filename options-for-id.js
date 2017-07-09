#!/usr/bin/env node
var powerset = require('./powerset')
var match = powerset.find(function (combination) {
  var id = combination
    .map(function (element) {
      return element.code
    })
    .join('-')
  return id === process.argv[2]
})

console.log(
  JSON.stringify(
    match.reduce(function (options, element) {
      options[element.option] = true
      return options
    }, {}),
    null, 2
  )
)

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
    addDerivedProperties(
      match.reduce(function (options, element) {
        options[element.option] = true
        return options
      }, {})
    ),
    null, 2
  )
)

function addDerivedProperties (x) {
  if (
    x['Business-to-Business'] ||
    (x['One-Way'] && x['Individual-to-Business']) ||
    (x['Two-Way'] && !x['Individual-to-Individual'])
  ) {
    x['Entity Recipient'] = true
  }
  return x
}

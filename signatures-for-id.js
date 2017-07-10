#!/usr/bin/env node
var id = process.argv[2]
var split = id.split('-')

var information = ['date', 'email']
var business = {
  entities: [{}],
  information: information
}
var individual = {
  information: information
}

var signatures
if (split.includes('I2B')) {
  signatures = [clone(individual), clone(business)]
} else if (split.includes('I2B')) {
  signatures = [clone(business), clone(individual)]
} else {
  signatures = [clone(business), clone(business)]
}

signatures[0].header = (
  'The parties are signing this agreement ' +
  'on the dates by their signatures.'
)
signatures[1].samePage = true

if (split.includes('1W')) {
  signatures[0].term = 'Disclosing Party'
  signatures[1].term = 'Receiving Party'
}

console.log(JSON.stringify(signatures, null, 2))

function clone (argument) {
  return JSON.parse(JSON.stringify(argument))
}

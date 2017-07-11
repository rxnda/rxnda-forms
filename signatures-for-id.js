#!/usr/bin/env node
var id = process.argv[2]
var split = id.split('-')

var information = ['date', 'email', 'address']
var header = (
  'The parties are signing this agreement ' +
  'on the dates by their signatures.'
)
var business = {
  header: header,
  entities: [{}],
  information: information
}
var individual = {
  header: header,
  information: information
}

var signatures
if (split.includes('I2B')) {
  signatures = [clone(individual), clone(business)]
} else if (split.includes('B2I')) {
  signatures = [clone(business), clone(individual)]
} else if (split.includes('I2I')) {
  signatures = [clone(individual), clone(individual)]
} else if (split.includes('B2B')) {
  signatures = [clone(business), clone(business)]
}

if (split.includes('1W')) {
  signatures[0].term = 'Disclosing Party'
  signatures[1].term = 'Receiving Party'
}

console.log(JSON.stringify(signatures, null, 2))

function clone (argument) {
  return JSON.parse(JSON.stringify(argument))
}

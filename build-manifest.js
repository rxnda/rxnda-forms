#!/usr/bin/env node
var analyze = require('commonform-analyze')
var permutations = require('./permutations')
var signaturesFor = require('./signatures-for-id')

var EDITION = process.argv[2]

console.log(JSON.stringify(
  permutations
    .reduce(function (result, permutation) {
      var id = permutation
        .map(function (element) {
          return element.code
        })
        .join('-')
      var commonform = require('./build/' + id)
      result[id] = [
        {
          title: 'RxNDA ' + id,
          edition: EDITION,
          description: [
            'A ' +
            permutation
              .map(function (element) {
                return element.option.toLowerCase()
              })
              .join(', ') +
            ' NDA for general commercial use.'
          ],
          repository: 'https://github.com/rxnda/rxnda-forms',
          commonform: commonform,
          directions: directionsFor(commonform),
          signatures: signaturesFor(id)
        }
      ]
      return result
    }, {}),
  null, 2
))

function directionsFor (commonform) {
  var returned = analyze(commonform)
    .blanks
    .map(function (keyarray) {
      return {blank: keyarray}
    })

  returned[0].label = 'Purpose'
  returned[0].notes = [
    'Describe the reason the parties will ' +
    'share confidential information.',
    'For example, \u201Cdiscussing the purchase of business software\u201D'
  ]

  returned[1].label = 'State'
  returned[1].notes = [
    'Name the state whose law will govern the NDA, and ' +
    'where the parties will commit to litigate.',
    'For example, \u201CCalifornia\u201D or \u201CNew York\u201D '
  ]

  return returned
}

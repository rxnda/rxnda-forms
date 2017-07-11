#!/usr/bin/env node
var permutations = require('./permutations')
process.stdout.write(
  permutations
    .map(function (element) {
      return element
        .map(function (option) {
          return option.code
        })
        .join('-')
    })
    .join(' ')
)

#!/usr/bin/env node
var powerset = require('./powerset')
process.stdout.write(
  powerset
    .map(function (element) {
      return element
        .map(function (option) {
          return option.code
        })
        .join('-')
    })
    .join(' ')
)

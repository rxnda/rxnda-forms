var options = require('./options')
var length = options.length

function recurse (values, index) {
  var option = options[index]
  return option.possible.reduce(function (returned, value) {
    if (index === length - 1) {
      returned.push(values.concat(value))
    } else {
      recurse(
        values.concat(value),
        index + 1
      ).forEach(function (element) {
        returned.push(element)
      })
    }
    return returned
  }, [])
}

module.exports = recurse([], 0, options.length)

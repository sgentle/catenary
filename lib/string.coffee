cat = require '../catenary'

module.exports = methods =
  split: (str, delim) -> str.split(delim)
  fill: (str, num) -> Array(num+1).join(str)

  trim: (str) -> str.trim()

  uppercase: (str) -> str.toUpperCase()
  lowercase: (str) -> str.toLowerCase()

  replace: (str, regex, replacement) -> str.replace(regex, replacement)
  match: (str, regex) -> str.match(regex)

  padLeft: (str, length, padding) ->
    str = padding + str while str.length < length
    str.slice(0, length)

  padRight: (str, length, padding) ->
    str = str + padding while str.length < length
    str.slice(0, length)

  escape: escape
  unescape: unescape
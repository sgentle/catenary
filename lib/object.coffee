cat = require '../catenary'

module.exports = methods =
  clone: (x) -> cat x, JSON.parse(JSON.stringify(x))

  extend: (o, o2) -> o[k] = v for k, v of o2; o
  create: (o) -> Object.create(o)

  pick: (o, keys) ->
    o2 = {}
    o2[k] = v for k, v of o when k in keys
    o2

  omit: (o, keys) ->
    o2 = {}
    o2[k] = v for k, v of o when k not in keys
    o2

  invert: (o) ->
    o2 = {}
    o2[v] = k for k, v of o
    o2

  has: (o, p) -> p of o
  hasOwn: (o, p) -> typeof o is 'object' and o.hasOwnProperty p
  get: (o, p) -> o[p]
  set: (o, p, v) -> o[p] = v; o
  getPath: -> @cat('.').split.cat.get().each()

  invoke: -> @get.exec()

  keys: (o) -> k for k of o
  values: (o) -> o[k] for k of o
  pairs: (o) -> [k, v] for k, v of o

  JSON:
    parse: (x) -> JSON.parse(x)
    stringify: (x) -> JSON.stringify(x)
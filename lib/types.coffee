cat = require '../catenary'

module.exports = methods =
  isArray: Array.isArray
  isString: (x) -> typeof x is 'string'
  isFunction: (x) -> typeof x is 'function'
  isSymbol: (x) -> typeof x is 'symbol'
  isBoolean: (x) -> typeof x is 'boolean'
  isObject: (x) -> x && typeof x is 'object'
  isPlainObject: (x) -> x && typeof x is 'object' && (!Object.getPrototypeOf(x) or Object.getPrototypeOf(x).constructor.name is 'Object')
  isNumber: (x) -> typeof x is 'number' or x?.constructor?.name is 'Number'
  isFinite: Number.isFinite
  isNaN: (x) -> x != x
  isNull: (x) -> x is null
  isUndefined: (x) -> x is undefined

  toBoolean: (x) -> !!x
  toString: (x) -> x + ''
  toNumber: (x) -> +x
  toArray: (x) -> Array.prototype.slice.call(x)
  toObject: (x) ->
    o = {}
    o[k] = v for k, v of x
    o
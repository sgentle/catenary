cat = require './catenary'

defineProp = (obj, name, getter) ->
  Object.defineProperty obj, name, enumerable: true, configurable: true, get: getter

module.exports = methods =
  # Identity
  id: ->

  # Stack manipulation
  dup: -> @cat @$
  dup2: -> @_assertLength(2); @cat @_stack.slice(-2)...
  dupd: (x) -> @dup().cat(x)
  drop: (x) -> return
  drop2: (x, y) -> return
  over: (x, y) -> @cat x, y, x
  swap: (x, y) -> @cat y, x
  swapd: (x, y, z) -> @cat y, x, z
  nip: -> @swap.drop()

  # Combinators
  dip: (x, f) -> @cat(f).exec().cat(x)
  keep: (x, f) -> @cat(x, f).exec().cat(x)
  keep2: (x, y, f) -> @cat(x, y, f).exec().cat(x, y)
  rot: (x, y, z) -> @cat y, z, x
  unrot: (y, z, x) -> @cat x, y, z

  # Stack access
  stack: -> @cat @_stack.slice()
  setstack: -> @_stack = @$; this
  rollstack: -> @_stack = [ @_stack ]; this
  clear: -> @_stack = []; this

  # Logging
  print: (x) -> console.log x
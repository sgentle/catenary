cat = require '../catenary'

module.exports = methods =
  q: (cond, _true, _false) -> @cat if cond then _true else _false
  if: -> @q.exec()

  loop: (fn) ->
    c = this
    c = fn.call(c) while c.$
    c

  while: (pred, body) ->
    c = this
    c = pred.call(c)
    while c.$
      c = c.drop
        .cat(body).exec
        .cat(pred).exec()
    c.drop()

  repeat: (n, fn) ->
    c = this
    c = fn.call(c) while n--
    c

  and: (a, b) -> a && b
  or: (a, b) -> a || b
  xor: (a, b) -> a ^ b
  not: (x) -> !x

  band: (a, b) -> a & b
  bor: (a, b) -> a | b
  bnot: (a) -> ~a

  equal: (a, b) -> a == b
  notequal: (a, b) -> a != b
  is: Object.is or (x, y) ->
    if x == y
      x != 0 || 1/x == 1/y
    else
      x != x



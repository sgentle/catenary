cat = require '../../catenary'
assert = require 'assert'

unpackCat = (c) -> if c?._isCatenary then (unpackCat x for x in c._stack) else c
equalCat = (cat1, cat2) -> assert.deepEqual unpackCat(cat1), unpackCat(cat2)

describe "stdlib.object", ->
  it "clone", -> equalCat cat({a: 1, b: 2}).clone.cat('b', 3).set(), cat({a:1, b:2}, {a:1, b:3})

  it "extend", -> equalCat cat({a: 1, b: 2}, {b: 3, c: 4}).extend(), cat({a: 1, b: 3, c: 4})
  it "create", -> equalCat cat({a: 1}).create.dup.cat('a').get(), cat({}, 1)

  it "pick", -> equalCat cat({a: 1, b: 2, c: 3, d: 4}, ['a', 'c']).pick(), cat({a: 1, c: 3})
  it "omit", -> equalCat cat({a: 1, b: 2, c: 3, d: 4}, ['a', 'c']).omit(), cat({b: 2, d: 4})

  it "invert", -> equalCat cat({a: 'b', b: 'b', c: 'd'}).invert(), cat({b: 'b', d: 'c'})

  it "has", -> equalCat cat({a: 1, b: 2}, 'a').has(), cat(true)
  it "hasOwn", -> equalCat cat({a: 1, b: 2}).create.cat('a').hasOwn(), cat(false)
  it "get", -> equalCat cat({a: 1}, 'a').get(), cat(1)
  it "set", -> equalCat cat({a: 1}, 'b', 2).set(), cat({a:1, b:2})
  it "getPath", -> equalCat cat((a: b: c: d: 'e'), 'a.b.c.d').getPath(), cat('e')
  it "invoke", -> equalCat cat(3, {f: (x) -> x + 1}, 'f').invoke(), cat(4)

  it "keys", -> equalCat cat({a:1, b:2}).keys(), cat(['a', 'b'])
  it "values", -> equalCat cat({a:1, b:2}).values(), cat([1, 2])
  it "pairs", -> equalCat cat({a:1, b:2}).pairs(), cat([['a', 1], ['b', 2]])

  it "JSON.parse", -> equalCat cat({a:1, b:2}).JSON.stringify(), cat('{"a":1,"b":2}')
  it "JSON.stringify", -> equalCat cat('{"a":1,"b":2}').JSON.parse(), cat({a:1, b:2})
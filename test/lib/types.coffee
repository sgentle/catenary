cat = require '../../catenary'
assert = require 'assert'

unpackCat = (c) -> if c?._isCatenary then (unpackCat x for x in c._stack) else c
equalCat = (cat1, cat2) -> assert.deepEqual unpackCat(cat1), unpackCat(cat2)

describe "stdlib.object", ->
  it "isArray", -> equalCat cat({0: 'a', 1: 'b', length: 2}).isArray(), cat(false)

  it "toArray", -> equalCat cat("hello").toArray(), cat(['h','e','l','l','o'])

cat = require '../../catenary'
assert = require 'assert'

unpackCat = (c) -> if c?._isCatenary then (unpackCat x for x in c._stack) else c
equalCat = (cat1, cat2) -> assert.deepEqual unpackCat(cat1), unpackCat(cat2)

describe "stdlib.logic", ->
  it "q (true)", -> equalCat cat(3, true, 1, 2).q(), cat(3, 1)
  it "q (false)", -> equalCat cat(3, false, 1, 2).q(), cat(3, 2)

  it "if (true)", -> equalCat cat(3, true, cat.inc, cat.dec).if(), cat(4)
  it "if (false)", -> equalCat cat(3, false, cat.inc, cat.dec).if(), cat(2)

  it "loop", -> equalCat cat(5, cat.dec).loop(), cat(0)
  it "while", -> equalCat cat(5, cat.dup.cat(10).lt, cat.inc).while(), cat(10)
  it "repeat", -> equalCat cat(3, 5, cat.inc).repeat(), cat(8)

  it "and", -> equalCat cat(true, false).and(), cat(false)
  it "and (values)", -> equalCat cat(null, "hello").and(), cat(null)
  it "or", -> equalCat cat(true, false).or(), cat(true)
  it "or (values)", -> equalCat cat(null, "hello").or(), cat("hello")
  it "not", -> equalCat cat(3).not(), cat(false)
  it "xor", -> equalCat cat(1, 0).xor(), cat(1)
  it "band", -> equalCat cat(3, 2).band(), cat(2)
  it "bor", -> equalCat cat(3, 2).bor(), cat(3)
  it "bnot", -> equalCat cat(3).bnot(), cat(-4)

  it "equal", -> equalCat cat("hello", "hello").equal(), cat(true)
  it "equal (strict)", -> equalCat cat("0", 0).equal(), cat(false)

  it "is", -> equalCat cat("hello", "hello").is(), cat(true)
  it "is (-0)", -> equalCat cat(0, -0).is(), cat(false)
  it "is (NaN)", -> equalCat cat(NaN, NaN).is(), cat(true)

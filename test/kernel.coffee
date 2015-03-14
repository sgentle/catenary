
cat = require '../catenary'
assert = require 'assert'

unpackCat = (c) -> if c?._isCatenary then (unpackCat x for x in c._stack) else c
equalCat = (cat1, cat2) -> assert.deepEqual unpackCat(cat1), unpackCat(cat2)

describe "kernel functions", ->
  it "id", -> equalCat cat(1).id(), cat(1)

  it "dup", -> equalCat cat(1).dup(), cat(1, 1)
  it "dup2", -> equalCat cat(1, 2).dup2(), cat(1, 2, 1, 2)
  it "dupd", -> equalCat cat(1, 2).dupd(), cat(1, 1, 2)
  it "drop", -> equalCat cat(1, 2).drop(), cat(1)
  it "drop2", -> equalCat cat(1, 2, 3).drop2(), cat(1)
  it "swap", -> equalCat cat(1, 2).swap(), cat(2, 1)
  it "swapd", -> equalCat cat(1, 2, 3).swapd(), cat(2, 1, 3)
  it "over", -> equalCat cat(1, 2).over(), cat(1, 2, 1)
  it "nip", -> equalCat cat(1, 2).nip(), cat(2)
  it "rot", -> equalCat cat(1, 2, 3).rot(), cat(2, 3, 1)
  it "unrot", -> equalCat cat(2, 3, 1).unrot(), cat(1, 2, 3)

  it "dip (native)", -> equalCat cat(1, 2, cat((x) -> x + 1)).dip(), cat(2, 2)
  it "dip (cat)", -> equalCat cat(1, 2, cat.inc).dip(), cat(2, 2)
  it "keep (native)", -> equalCat cat(2, cat((x) -> x + 1)).keep(), cat(3, 2)
  it "keep (cat)", -> equalCat cat(2, cat.inc).keep(), cat(3, 2)
  it "keep2 (native)", -> equalCat cat(1, 2, cat.plus).keep2(), cat(3, 1, 2)
  it "keep2 (cat)", -> equalCat cat(1, 2, cat((x, y) -> x + y)).keep2(), cat(3, 1, 2)

  it "stack", -> equalCat cat(1, 2, 3).stack(), cat(1, 2, 3, [1, 2, 3])
  it "rollstack", -> equalCat cat(1, 2, 3).rollstack(), cat([1, 2, 3])
  it "setstack", -> equalCat cat([1, 2, 3]).setstack(), cat(1, 2, 3)
  it "clear", -> equalCat cat(1, 2, 3).clear(), cat()

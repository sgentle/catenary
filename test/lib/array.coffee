cat = require '../../catenary'
assert = require 'assert'

unpackCat = (c) -> if c?._isCatenary then (unpackCat x for x in c._stack) else c
equalCat = (cat1, cat2) -> assert.deepEqual unpackCat(cat1), unpackCat(cat2)

describe "stdlib.array", ->
  it "push", -> equalCat cat([1], 2).push(), cat([1, 2])
  it "pop", -> equalCat cat([1, 2]).pop(), cat([1], 2)
  it "unshift", -> equalCat cat([1], 2).unshift(), cat([2, 1])
  it "shift", -> equalCat cat([1, 2]).shift(), cat([2], 1)

  it "flatten", -> equalCat cat([[1, [2]], [3, [4]]]).flatten(), cat([1, [2], 3, [4]])

  it "join", -> equalCat cat(['a', 'b', 'c'], '!').join(), cat('a!b!c')

  it "uniq", -> equalCat cat([1, 2, 2, 3, 4, 3, 3]).uniq(), cat([1, 2, 3, 4, 3])
  it "slice", -> equalCat cat([1, 2, 3, 4], 1, 3).slice(), cat([2, 3])
  it "compact", -> equalCat cat([0, 1, "", 2, null, 3, false]).compact(), cat([1, 2, 3])

  it "zip", -> equalCat cat([1, 2, 3, 4], [5, 6, 7, 8]).zip(), cat([[1, 5], [2, 6], [3, 7], [4, 8]])
  it "zipObject", -> equalCat cat([1, 2, 3, 4], [5, 6, 7, 8]).zipObject(), cat({1: 5, 2: 6, 3: 7, 4: 8})

  it "each", -> equalCat cat(2, [1, 2, 3], cat.plus).each(), cat(2 + 1 + 2 + 3)
  it "each2", -> equalCat cat([4, 5, 6], [1, 2, 3], cat.plus).each2(), cat(1 + 4, 2 + 5, 3 + 6)

  it "eachIndex", -> equalCat cat([1, 2, 3], cat.plus).eachIndex(), cat(1, 3, 5)
  it "map", -> equalCat cat([1, 2, 3], cat.inc).map(), cat([2, 3, 4])
  it "mapIndex", -> equalCat cat([1, 2, 3], cat.plus).mapIndex(), cat([1, 3, 5])
  it "reduceWith", -> equalCat cat([1, 2, 3, 4], 5, cat.plus).reduceWith(), cat(5 + 1 + 2 + 3 + 4)
  it "reduce", -> equalCat cat([1, 2, 3, 4], cat.plus).reduce(), cat(1 + 2 + 3 + 4)

  it "reverse", -> equalCat cat([1, 2, 3, 4]).reverse(), cat([4, 3, 2, 1])
  it "sort", -> equalCat cat([7, 1, 4, 10]).sort(), cat([1, 10, 4, 7])
  it "sortBy", -> equalCat cat([7, 1, 4, 10], cat((a, b) -> a - b)).sortBy(), cat([1, 4, 7, 10])
  it "shuffle", -> equalCat cat([1, 2, 3, 4]).shuffle.sort(), cat([1, 2, 3, 4]) # Close enough

  it "filter", -> equalCat cat([1, 2, 3, 4], cat((x) -> x >= 3)).filter(), cat([3, 4])
  it "reject", -> equalCat cat([1, 2, 3, 4], cat((x) -> x >= 3)).reject(), cat([1, 2])
  it "partition", -> equalCat cat([1, 2, 3, 4], cat((x) -> x >= 3)).partition(), cat([3, 4], [1, 2])

  it "every (true)", -> equalCat cat([1, 2, 3, 4], cat((x) -> x > 0)).every(), cat(true)
  it "every (false)", -> equalCat cat([1, 2, 3, 4], cat((x) -> x > 3)).every(), cat(false)
  it "some (true)", -> equalCat cat([1, 2, 3, 4], cat((x) -> x > 3)).some(), cat(true)
  it "some (false)", -> equalCat cat([1, 2, 3, 4], cat((x) -> x > 4)).some(), cat(false)

  it "find", -> equalCat cat([1, 2, 3, 4], cat((x) -> x % 2 is 0)).find(), cat(2)
  it "find (not found)", -> equalCat cat([1, 2, 3, 4], cat((x) -> x % 10 is 0)).find(), cat(null)

  it "findIndex", -> equalCat cat([1, 2, 3, 4], cat((x) -> x % 2 is 0)).findIndex(), cat(1)
  it "findIndex (not found)", -> equalCat cat([1, 2, 3, 4], cat((x) -> x % 10 is 0)).findIndex(), cat(null)

  it "contains", -> equalCat cat([1, 2, 3, 4], 3).contains(), cat(true)
  it "contains (not found)", -> equalCat cat([1, 2, 3, 4], 5).contains(), cat(false)

  it "range", -> equalCat cat(3, -2).range(), cat([3, 2, 1, 0, -1, -2])

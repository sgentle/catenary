cat = require '../catenary'
assert = require 'assert'

unpackCat = (c) -> if c?._isCatenary then (unpackCat x for x in c._stack) else c
equalCat = (cat1, cat2) -> assert.deepEqual unpackCat(cat1), unpackCat(cat2)

describe "basics", ->
  it "can hold a value", ->
    assert.equal cat(1).$, 1

  it "can hold multiple values", ->
    assert.deepEqual cat(1, 2)._stack, [1, 2]

  it "evaluates to itself when called", ->
    equalCat cat(1, 2), cat(1, 2)()

  it "calls functions when called", ->
    equalCat cat(1, 2, (a, b) -> a + b)(), cat(3)

  it "can call multiple functions", ->
    equalCat cat(1, 2, ((x) -> x+1), ((a, b) -> a + b))(), cat(4)


describe "properties", ->
  it "add functions to the stack", ->
    assert.equal typeof(cat(1, 2).plus.$), 'function'

  it "calls property functions when called", ->
    equalCat cat(1, 2).plus(), cat(3)

  it "chains into a list of functions", ->
    equalCat cat(3, 2, 1).plus.times(), cat(9)


describe "higher-level", ->
  it "will evaluate a cat within a cat by concatenating them", ->
    equalCat cat(1, cat(2)).exec(), cat(1, 2)

  it "will evaluate multiple cats within a cat by concatenating them", ->
    equalCat cat(1, cat(2), cat(3)).cat.exec().dip.exec(), cat(1, 2, 3)

  it "each evaluation will drop one nesting level", ->
    equalCat cat(1, cat(2), cat(cat(3))).cat.exec().dip.exec(), cat(1, 2, cat(3))

  it "will evaluate cats with functions by making a function equivalent to executing both of them", ->
    equalCat cat(cat.plus, cat.plus).cat.exec().dip.exec(1, 2, 3), cat.plus.plus(1, 2, 3)

  it "will evaluate nested cats with functions", ->
    equalCat cat(cat(1).plus, cat(2).plus).cat.exec().dip.exec(3), cat(6)


describe ".cat", ->
  it "can concatenate extra values", ->
    equalCat cat(1).cat(2), cat(1, 2)

  it "can concatenate values and functions", ->
    equalCat cat(1).cat.plus(2), cat(1, cat(2).plus)

  it "can concatenate chained functions", ->
    equalCat cat.cat.plus.plus(3).exec(4, 5), cat(3).plus.plus(4, 5)

  it "can chain multiple .cat/calls", ->
    chain =
      cat
        .cat.plus(2).exec
        .cat.plus(3).exec
        .cat.plus(4).exec
        .cat.plus(5).exec

    equalCat chain(1), cat.plus.plus.plus.plus(1, 2, 3, 4, 5)

  it "can chain multiple .cats to create a higher order cat", ->
    equalCat cat.cat.cat.plus(3)(4), cat(cat(4,cat(3).plus))
cat = require '../catenary'
assert = require 'assert'

describe "defining and importing", ->
  it "should define one function", ->
    cat.define("hello", (x) -> "hello " + x)
    assert.equal cat.hello("world").$, "hello world"
    assert.equal cat("world").hello().$, "hello world"
    assert.equal cat.cat("world").hello().$, "hello world"

  it "should define one function over another", ->
    cat.define("hello", (x) -> "hello " + x)
    cat.define("hello", (x) -> "goodbye " + x)
    assert.equal cat.hello("world").$, "goodbye world"
    assert.equal cat("world").hello().$, "goodbye world"
    assert.equal cat.cat("world").hello().$, "goodbye world"

  it "should import an object of functions", ->
    cat.import one: (-> 1), two: (-> 2)
    assert.equal cat.one().$, 1
    assert.equal cat.one.two.plus().$, 3

  it "should define a namespaced object of functions", ->
    cat.define("add", one: ((x) -> x + 1), two: ((x) -> x + 2))
    assert.equal cat.add.one(0).$, 1
    assert.equal cat.add.one.add.two(0).$, 3
    assert.equal cat(3).add.two().$, 5

  it "should allow you to create instances which do not share definitions", ->
    instance = cat.instance
    instance2 = cat.instance
    instance.define 'fhqwgads', 'hello'
    instance2.define 'fhqwgads', 'world'

    assert.equal instance.fhqwgads.$, 'hello'
    assert.equal instance2.fhqwgads.$, 'world'
    assert.equal cat.fhqwgads, undefined

  it "should override general definitions with instance definitions", ->
    instance = cat.instance
    subinstance = instance.instance
    cat.define 'overrideme', 1
    assert.equal cat.overrideme.$, 1
    assert.equal instance.overrideme.$, 1
    assert.equal subinstance.overrideme.$, 1

    instance.define 'overrideme', 2
    assert.equal cat.overrideme.$, 1
    assert.equal instance.overrideme.$, 2
    assert.equal subinstance.overrideme.$, 2

    subinstance.define 'overrideme', 3
    assert.equal cat.overrideme.$, 1
    assert.equal instance.overrideme.$, 2
    assert.equal subinstance.overrideme.$, 3

  it "should define a nested namespaced object of functions", ->
    appendix =
      one:
        flower: (x) -> x + '⚘'
        snowman: (x) -> x + '☃'
      two:
        flowers: (x) -> x + '⚘⚘'
        snowmen: (x) -> x + '☃☃'
      ten:
        flowers: (x) -> x + '⚘⚘⚘⚘⚘⚘⚘⚘⚘⚘'
        snowmen: (x) -> x + '☃☃☃☃☃☃☃☃☃☃'

    cat.define("append", appendix)
    assert.equal cat.append.one.flower.append.two.snowmen('').$, '⚘☃☃'
    assert.equal cat.append.two.snowmen.append.ten.snowmen('').$, '☃☃☃☃☃☃☃☃☃☃☃☃'
    assert.equal cat.append.one.flower('').$, '⚘'
    assert.equal cat('').append.one.snowman().$, '☃'

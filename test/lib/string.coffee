cat = require '../../catenary'
assert = require 'assert'

unpackCat = (c) -> if c?._isCatenary then (unpackCat x for x in c._stack) else c
equalCat = (cat1, cat2) -> assert.deepEqual unpackCat(cat1), unpackCat(cat2)

describe "stdlib.string", ->
  it "split", -> equalCat cat('hello, world,', ',').split(), cat(['hello',' world',''])

  it "fill", -> equalCat cat('hello', 3).fill(), cat('hellohellohello')

  it "trim", -> equalCat cat('  hello, world!\t\n').trim(), cat('hello, world!')
  it "uppercase", -> equalCat cat('uPPer cASE').uppercase(), cat('UPPER CASE')
  it "lowercase", -> equalCat cat('LOWER case').lowercase(), cat('lower case')

  it "replace", -> equalCat cat('hello, world, hello!', /hello/, 'goodnight').replace(), cat('goodnight, world, hello!')
  it "replace (global)", -> equalCat cat('hello, world, hello!', /hello/g, 'goodnight').replace(), cat('goodnight, world, goodnight!')
  it "match", -> equalCat cat('hello, world, hello!', /l./g).match(), cat(['ll', 'ld', 'll'])
  it "match (not found)", -> equalCat cat('hello, world, hello!', /q/g).match(), cat(null)

  it "padLeft", -> equalCat cat('hello', 10, ' ').padLeft(), cat('     hello')
  it "padRight", -> equalCat cat('hello', 10, ' ').padRight(), cat('hello     ')

  it "escape", -> equalCat cat('hello, world!').escape(), cat('hello%2C%20world%21')
  it "unescape", -> equalCat cat('hello%2C%20world%21').unescape(), cat('hello, world!')

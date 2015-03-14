cat = require '../catenary'

module.exports = methods =
  #Mutating array functions
  push: (val) -> @$.push val; return
  pop: -> @cat @$.pop()
  unshift: (val) -> @$.unshift val; return
  shift: -> @cat @$.shift()
  reverse: (x) -> x.reverse()
  sort: (x) -> x.sort()
  sortBy: (x, fn) -> x.sort((a, b) => @cat(a, b, fn).exec().$)
  shuffle: (a) ->
    i = a.length
    while --i
      j = Math.floor(Math.random() * (i + 1))
      [a[i], a[j]] = [a[j], a[i]]
    a

  zip: (ary1, ary2) ->
    length = Math.min(ary1.length, ary2.length)
    [ary1[i], ary2[i]] for i in [0...length]

  zipObject: (ary1, ary2) ->
    length = Math.min(ary1.length, ary2.length)
    o = {}
    o[ary1[i]] = ary2[i] for i in [0...length]
    o

  flatten: (ary) -> Array.prototype.concat.apply([], ary)

  join: (ary, str) -> Array.prototype.join.call(ary, str)

  uniq: ->
    uniq = []
    last = undefined
    isuniq = cat (x) ->
      uniq.push x if x != last
      last = x
      return
    @cat(isuniq).each().cat(uniq)

  slice: (ary, a, b) -> ary.slice(a, b)

  compact: -> @cat.id().filter()


  #Higher-order functions
  each: (ary, fn) ->
    c = this
    for item in ary
      c = fn.call(c, item)
    c

  each2: (ary1, ary2, fn) ->
    c = this
    length = Math.min(ary1.length, ary2.length)
    for i in [0...length]
      c = fn.call(c, ary1[i], ary2[i])
    c

  eachIndex: (ary, fn) ->
    c = this
    for item, i in ary
      c = fn.call(c, item, i)
    c

  map: (fn) ->
    ret = []
    pusher = fn.cat((x) -> ret.push x; return)
    @cat(pusher).each().cat(ret)

  mapIndex: (fn) ->
    ret = []
    pusher = fn.cat((x) -> ret.push x; return)
    @cat(pusher).eachIndex().cat(ret)

  reduceWith: -> @swapd.each()

  reduce: -> @swap.pop.rot.reduceWith()

  filter: (fn) ->
    ret = []
    filterer = cat(fn).keep.cat((truthy, item) -> ret.push item if truthy; return)
    @cat(filterer).each().cat(ret)

  reject: (fn) -> @cat(fn.not).filter()

  partition: (fn) ->
    trues = []
    falses = []
    filterer = cat(fn).keep.cat((truthy, item) -> (if truthy then trues else falses).push item; return)
    @cat(filterer).each().cat(trues, falses)

  every: (ary, fn) ->
    c = this.cat(true)
    for item in ary
      break if !c.$
      c = c.drop.cat(item, fn).exec()
    c

  some: (ary, fn) ->
    c = this.cat(false)
    for item in ary
      break if c.$
      c = c.drop.cat(item, fn).exec()
    c

  # Searching

  find: (ary, fn) ->
    c = this.cat(null)
    for item in ary
      break if c.$ isnt null
      c = c.drop.cat(item, fn).keep.cat(null).q()
    c

  findIndex: (ary, fn) ->
    c = this.cat(null)
    for item, i in ary
      break if c.$ isnt null
      c = c.drop.cat(item, fn).exec.cat(i, null).q()
    c

  contains: (item) -> @cat.equal(item).find.cat(null).notequal()

  range: (from, to) -> [from..to]
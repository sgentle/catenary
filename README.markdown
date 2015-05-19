Catenary ![TravisCI](https://travis-ci.org/sgentle/catenary.svg?branch=master)
========



Catenary is a [concatenative programming](http://concatenative.org/wiki/view/Concatenative%20language) library for Javascript. Like functional programming, concatenative programming can be hard to get your head around at first, but used appropriately it can make your programs cleaner and more elegant.

Catenary is an attempt to unite the fun and elegance of the concatenative style with the ease and popularity of Javascript. It puts pragmatism over purity, and is designed to interoperate cleanly with regular JS functions so you can mix and match to do whatever suits your code best.

In addition, Catenary is designed to be a utility library with all your old favourites like `.extend` and `.shuffle`.

You can install it with `npm install catenary`

Concatenative programming
-------------------------

Concatenative programming is kind of the [bizarro world](https://www.youtube.com/watch?v=IcjSDZNbOs0) version of regular imperative or functional programming.

From functional programming you might be used to *applying* functions like `then_do_that(do_this(take_this))`, but concatenative programming turns all that on its head! Functions chain (or concatenate) together instead of applying, so you would write `take_this do_this then_do_that`. Each function receives the arguments from the previous function.

And from imperative programming you might be used to passing variables around, like `x = leftFoot(); y = rightFoot(); z = shakeAllAbout(x, y);`. But concatenative programming doesn't believe in variables! Instead you would write something like `leftFoot rightFoot shakeAllAbout`. Each function knows how many arguments it needs and how many it returns, so the variables can be *implicit*.

The way this is usually implemented is with a *stack*, which holds those implicit variables. Each function then pulls as many arguments as it likes from the stack and puts as many as it likes back on. Because all the data is implicit, you can think of it less like executing instructions and more like building a pipeline, or making a chain of operations that each connect to the next.

Want an example? Here's an example!

```javascript
  > cat(5)
  { [Function] _stack: [ 5 ] }
  > cat(5).dup()
  { [Function] _stack: [ 5, 5 ] }
  > cat(5).dup.times()
  { [Function] _stack: [ 25 ] }
  > cat.define('square', cat.dup.times)
  { [Function] _stack: [] }
  > cat.square(2)
  { [Function] _stack: [ 4 ] }
  > cat.square.square(2)
  { [Function] _stack: [ 16 ] }
```

Or how about our old friend fibonacci?

```javascript
// [a, b] --swap--> [b, a] --over--> [b, a, b], --plus--> [b, a+b]
cat.define('nextfib', cat.swap.over.plus)

cat(0, 1, 10, cat.dup.print.nextfib).repeat()
// 1
// 1
// 2
// 3
// 5
// 8
// 13
// 21
// 34
// 55
```

Want a more complicated example? Okay!

```javascript
// Add 'n bottle/bottles' to the stack
cat.define('bottles',
  cat(1).dupd.equal
    .cat(' bottle', ' bottles').q
    .dupd.plus
)

cat.define('beer',
  cat
    .bottles.cat(' of beer on the wall,').plus.print
    .bottles.cat(' of beer!').plus.print
    .cat('Take one down, pass it around,').print
    .dec
    .bottles.cat(' of beer on the wall.').plus.print
    .cat('').print
)

cat(99, cat.beer).loop()

//99 bottles of beer on the wall,
//99 bottles of beer!
//Take one down, pass it around,
//98 bottles of beer on the wall.
// [etc...]
```


How Catenary works
------------------

You can **create stacks** of items with `cat(...)`:

```javascript
> cat(1, 2, 3)
{ [Function] _stack: [ 1, 2, 3 ] }
```

And **concatenate** more values to the stack with `cat(...).cat(...)`:

```javascript
> cat(1, 2, 3).cat(4, 5, 6)
{ [Function] _stack: [ 1, 2, 3, 4, 5, 6 ] }
```

When you **access a property** on a cat, that adds a function to the stack:

```javascript
> cat(1, 2, 3).plus
{ [Function] _stack: [ 1, 2, 3, [Function] ] }
```

**Chained properties** just add more functions:

```javascript
> cat(1, 2, 3).plus.plus
{ [Function] _stack: [ 1, 2, [Function], [Function] ] }
```

Then when you **execute** the cat, all functions are called in order from left to right:

```javascript
> cat(1, 2, 3).plus.plus()
{ [Function] _stack: [ 5 ] }
```

That means you can actually just add **plain functions** to the stack and they will be executed:

```javascript
> cat(1, 2, 3, function((a, b) { return a * b })()
{ [Function] _stack: [ 1, 6 ] }
```

The **arity** of the function is inspected via its `.length` property to figure out how many items to take off the stack. Any value it returns other than undefined will be put back on the stack:

```javascript
> cat(1, 2, 3, function(a, b, c) { return 7 })()
{ [Function] _stack: [ 7 ] }
```

And you can chain **multiple plain functions** together too:

```javascript
> cat(1, function(x) { return x + 1 }, function(x) { return x * 5 })()
{ [Function] _stack: [ 10 ] }
```

You can also **pass arguments** when you execute the cat - they are added to the start of the stack:

```javascript
> cat(3).plus(5)
{ [Function] _stack: [ 8 ] }
> cat().plus(3, 5)
{ [Function] _stack: [ 8 ] }
```

Executing a cat with no functions in it will just return a **copy**:

```javascript
> cat(1, 2, 3)()
{ [Function] _stack: [ 1, 2, 3 ] }
> cat(1, 2, 3)()()()()()()
{ [Function] _stack: [ 1, 2, 3 ] }
```

So actually the main export is just a cat with an empty stack, which is fine because **cats are immutable**:

```javascript
> cat = require 'catenary'
{ [Function] _stack: [] }
```

Which means you can also write in **regular function style**, like this:

```javascript
> cat.plus(2, 3)
{ [Function] _stack: [ 5 ] }
> cat.times.times(3, 4, 5)
{ [Function] _stack: [ 60 ] }
```

To get values out, you can use `$` (`$` is the **show-me-the-money** operator)

```javascript
> cat(1, 2).$
2
cat(1, 2).stack().$
[1, 2]
```

But I am generally of the opinion that it's better to just pass whatever function you were going to return to into Catenary instead.

```javascript
> console.log cat(1, 2).plus().$ //boo
3

> cat.define('print', function(x) { console.log(x) })
{ [Function] _stack: [] }
> cat(1, 2).plus.print() //yay!
3
```


Higher order programming
------------------------

To do loops and if statements and other fun things, we need to be able to use functions without executing them, what some concatenative languages call `quotation`. We do this by wrapping them in a `cat()`. A cat inside another cat won't be executed, and can be passed around like a value:

```javascript
> cat(1, function(x) { return x + 1 })()
{ [Function] _stack: [ 2 ] }
> cat(1, cat(function(x) { return x + 1 }))()
{ [Function] _stack: [ 1, { [Function] _stack: [Object] } ] }
```

We can execute a cat from **inside another cat** by using `.exec`:
```javascript
> cat(1, cat(function(x) { return x + 1 })).exec()
{ [Function] _stack: [ 2 ] }
```

Or do other things with it...

```javascript
> cat(1, 500, cat(function(x) { return x + 1 })).repeat()
{ [Function] _stack: [ 501 ] }
```

You can also include values inside the cat:

```javascript
> cat(1, cat(5, function(x, y) { return x + y })).exec()
{ [Function] _stack: [ 6 ] }
```

Or to put it another way:

```javascript
> cat(1, cat(5).plus).exec()
{ [Function] _stack: [ 6 ] }
```

You can also use `.cat` to create **higher-order cats**:

```javascript
> cat(1).cat.plus(5)
{ [Function] _stack: [ 1, { [Function] _stack: [Object] } ] }
> cat(1).cat.plus(5).exec()
{ [Function] _stack: [ 6 ] }
```

Which leads to a nifty self-contained imperative style, if you're into that kind of thing:

```javascript
> cat(1).
... cat.plus(2).exec.
... cat.minus(5).exec.
... cat.times(7).exec()
{ [Function] _stack: [ -14 ] }
```


Defining, importing and returning
---------------------------------

You can **define your own words**:

```javascript
> cat.define('add2', function(x) { return x + 2 })
{ [Function] _stack: [] }
> cat.add2(3)
{ [Function] _stack: [ 5 ] }
```

And they don't have to be functions, they can be **any value**:

```javascript
> cat.define('hello', 'hello!')
{ [Function] _stack: [] }
> cat.hello.hello.hello
{ [Function] _stack: [ 'hello!', 'hello!', 'hello!' ] }
```

You can also define **namespaced words** by using an object:

```javascript
> cat.define('letters', {a: 'apple', b: 'banana'})
{ [Function] _stack: [] }
> cat.letters.a.letters.b
{ [Function] _stack: [ 'apple', 'banana' ] }
```

Or import a **whole object** at once:

```javascript
> cat.import({a: 'apple', b: 'banana'})
{ [Function] _stack: [] }
> cat.a.b.a.b
{ [Function] _stack: [ 'apple', 'banana', 'apple', 'banana' ] }
```

If you're concerned about collisions, you can use an **instance**:

```javascript
> cat2 = cat.instance
{ [Function] _proto: {}, _stack: [] }
> cat2.define('hello', 'world')
{ [Function] _proto: {}, _stack: [] }
> cat2.hello
{ [Function] _proto: {}, _stack: [ 'world' ] }
> cat.hello
undefined
```

Standard library
----------------

Catenary can do a lot of stuff that is, for now, tragically undocumented. The aim is to eventually be a fully-featured utility library in the spirit of Underscore, lodash or Ramda. You can have a browse through the `lib/` and `test/lib` folders to see what is currently supported.


Limitations
-----------

Right now Catenary is fairly early stage. I have not done any performance or browser testing of any kind, so it is almost certainly unsuitable for your billion dollar web app. But there are tests for all the major functionality and I am committed to being one with the [semver](http://semver.org/), so it should be safe enough to use.

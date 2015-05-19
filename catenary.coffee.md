Catenary
========

Catenary is a stack-based utility library for Javascript. It fundamentally
revolves around building up and executing stacks (essentially arrays) of
values and functions.

    "use strict"

Prototype
---------

The prototype contains all functions that can be executed on a Catenary
instance (or cat for short).

    proto = Object.create(Function.prototype)

    proto._isCatenary = true

Later on we'll use setPrototypeOf to ensure all cats have this proto.

    setPrototypeOf = Object.setPrototypeOf or (obj, proto) -> obj.__proto__ = proto

The `define` function adds a function to the prototype, which makes it
available to all cats. However you can also create sub-instances with their
own `_proto` to limit the scope of definitions.

    define = (name, obj) ->
      defineProp (@?._proto or proto), name, getter obj
      return


Our definitions are all getters. In Catenary every function operates on values
on the stack, so we don't need to specify arguments. The getter adds the value
(or function, or another cat) to the stack for execution later. This gives us
a nice chainable API.

The `getter` function provides a (possibly recursive) getter. If we add
another cat, we have to exec it as well. If we hit a simple object we'll add
its methods recursively. This allows us to namespace.

    getter = (obj) ->
      if obj?._isCatenary then -> @cat(obj).exec
      else if obj.constructor.name is 'Object' then ->
        o = {}
        defineProp o, k, getter(v).bind(this) for k, v of obj
        o
      else -> @cat(obj)

    defineProp = (obj, name, getter) ->
      Object.defineProperty obj, name, configurable: true, get: getter

Buffalo buffalo buffalo

    define 'define', define


Some useful utility methods to have on the prototype

    proto._assertLength = (length) ->
      if length > @_stack.length
        throw new Error "Not enough items on the stack! (needed #{length}, had #{@_stack.length})"

    defineProp proto, '$', -> @_assertLength(1); @_stack[@_stack.length-1]


Core
----

This is the real guts of Catenary. Each cat is also a function which, when
called, creates a new cat and adds to (or executes) each function in its own
stack. Because of this, cats are immutable even when they execute mutating
functions.

There are two things you can do with a cat, *concat* and *execute*. By default
a cat is executed unless it has been bound to another cat. That happens when
we call `cat.cat`

    Catenary = (_proto=proto) ->
      cat = (args...) ->
        if cat._base?._isCatenary
          cat._concat(cat._base, args)
        else
          cat._execute(null, args)

      setPrototypeOf(cat, _proto)
      cat._proto = _proto if _proto isnt proto
      cat._stack = []
      cat

    defineProp proto, 'cat', -> Catenary(this._proto).bind(this)

    defineProp proto, 'instance', -> Catenary(Object.create(this._proto or proto))


To *concat* onto another cat, we add ourselves curried with any number of
extra arguments to the other cat's stack.

If our stack has nothing in it we just add the arguments directly.

    proto._concat = (base, args) ->
      cat = Catenary(base._proto)
      cat._stack.push base._stack...

      if @_stack.length
        subcat = Catenary(base._proto)
        subcat._stack.push args...
        subcat._stack.push @_stack...
        cat._stack.push subcat
      else
        cat._stack.push args...

      cat.bind(base._base) if base._base

      cat


To *execute* a cat just means executing each item in the cat. Values
(including cats) are copied, functions are executed.

    proto._execute = (base, args) ->
      cat = Catenary(this._proto)
      cat._stack.push base._stack... if base
      cat._stack.push args...

      for item in @_stack
        if typeof item is 'function' and !item._isCatenary
          cat = exec.call(cat, item)
        else
          cat._stack.push item

      cat.bind(base._base) if base?._base

      cat


We can't use Javascript's `this` meaningfully, because the chaining API makes
that way too difficult. However, we reimplement `call`, `apply` and `bind` so
that they can refer to catenary instances, which is kind of like `this` if you
squint and turn your head a bit.

    proto.bind = (base) -> @_base = base; this
    proto.call = (base, args...) -> @apply(base, args)
    proto.apply = proto._execute


The `exec` method calls a function from a cat. The function's arity is
inspected to figure out how many values to pull from the stack, and any return
value other than `undefined` is placed back on the stack. The function is
called with the cat as its `this` context, so the function can perform more
complex stack operations if it wants. It can even return a new cat and that
cat will replace this one.

    exec = (fun) ->
      cat = this
      cat._assertLength fun.length

      args = []
      args.unshift cat._stack.pop() for [0...fun.length]
      ret = fun.apply cat, args
      if ret?._isCatenary
        cat = ret
      else if ret isnt undefined
        cat._stack.push ret

      cat

    define 'exec', exec

Export
------

We export a cat. You don't need the constructor because you can get a new
Catenary by just calling `cat()`.

    module.exports = Catenary()


Standard library
----------------

Really, all you need for catenary is `.define`, `.cat` and `.exec`. But to
make life a bit easier we include the `import` command and import a kernel of
stack functions and a standard library.

    _import = (obj) -> define name, val for name, val of obj; return
    define 'import', _import

    _require = (path) -> _import require path

    _require './kernel'

    _require "./lib/#{x}" for x in 'types array logic math object string'.split ' '

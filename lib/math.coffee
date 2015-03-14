cat = require '../catenary'

module.exports = methods =
  inc: (x) -> x + 1
  dec: (x) -> x - 1
  lt: (a, b) -> a < b
  gt: (a, b) -> a > b
  lte: (a, b) -> a <= b
  gte: (a, b) -> a >= b
  plus: (a, b) -> a + b
  minus: (a, b) -> a - b
  div: (a, b) -> a / b
  times: (a, b) -> a * b
  mod: (a, b) -> a % b
  neg: (x) -> -x

MATHODS = 'abs acos acosh asin asinh atan atan2 atanh cbrt ceil clz32 cos cosh
exp expm1 floor fround hypot imul log log10 log1p log2 max min pow random
round sign sin sinh sqrt tan tanh trunc'.split ' '

methods[mathod] = Math[mathod] for mathod in MATHODS when Math[mathod]

MATHCONSTS = 'E LN10 LN2 LOG10E LOG2E PI SQRT1_2 SQRT2'.split ' '

methods[mathconst] = Math[mathconst] for mathconst in MATHCONSTS when Math[mathconst]
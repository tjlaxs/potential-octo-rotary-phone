-- pretended functionality
local function add(a, b)
  return a + b
end

-- testing example
local T = require("test")

T.it('summing 1 + 2 equals 3', function()
  return T.expect(add(1, 2), 3)
end)

T.it('summing 1 + 2 equals 4', function()
  return T.expect(add(1, 2), 4)
end)

T.run()

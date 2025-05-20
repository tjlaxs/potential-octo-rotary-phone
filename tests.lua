local T = require("test")

T.it('works with 1 = 1', function()
  return T.expect(1, 1)
end)

T.it('fails with 1 = 0', function()
  return T.expect(1, 0)
end)

T.it('should have superficial expect', function()
  return T.expectSuperficial({ x = 10, y = 20 }, { y = 20, x = 10 })
end)

T.run()

local T = require("test")

-- Note:
--   - T.contrast used heavily because we are testing that functions test

--- expect

T.it('asserts table toBe', function()
  return T.contrast(T.expect(1, {}))
end)

T.it('asserts table result', function()
  return T.contrast(T.expect({}, 1))
end)

T.it('it asserts on tables', function()
  return T.contrast(T.expect({}, {}))
end)

T.it('works with 1 = 1', function()
  return T.expect(1, 1)
end)

T.it('fails with 1 = 0', function()
  return T.contrast(T.expect(1, 0))
end)

--- expectSuperficial

T.it('should have superficial expect', function()
  return T.expectSuperficial({ x = 10, y = 20 }, { y = 20, x = 10 })
end)

T.it('should fail with different objects 1', function()
  return T.contrast(T.expectSuperficial({ x = 10, y = 20 }, { y = 20 }))
end)

T.it('should fail with different objects 2', function()
  return T.contrast(T.expectSuperficial({ x = 10, y = 20 }, { y = 20 }))
end)

T.it('should fail with different objects 3', function()
  return T.contrast(T.expectSuperficial({ y = 20 }, { y = 20, x = 10 }))
end)

T.run()

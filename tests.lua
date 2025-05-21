local T = require("test")

-- Note:
--   - T.contrast used heavily because we are testing that functions work

--- expect

T.it('asserts table toBe', function()
  return T.contrast(T.expect(1, {}))
end)

T.it('asserts table result', function()
  return T.contrast(T.expect({}, 1))
end)

T.it('asserts on tables', function()
  return T.contrast(T.expect({}, {}))
end)

T.it('works with 1 = 1', function()
  return T.expect(1, 1)
end)

T.it('fails with 1 = 0', function()
  return T.contrast(T.expect(1, 0))
end)

--- expectSuperficial

T.it('asserts on nontables', function()
  return T.contrast(T.expect(1, 2))
end)

T.it('asserts on nontable result', function()
  return T.contrast(T.expect(1, {}))
end)

T.it('asserts on nontable toBe', function()
  return T.contrast(T.expect({}, 1))
end)

T.it('is ok with same object', function()
  local p = { x = 10, y = 20 }
  return T.expectSuperficial(p, p)
end)

T.it('works with tables with same values', function()
  return T.expectSuperficial({ x = 20, y = 10 }, { x = 20, y = 10 })
end)

T.it('does not care order of table values', function()
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

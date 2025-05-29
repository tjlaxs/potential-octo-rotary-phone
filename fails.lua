local T = require("test")

--- Tests in this file are checked in pipeline to fail

T.it('should throw error if no test result', function()
end)

T.it('prints fail case in booleans', function()
  return T.expect(true, false)
end)

T.it('tests the ci', function()
  return T.expect(true, true)
end)

T.it('prints fail case in numbers', function()
  return T.expect(1, 2)
end)

T.it('prints fail case in strings', function()
  return T.expect('foo', 'bar')
end)

T.it('prints fail case in tables', function()
  return T.expect({}, {})
end)

T.it('prints fail case in functions', function()
  return T.expect(function() end, function() end)
end)

T.it('prints fail case in booleans', function()
  return T.expectSuperficial(true, false)
end)

T.run()

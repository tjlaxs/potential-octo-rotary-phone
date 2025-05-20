local M = {}

M._tests = {}
M._results = {}
M._meta = { ok = 0, fail = 0, fails = {} }

M.Table = function(t)
  return table.concat(t, ', ')
end

M.Test = function(string, test)
  return { it = string, fun = test }
end
M.ResultToBe = function(string, test)
  return { it = string, res = test }
end

M.run = function()
  -- run tests
  for _, test in pairs(M._tests) do
    table.insert(M._results, { it = test.it, test = test.fun() })
  end
  -- calculate success rate
  for _, result in pairs(M._results) do
    if result.test.expect then
      M._meta.ok = M._meta.ok + 1
    else
      M._meta.fail = M._meta.fail + 1
      table.insert(M._meta.fails, result)
    end
  end
  -- give the results
  local all = M._meta.ok + M._meta.fail
  local result_string = "/" .. all
  if M._meta.fail > 0 then
    print("Failures:")
    for i, fail in pairs(M._meta.fails) do
      print("  " .. i .. ": " .. fail.it)
      print("    " .. fail.test.result .. " ≠ " .. fail.test.toBe)
    end
    print("")
    print("Failed tests: " .. M._meta.fail .. result_string)
  else
    print("")
    print("All tests ok: " .. M._meta.ok .. result_string)
  end
end

function M.it(string, fun)
  table.insert(M._tests, M.Test(string, fun))
end

local function _expectSuperficial(result, toBe)
  local all_keys = {}
  for key, result_value in pairs(result) do
    local to_be_value = toBe[key]
    if result_value ~= to_be_value then
      return false
    end
    all_keys[key] = true
  end
  for key, _ in pairs(toBe) do
    if not all_keys[key] then
      return false
    end
  end
  return true
end

local function print_kv_table(t)
  local str = 'Table('
  local key, value = next(t)
  while key do
    str = str .. key .. '=' .. value
    key, value = next(t, key)
    if key then
      str = str .. ', '
    end
  end
  return str .. ')'
end

function M.expectSuperficial(result, toBe)
  return {
    result = print_kv_table(result),
    toBe = print_kv_table(toBe),
    expect = _expectSuperficial(result, toBe)
  }
end

function M.expect(result, toBe)
  return { result = result, toBe = toBe, expect = result == toBe }
end

function M.contrast(test)
  return { result = test.result, toBe = test.toBe, expect = not test.expect }
end

return M

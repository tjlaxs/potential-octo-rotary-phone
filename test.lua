local M = {}

M._tests = {}
M._results = {}
M._meta = { ok = 0, fail = 0, fails = {} }
M._settings = {}

M.Table = function(t)
  return table.concat(t, ', ')
end

M.Test = function(it, fun)
  return {
    it = it,
    fun = fun,
  }
end

M.TestCase = function(result, toBe, expect)
  return {
    result = result,
    toBe = toBe,
    expect = expect,
  }
end

M.RunnedTest = function(it, result, number)
  return {
    it = it,
    test = result,
    number = number,
  }
end

local function parse_args()
  for _, v in pairs(arg) do
    if v == '--all-fail' then
      M._settings.all_fail = true
    end
  end
end

local function print_failures(fails)
  for _, fail in pairs(fails) do
    if fail.test.assert then
      print('  ' .. fail.number .. ': ' .. fail.it .. ' (ASSERT)')
      print('    ' .. fail.test.assert)
    else
      print('  ' .. fail.number .. ': ' .. fail.it)
      print('    ' .. tostring(fail.test.result) .. ' ≠ ' .. tostring(fail.test.toBe))
    end
  end
end

local function run_tests()
  for i, test in pairs(M._tests) do
    local run = M.RunnedTest(test.it, test.fun(), i)
    if run.test == nil then
      run.test = M.assert('Test function not returning boolean!')
      run.it = test.it
      run.number = i
    end
    table.insert(M._results, run)
  end
end

local function calculate_success_rate()
  for _, result in pairs(M._results) do
    if result.test.expect then
      M._meta.ok = M._meta.ok + 1
    else
      M._meta.fail = M._meta.fail + 1
      table.insert(M._meta.fails, result)
    end
  end
end

local function give_results()
  local all = M._meta.ok + M._meta.fail
  local result_string = '/' .. all
  if M._meta.fail > 0 then
    print('Failures:')
    print_failures(M._meta.fails)
    print('')
    print('Failed tests: ' .. M._meta.fail .. result_string)
    os.exit(-1)
  else
    print('')
    print('All tests ok: ' .. M._meta.ok .. result_string)
    os.exit(0)
  end
end

M.run = function()
  parse_args()
  run_tests()
  calculate_success_rate()
  if M._settings.all_fail == true then
    local f = M._meta.fail
    local s = M._meta.ok
    if s == 0 and f > 0 then
      os.exit(0)
    else
      os.exit(1)
    end
  end
  give_results()
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
  if type(result) ~= 'table' or type(toBe) ~= 'table' then
    return M.assert('expectSuperficial works with tables', false)
  end
  return M.TestCase(
    print_kv_table(result),
    print_kv_table(toBe),
    _expectSuperficial(result, toBe)
  )
end

function M.assert(text, expect)
  return {
    assert = text,
    expect = expect,
  }
end

function M.expect(result, toBe)
  if type(result) == 'table' or type(toBe) == 'table' then
    return M.assert('expect does not work with table', false)
  end
  return M.TestCase(result, toBe, result == toBe)
end

function M.contrast(test)
  return M.TestCase(test.result, test.toBe, not test.expect)
end

return M

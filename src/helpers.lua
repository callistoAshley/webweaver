local Helpers = {}

-- returns true if `val` exists within `tabl`
function Helpers.table_contains(tabl, val)
    for _, v in pairs(tabl) do
        if v == val then
            return true
        end
    end
    return false
end

-- ensure each value passed to this function after `tabl` exists as a key within `tabl`
function Helpers.require_keys(tabl, ...)
    local keys = table.pack(...) 
    keys["n"] = nil

    for _, required in pairs(keys) do
        local found = false

        for key, _ in pairs(tabl) do
            if key == required then
                found = true
                break
            end
        end

        if not found then return error(string.format("Missing required key `%s`", required)) end
    end
end

-- ensure `value` is one of the values in table `enum`
function Helpers.require_enum(value, enum, enum_name)
    for _, v in pairs(enum) do
        if v == value then
            return true
        end
    end
    return error(string.format("Value must be one of `%s`", enum_name))
end

return Helpers

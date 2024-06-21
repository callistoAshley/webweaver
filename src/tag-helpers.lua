local Tag =
{
    -- `func` here should be a function with `key` and `value` parameters
    -- the function should return a string representing the parameter's translation to HTML
    param_handler = function(self, func)
        self.param_handler_func = func
        return self
    end,

    css = function(self, css)
        self.css = css
        return self
    end,
}

function Tag.new_tag(name, html_name)
    return setmetatable(
    {
        name = name,
        html_name = html_name,
        is_tag == true,
    }, { __index = Tag })
end

function Tag.tag_param_format(k, v)
    return string.format('%s="%s"', k, v)
end

return Tag

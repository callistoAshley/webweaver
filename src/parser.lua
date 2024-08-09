-- TODO: it might be better to use html-parser's StrReader type here instead of matches
local Tags = require("tags")

local Parser =
{
}

local function err(str)
    return
    {
        error = str,
    }
end

local function is_err(table)
    return table.error ~= nil
end

local function get_tag(input)
    local num_read = 1

    if input:sub(1, 1) == "[" then
        local tag_name = input:match("%[(.-)%]"):gsub("%s.*", "")
        if #tag_name == 0 then
            return nil, num_read, err("Tag name cannot be empty.")
        end

        num_read = #input:match("^(%[.-%])")

        local tag = Tags[tag_name]
        if not tag then
            return nil, num_read, err(string.format("No such tag %s", tag_name))
        end

        tag.params = {}
        -- the first match call here is to ensure the gmatch call will only be performed on the first occurence of a string braced with square brackets
        -- and `match` may return nil if it fails, hence the "or"
        for param in (input:match("^%[.-%]") or ""):gmatch('%s(.-=%".-%")') do
            local key = param:match("(.*)=") 
            local value = param:match("=\"(.*)\"")
            tag.params[key] = value
        end

        return tag, num_read, nil
    end

    return nil, num_read, nil
end

local function get_closing_tag(input)
    return input:sub(1, 3) == "[/]"
end

local function process_tag(input, tag)
    local num_read = 1
    local text = ""

    while not get_closing_tag(input) do
        if input == "" then
            return nil, num_read, err(string.format("Unclosed tag `%s`", tag.name))
        end

        local subtag, subtag_read, subtag_err = get_tag(input)
        if subtag_err then
            return nil, num_read + subtag_read, subtag_err
        end

        if subtag then
            num_read = num_read + subtag_read
            input = input:sub(1 + subtag_read)

            local subtag_html = process_tag(input, subtag)

            text = text .. subtag_html
        else
            text = text .. input:sub(1, 1)
            input = input:sub(2)
            num_read = num_read + 1
        end
    end

    num_read = num_read + #"[/]"
    -- FIXME: it'd be better to just fix the root of the problem here
    num_read = num_read - 1 -- num_read is being incremented one too many times somewhere. don't know or care where.

    local param_text = ""
    for k, v in pairs(tag.params) do
        if not tag.param_handler_func then
            return nil, num_read, err(string.format("Tag `%s` cannot have parameters", tag.name))
        end

        local str = tag:param_handler_func(k, v)
        if not str then
            return nil, num_read, err(string.format("Bad parameter `%s` for tag `%s`", k, tag.name))
        end
        param_text = param_text .. str .. " "
    end
    if param_text ~= "" then
        param_text = " " .. param_text
    end
    if tag.css ~= "" then
        param_text = string.format("%s style=\"%s\"", param_text, tag.css)
    end

    return string.format(
        "<%s%s>%s</%s>", 
        tag.html_name,
        param_text,
        text,
        tag.html_name
    ), num_read, nil
end

function Parser:parse(input)
    local body = ""
    local paragraph = ""

    local entities = 
    {
        ["<"] = "&lt;",
        [">"] = "&gt;",
    }
    for k, v in pairs(entities) do
        input = input:gsub(k, v)
    end

    while input ~= "" do
        if get_closing_tag(input) then
            return error("Stray closing tag.")
        end

        local tag, num_read, err = get_tag(input)

        if err ~= nil then
            return error(err.error)
        end

        if tag then
            input = input:sub(1 + num_read)

            local html, html_num_read, html_err = process_tag(input, tag)
            if html_err then
                return error(html_err.error)
            end
            input = input:sub(1 + html_num_read)

            paragraph = paragraph .. html
        else
            -- push the next character onto the paragraph
            paragraph = paragraph .. input:sub(1, 1)
            input = input:sub(2)
        end

        if input:sub(1, 1) == "\n" then
            if input:sub(2, 2) == "\n" then
                body = body .. string.format("<p>%s</p>\n", paragraph)
                paragraph = ""
                input = input:sub(3)
            else
                paragraph = paragraph .. "<br>"
                input = input:sub(2)
            end
        end
    end
    
    if paragraph ~= "" then
        body = body .. string.format("<p>%s</p>", paragraph)
    end
    return body
end

return Parser

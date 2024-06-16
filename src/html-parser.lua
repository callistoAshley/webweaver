-- https://html.spec.whatwg.org/multipage/syntax.html#syntax
local Helpers = require("helpers")
local HtmlParser = {}

local StrReader =
{
    str = "",
    idx = 1,

    new = function(self, str)
        self.__index = self
        return setmetatable({str = str or ""}, self)
    end,

    get_next_char = function(self)
        local res = self.str:sub(self.idx, self.idx)
        self.idx = self.idx + 1
        return res
    end,

    peek_next_char = function(self)
        return self.str:sub(self.idx, self.idx)
    end,

    peek_offset = function(self, offset)
        return self.str:sub(self.idx + offset, self.idx + offset)
    end,

    skip = function(self, num)
        self.idx = self.idx + num
    end,

    read_until = function(self, match)
        local res = ""
        while not self:match("^" .. match) do
            res = res .. self:get_next_char()
        end
        return res
    end,

    match = function(self, ...)
        return self.str:match(...)
    end,
}

local ElemTypes =
{
    void =
    {
        "area", "base", "br", "col", "embed", "hr", "img", "input", "link", "meta", "source", "track", "wbr"
    },
    template =
    {
        "template"
    },
    raw_text =
    {
        "script", "style"
    },
    escapable_raw_text =
    {
        "textarea", "title"
    },
    foreign =
    {
        -- TODO
    },
    -- any other elements are normal elements
}

local function get_elem_type(elem_name)
    for type, tabl in pairs(ElemTypes) do
        for _, elem in ipairs(tabl) do
            if elem == elem_name then
                return true
            end
        end
    end
    return false
end

local function skip_comment(reader)
    if reader.str:match("^<!%-%-") then
        reader:read_until("%-%-!>")
        reader:skip(#"--!>")
        return true
    end
    return false
end

local function skip_whitespace(reader)
    local whitespaces = {" ", "\n", "\r", "\t", "\x0B"}
    local res = false
    while Helpers.table_contains(whitespaces, reader:peek_next_char()) do
        reader:skip(1)
        res = true
    end
    return res
end

local function skip_whitespace_or_comment(reader)
    local res = false
    while true do
        if not skip_comment(reader) and not skip_whitespace(reader) then
            return res
        end
        res = true
    end
end

local function parse_tag(reader)
    local name = ""
    local contents = {}
    local void_closed = false

    local char

    if reader:peek_next_char() == "<" then
        reader:skip(1)

        while true do
            char = reader:get_next_char()
            if char == " " or char == ">" then break end
            name = name .. char
        end

        local attributes = {}
        local attr_name = ""
        local attr_value = ""
        while char ~= ">" do
            char = reader:get_next_char()

            if char == "/" and reader:peek_next_char() == ">" and Helpers.table_contains(ElemTypes.void, name) then
                void_closed = true
                break
            end

            while char ~= "=" and char ~= " " do
                attr_name = attr_name .. char
                char = reader:get_next_char()
            end
            if char == "=" then
                char = reader:get_next_char()
                local terminator = " "
                if char == '"' then 
                    terminator = '"'
                elseif char == "'" then 
                    terminator = "'"
                end
                if terminator ~= " " then
                    char = reader:get_next_char()
                end

                while char ~= terminator do
                    attr_value = attr_value .. char
                    char = reader:get_next_char()
                end
            end
            
            table.insert(attributes, HtmlParser.construct_attribute(attr_name, attr_value))
            char = reader:get_next_char()
        end
        reader:skip(1)
    else
        return nil
    end

    if not void_closed then
        local end_tag_match = string.format("^</%s>", name)
        local contents_idx = 1

        while not reader.str:sub(reader.idx):match(end_tag_match) do
            -- FIXME
            while reader:peek_next_char() ~= "<" do
                char = reader:get_next_char()
                contents[contents_idx] = (contents[contents_idx] or "") .. char
            end
            if reader:match(end_tag_match) then break end
            
            local subtag = parse_tag(reader) 
            if subtag then table.insert(contents, contents_idx, subtag) end

            contents_idx = contents_idx + 1
        end
        reader:skip(#string.format("</%s>", name));
    end
    
    return HtmlParser.construct_tag(name, attributes, contents)
end

function HtmlParser.construct_attribute(name, value)
    return
    {
        name = name,
        value = value,
    }
end

function HtmlParser.construct_tag(name, attributes)
    return
    {
        name = name,
        attributes = attributes,
        contents = contents
    }
end

function HtmlParser.parse_str(str)
    local reader = StrReader:new(str)
    local doctype_html = true
    
    if reader.str:sub(1, 2) == utf8.char(0xFE, 0xFF) then
        reader:skip(2)
    end
    skip_whitespace_or_comment(reader)
    if reader.str:lower():match("<!doctype html>") then
        reader:skip(#"<!doctype html>")
    end
    skip_whitespace_or_comment(reader)
    local html_tag = parse_tag(reader)
    if html_tag and html_tag.name == "html" then
        -- ....
    else
        return error("Expected html tag.")
    end
    skip_whitespace_or_comment(reader)

    --[[
    while true do
        
    end]]
end

return HtmlParser

require("tag-helpers")

local Tags =
{
    bold = new_tag("bold", "strong"),

    italic = new_tag("italic", "i"),

    underline = new_tag("underline", "span"):css("text-decoration: underline"),

    image = new_tag("image", "img"):param_handler(
        function(self, k, v)
            if k == "src" then
                return tag_param_format(k, v)
            elseif k == "alt" then
                return tag_param_format(k, v)
            end
            return nil
        end), 

    link = new_tag("link", "a"):param_handler(
        function(self, k, v)
            if k == "destination" or k == "dest" then
                return tag_param_format("href", v)
            end
            return nil
        end),
        
    code = new_tag("code", {"pre", "code"}), -- TODO: syntax highlighting for code elements might be nice
}

return Tags

local Tag = require("tag-helpers")

local Tags =
{
    bold = Tag.new_tag("bold", "strong"),

    italic = Tag.new_tag("italic", "i"),

    underline = Tag.new_tag("underline", "span"):css("text-decoration: underline"),

    image = Tag.new_tag("image", "img"):param_handler(
        function(self, k, v)
            if k == "src" then
                return Tag.tag_param_format(k, v)
            elseif k == "alt" then
                return Tag.tag_param_format(k, v)
            end
            return nil
        end), 

    link = Tag.new_tag("link", "a"):param_handler(
        function(self, k, v)
            if k == "destination" or k == "dest" then
                return Tag.tag_param_format("href", v)
            end
            return nil
        end),
        
    code = Tag.new_tag("code", {"pre", "code"}), -- TODO: syntax highlighting for code elements might be nice
}

return Tags

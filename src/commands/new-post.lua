local CmdHelpers = require("command-helpers")
local Helpers = require("helpers")
local Parser = require("parser")
local cjson = require("cjson")

local function new_post_func(cmd)
    local input = cmd:get_arg_by_name("-i"):get_value_by_name("input").value
    local output = cmd:get_arg_by_name("-o"):get_value_by_name("output").value

    local blog_path = "./wvblog.json"

    local blog_arg = cmd:get_arg_by_name("-b")
    if blog_arg then
        blog_path = blog_arg:get_value_by_name("blog").value
    end
    local blog = cjson.decode(Helpers.file_text(blog_path) or error(string.format("No such file `%s`", blog_path)))
    
    local parsed = Parser:parse(Helpers.file_text(input) or error(string.format("No such file `%s`", input)))
    local skeleton = Helpers.file_text(blog.skeleton) or error(string.format("No such file `%s`", blog.skeleton))
    local generated = skeleton:gsub("<!%-%- POST BODY GOES HERE %-%->", parsed)
    if generated == skeleton then
        error(
        [[
The skeleton does not contain a marker for the generated post content.
A comment must be inserted in the body as follows:

<!-- POST BODY GOES HERE -->
        ]])
    end

    local fields =
    {
        -- arg name       field name     -- message
        {"--name",        "name",        "Specify the name of the post."},
        {"--description", "description", "Specify the description of the post."},
    }

    local post = {}
    for _, field in ipairs(fields) do
        local arg_name = field[1]
        local field_name = field[2]
        local message = field[3]
        
        local arg = cmd:get_arg_by_name(arg_name)
        if arg then
            post[field_name] = arg:get_value_by_name(field_name)
        else
            io.write(message, " ")
            local input = io.read():gsub("\n", "")
            post[field_name] = input
        end
    end

    -- TODO: update index
    local file = io.open(string.format("%s/%s/%s", blog_path:gsub("wvblog.json", ""), blog.posts_dir, output), "w")
    file:write(generated)
    file:close()
end

return CmdHelpers.new_command
{
    name = "new-post",
    short_help = "Generate a new blog post.",
    long_help = 
    [[Generate a new blog post.]],
    func = new_post_func,

    possible_args =
    {
        CmdHelpers.new_arg
        (
            {"-i", "--input"},
            "Specify the input source file.",
            CmdHelpers.ArgType.REQUIRED,
            {
                CmdHelpers.new_value("input", CmdHelpers.ValueType.REQUIRED)
            }
        ),
        CmdHelpers.new_arg
        (
            {"-o", "--output"},
            "Specify the output HTML file.",
            CmdHelpers.ArgType.REQUIRED,
            {
                CmdHelpers.new_value("output", CmdHelpers.ValueType.REQUIRED)
            }
        ),
        CmdHelpers.new_arg
        (
            {"-b", "--blog"},
            "Specify the blog. Defaults to `./wvblog.json`.",
            CmdHelpers.ArgType.OPTIONAL,
            {
                CmdHelpers.new_value("blog", CmdHelpers.ValueType.REQUIRED)
            }
        ),
        CmdHelpers.new_arg
        (
            {"--name"},
            "Specify the name of the post. If not provided, it will be accepted from standard input.",
            CmdHelpers.ArgType.OPTIONAL,
            {
                CmdHelpers.new_value("name", CmdHelpers.ValueType.REQUIRED)
            }
        ),
        CmdHelpers.new_arg
        (
            {"--description"},
            "Specify the description of the post. If not provided, it will be accepted from standard input.",
            CmdHelpers.ArgType.OPTIONAL,
            {
                CmdHelpers.new_value("description", CmdHelpers.ValueType.REQUIRED)
            }
        )
    },
}

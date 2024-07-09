local CmdHelpers = require("command-helpers")
local Helpers = require("helpers")
local IndexManager = require("index-manager")
local Parser = require("parser")
local cjson = require("cjson")

local month_names = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" }

local function new_post_func(cmd)
    local input = cmd:get_arg_by_name("-i"):get_value_by_name("input").value
    local output = cmd:get_arg_by_name("-o"):get_value_by_name("output").value

    if not output:match("%.html$") then
        output = output .. ".html"
    end

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
    post.output_name = output

    local date = os.date("*t")

    local post_title = post.name
    local post_date = string.format("%s %s %s", date.day, month_names[date.month], date.year)
    local post_description = post.description
    local post_link = string.format("%s/%s", blog.posts_dir, post.output_name)

    table.insert(blog.posts, post)

    -- TODO: check whether any of these files exist before writing to them
    local file = io.open(string.format("%s/%s/%s", blog_path:gsub("wvblog.json", ""), blog.posts_dir, output), "w")
    file:write(generated)
    file:close()

    local file = io.open(blog_path, "w")
    file:write(cjson.encode(blog))
    file:close()

    local full_index_path = string.format("%s/%s", blog_path:gsub("wvblog.json", ""), blog.index)
    local full_node_skeleton_path = string.format("%s/%s", blog_path:gsub("wvblog.json", ""), blog.index_node_skeleton)
    local index_text = Helpers.file_text(full_index_path)
    local file = io.open(full_index_path, "w")
    file:write(IndexManager.append_node(index_text, Helpers.file_text(full_node_skeleton_path), post_title, post_date, post_description, post_link))
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

local Blog = require("blog")
local CmdHelpers = require("command-helpers")
local Helpers = require("helpers")
local cjson = require("cjson")

local function new_blog_func(cmd)
    local dir

    local dir_arg = cmd:get_arg_by_name("-d")
    if dir_arg then
        dir = dir_arg:get_value_by_name("dir").value
    else
        dir = "./"
    end

    local fields =
    {
        -- arg name,              field name,            message,                            default
        {"--posts-dir",           "posts_dir",           "Specify the posts directory.",     "posts"},
        {"--skeleton",            "skeleton",            "Specify the skeleton file.",       "skeleton.html"},
        {"--index",               "index",               "Specify the index file.",          "index.html"},
        {"--index-node-skeleton", "index_node_skeleton", "Specify the index node skeleton.", "index-node-skeleton.html"},
    }
    local o = {}

    for _, field in ipairs(fields) do
        local arg_name = field[1]
        local field_name = field[2]
        local message = field[3]
        local default = field[4]

        local arg = cmd:get_arg_by_name(arg_name)
        if arg then
            o[field_name] = arg:get_value_by_name("value")
        else
            io.write(string.format("%s (%s) ", message, default))
            local input = io.read():gsub("\n", "")
            if input == "" then input = default end

            o[field_name] = input
        end
    end

    local encoded = cjson.encode(Blog:new(o))

    local file = io.open(string.format("%s/wvblog.json", dir), "w")
    file:write(encoded)
    file:close()
end

local long_help = [[
Create a new wvblog.json file in the current or provided directory.
        Fields will be accepted from standard input if they are not provided from arguments.]]

return CmdHelpers.new_command
{
    name = "new-blog",
    short_help = "Create a new wvblog.json file in the current or provided directory.",
    long_help = long_help,
    func = new_blog_func,

    possible_args =
    {
        CmdHelpers.new_arg
        (
            {"-d", "--dir"},
            "Specify the output directory for the wvblog file. Defaults to `./`.",
            CmdHelpers.ArgType.OPTIONAL,
            {
                CmdHelpers.new_value("dir", CmdHelpers.ValueType.REQUIRED),
            }
        ),
        CmdHelpers.new_arg
        (
            "--posts-dir",
            "Specify the posts directory.",
            CmdHelpers.ArgType.OPTIONAL,
            {
                CmdHelpers.new_value("value", CmdHelpers.ValueType.REQUIRED)
            }
        ),
        CmdHelpers.new_arg
        (
            "--skeleton",
            "Specify the blog post skeleton file.",
            CmdHelpers.ArgType.OPTIONAL,
            {
                CmdHelpers.new_value("value", CmdHelpers.ValueType.REQUIRED)
            }
        ),
        CmdHelpers.new_arg
        (
            "--index",
            "Specify the index file.",
            CmdHelpers.ArgType.OPTIONAL,
            {
                CmdHelpers.new_value("value", CmdHelpers.ValueType.REQUIRED)
            }
        ),
        CmdHelpers.new_arg
        (
            "--index-node-skeleton",
            "Specify the index node skeleton.",
            CmdHelpers.ArgType.OPTIONAL,
            {
                CmdHelpers.new_value("value", CmdHelpers.ValueType.REQUIRED)
            }
        ),
    },
}

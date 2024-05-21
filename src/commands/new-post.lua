local CmdHelpers = require("command-helpers")

local function new_post_func(cmd)
    print("i am the new post func")
end

return CmdHelpers.new_command
{
    name = "new-post",
    short_help = "Generate a new blog post.",
    long_help = 
    [[
        Generate a new blog post.
    ]],
    func = new_post_func,
}

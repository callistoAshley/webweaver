local CmdHelpers = require("command-helpers")

local function new_blog_func(cmd)
    print("i am the new blog func")
end

return CmdHelpers.new_command
{
    name = "new-blog",
    short_help = "Create a new wvblog.json file in the current or provided directory.",
    long_help = 
    [[Create a new wvblog.json file in the current or provided directory.]],
    func = new_blog_func,

    possible_args =
    {
        CmdHelpers.new_arg
        (
            {"-d", "--dir"},
            "Specify the output directory for the wvblog file.",
            CmdHelpers.ArgType.REQUIRED,
            {
                CmdHelpers.new_value("dir", CmdHelpers.ValueType.REQUIRED),
            }
        ),
    },
}

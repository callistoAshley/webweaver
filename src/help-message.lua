local HelpMessage = {}

function HelpMessage.print()
    print("USAGE: webweaver <command> [args]")
    print("         ")
    print("COMMANDS:")
    for _, cmd in ipairs(require("command-executor").commands) do
        if type(cmd) == "table" then
            print(string.format("    %s: %s", cmd.name, cmd.short_help))
        end
    end
end

return HelpMessage

local CommandExecutor = 
{
    commands =
    {
        require("commands.help"),
        require("commands.new-blog"),
        require("commands.new-post"),
        require("commands.parse"),
    },
}

function CommandExecutor.get_cmd_by_name(name)
    for _, cmd in ipairs(CommandExecutor.commands) do
        if cmd.name == name then return cmd end
    end
    return nil
end

function CommandExecutor.execute(cmd)
    if type(cmd) == "string" then
        local name = cmd
        cmd = CommandExecutor.get_cmd_by_name(cmd)
        if not cmd then
            return error(string.format("No such command %s", name))
        end
        cmd.func(cmd)
    end
end

return CommandExecutor

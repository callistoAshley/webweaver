require("install-missing-modules")()

local CliParser = require("cli-parser")
local HelpMessage = require("help-message")
local Parser = require("parser")

if (#arg == 1 and arg[1] == "--help") or #arg == 0 then
    HelpMessage.print()
    return
end

local cmd_name = arg[1]
local cmd = CliParser.parse(arg)

if not cmd then
    return error(string.format("No such command `%s` (use `--help` for a list of commands)", cmd_name))
end

cmd:func()

--[[
local str = 
hello!! i am a string
i am a line break

i am a new paragraph, hello!
more words go here

[italic]i am some italic text[/]

[link dest="https://www.callistoashley.dev/whatever.html"]i am a hyperlink[/] 

print(Parser:parse(str))
]]

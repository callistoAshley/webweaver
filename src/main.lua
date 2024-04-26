local Parser = require("parser")

local str = [[
hello!! i am a string
i am a line break

i am a new paragraph, hello!
more words go here

[italic]i am some italic text[/]

[link dest="https://www.callistoashley.dev/whatever.html"]i am a hyperlink[/] ]]

print(Parser:parse(str))

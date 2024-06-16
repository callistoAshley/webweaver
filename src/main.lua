require("install-missing-modules")()

local CliParser = require("cli-parser")
local HelpMessage = require("help-message")
local Parser = require("parser")

local HtmlParser = require("html-parser")
local result = HtmlParser.parse_str(
[[<!DOCTYPE html>
<html lang="en">
    <head>
        <title>callistoAshley</title>
        <meta name="description" content="callistoAshley's website">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="style/homepage.css">
        <link rel="stylesheet" href="style/roundbox.css">
    </head>
    <body>
        <header>callistoAshley</header>
        <nav class="roundbox">
            <a class="nav-link" href="index.html"       >about</a>
            <a class="nav-link" href="blog.html"        >blog</a>
            <a class="nav-link" href="thingimajigs.html">thingimajigs</a>
            <a class="nav-link" href="doodads.html"     >doodads</a>
            <a class="nav-link" href="trinkets.html"    >trinkets</a>
        </nav>
        <main class="roundbox">
            <!--<img src="image/hackercat.png" style="float: left; padding: 8px; " width=128 height=192 />--> <!-- this looks like a fucking NFT -->
            <p>
                hi, i'm callisto ashley, and this is my website! i'm a programmer, musician and digital artist, and here i keep a little blog. make yourself at home!
            </p>
            <p>
                my pronouns are they/them and fae/faer.
            </p>
            <p>
                all HTML, CSS and JS sources on this site are licensed under the <a href="unlicense.html">Unlicense</a>, with exceptions where noted.
            </p>
            <p>
                this site uses fonts created by <a href="https://int10h.org/oldschool-pc-fonts/">VileR</a>.
            </p>
            <p>
                please <a href="contact.html">reach out to me</a> if you have problems viewing this site on your browser, accessibility concerns, questions, 
                or if you just liked something i made!
            </p>
            <p style="text-align: center;">
                meow :3
            </p>
        </main>
        <footer>
            <img src="image/88x31/neovim.gif" alt="Made with Neovim" />
            <img src="image/88x31/nonbinary.gif" alt="non-binary pride!" />
            <a href="https://plasticdino.neocities.org/"><img src="image/88x31/queer.png" alt="you're telling me a queer coded this" /></a>
        </footer>
    </body>
</html>
]])

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

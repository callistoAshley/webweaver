#!/usr/bin/env lua
-- TODO: blog management including config and index generation
-- TODO: also, some custom error handling mechanisms would be nice, so an ugly stack trace isn't being dumped to standard output whenever something goes wrong

-- bad awful no good hack: this won't work if webweaver is added to the PATH
-- FIXME: don't do this
package.path = string.format("%s;%s/src/?.lua", package.path, arg[0]:gsub("webweaver.lua$", ""):gsub("webweaver$", ""))
require("main")

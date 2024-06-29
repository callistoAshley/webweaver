#!/usr/bin/env lua
-- TODO: records, blog management including config and index generation

-- bad awful no good hack: this won't work if webweaver is added to the PATH
-- FIXME: don't do this
package.path = string.format("%s;%s/src/?.lua", package.path, arg[0]:gsub("webweaver.lua$", ""):gsub("webweaver$", ""))
require("main")

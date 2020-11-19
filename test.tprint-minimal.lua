local tprint = require "tprint.minimal"

local passert=print
local r

r=tprint({"a",{},22,{foo={bar="BAR"}},false})
assert(r=='{\n\t[1] = "a",\n\t[2] = {\n\t},\n\t[3] = 22,\n\t[4] = {\n\t\t["foo"] = {\n\t\t\t["bar"] = "BAR",\n\t\t},\n\t},\n\t[5] = false,\n}')

r=tprint({"a",{},22,{foo={bar="BAR"}},false}, {eol="",indent="",assign="="})
assert(r=='{[1]="a",[2]={},[3]=22,[4]={["foo"]={["bar"]="BAR",},},[5]=false,}')


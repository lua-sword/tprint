local tprint = require "tprint"

local passert=print

local inline,ls,empty_table

inline=true ls=","
assert(tprint({}, {inline=inline,list_sep_last=ls})=="{}")
assert(tprint({"a"}, {inline=inline,list_sep_last=ls})== '{"a",}')
assert(tprint({aa="AA"}, {inline=inline,list_sep_last=ls,kshort=true})=='{aa = "AA",}')
assert(tprint({aa="AA"}, {inline=inline,list_sep_last=ls,kshort=false})=='{["aa"] = "AA",}')
assert(tprint({"aa"}, {inline=inline,list_sep_last=ls,ishort=false})=='{[1] = "aa",}')

inline=true ls=nil
assert(tprint({}, {inline=inline,list_sep_last=ls})=="{}")
assert(tprint({"a"}, {inline=inline,list_sep_last=ls})== '{"a"}')
assert(tprint({aa="AA"}, {inline=inline,list_sep_last=ls,kshort=true})=='{aa = "AA"}')
assert(tprint({aa="AA"}, {inline=inline,list_sep_last=ls,kshort=false})=='{["aa"] = "AA"}')
assert(tprint({"aa"}, {inline=inline,list_sep_last=ls,ishort=false})=='{[1] = "aa"}')

inline="compact" ls=","
assert(tprint({}, {inline=inline,list_sep_last=ls})=="{}")
assert(tprint({"a"}, {inline=inline,list_sep_last=ls})== '{"a",}')
assert(tprint({aa="AA"}, {inline=inline,list_sep_last=ls,kshort=true})=='{aa="AA",}')
assert(tprint({aa="AA"}, {inline=inline,list_sep_last=ls,kshort=false})=='{["aa"]="AA",}')
assert(tprint({"aa"}, {inline=inline,list_sep_last=ls,ishort=false})=='{[1]="aa",}')

inline="compact" ls=nil
assert(tprint({}, {inline=inline,list_sep_last=ls})=="{}")
assert(tprint({"a"}, {inline=inline,list_sep_last=ls})== '{"a"}')
assert(tprint({aa="AA"}, {inline=inline,list_sep_last=ls,kshort=true})=='{aa="AA"}')
assert(tprint({aa="AA"}, {inline=inline,list_sep_last=ls,kshort=false})=='{["aa"]="AA"}')
assert(tprint({"aa"}, {inline=inline,list_sep_last=ls,ishort=false})=='{[1]="aa"}')

inline=false ls=","
assert(tprint({}, {inline=inline,list_sep_last=ls})=="{}")
assert(tprint({"a"}, {inline=inline,list_sep_last=ls})=='{\n\t"a",\n}')
assert(tprint({aa="AA"}, {inline=inline,list_sep_last=ls,kshort=true})=='{\n\taa = "AA",\n}')
assert(tprint({aa="AA"}, {inline=inline,list_sep_last=ls,kshort=false})=='{\n\t["aa"] = "AA",\n}')
assert(tprint({"aa"}, {inline=inline,list_sep_last=ls,ishort=false})=='{\n\t[1] = "aa",\n}')

inline=false
assert(tprint({}, {inline=inline})=="{}")
assert(tprint({"a"}, {inline=inline})=='{\n\t"a"\n}')
assert(tprint({aa="AA"}, {inline=inline,kshort=true})=='{\n\taa = "AA"\n}')
assert(tprint({aa="AA"}, {inline=inline,kshort=false})=='{\n\t["aa"] = "AA"\n}')
assert(tprint({"aa"}, {inline=inline,ishort=false})=='{\n\t[1] = "aa"\n}')

inline=false empty_table=false
assert(tprint({}, {inline=false,empty_table=false})=="{\n}")
assert(tprint({"a",{},"b"}, {inline=false,empty_table=false})=='{\n\t"a",\n\t{\n\t},\n\t"b"\n}')
assert(tprint({"a",{foo={}},"b"}, {inline=false,empty_table=false})=='{\n\t"a",\n\t{\n\t\tfoo = {\n\t\t}\n\t},\n\t"b"\n}')


--[[
local t = {}
t.a = {t2 = t}
t.b = "b"
t.n = 3.14
t[1]=true

print("t="..tprint(t))
]]--

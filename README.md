# tprint

`tprint` is a pretty printer util.
Usefull to dump a table.

# sample of use

```lua
local t = {"a",{},22,{foo={bar="BAR"}},false}
print(require"tprint"(t))
```

```
{"a",{},22,{foo = {bar = "BAR"}},false}
```

```lua
local t = {"a",{},22,{foo={bar="BAR"}},false}
print(require"tprint"(t,{inline=false}))
```

```
{
	"a",
	{},
	22,
	{
		foo = {
			bar = "BAR"
		}
	},
	false
}
```


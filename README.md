# tprint

`tprint` is a pretty printer util.
Usefull to dump a table.

# sample of use


## inline by default

```lua
local t = {"a",{},22,{foo={bar="BAR"}},false}
print(require"tprint"(t))
```

```lua
{"a",{},22,{foo = {bar = "BAR"}},false}
```

## disable inline

```lua
local t = {"a",{},22,{foo={bar="BAR"}},false}
print(require"tprint"(t,{inline=false}))
```

```lua
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


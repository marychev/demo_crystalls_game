# Pretty crystalls
## Demo game by LUA

Run
```
lua main.lua 
```

You can set small or some other MODE to manage to display of cells use `settings.lua`


You can set a custom map of crystals or random map
```
function IGame:init()
   -- You can make some map random
   ----------------------------------
   -- self.area:do_random_map()

   -- You can create a new custom map
   ----------------------------------
   self.area:do_level()
end
```
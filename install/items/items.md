['basic_rod'] = { label = 'Fishing rod', stack = false, weight = 250, buttons = {{ label = 'Throw the bait', action = function(slot) TriggerServerEvent('prp_fishing:startFishing', slot) end }} },
['graphite_rod'] = { label = 'Graphite rod', stack = false, weight = 350, buttons = {{ label = 'Throw the bait', action = function(slot) TriggerServerEvent('prp_fishing:startFishing', slot) end }} },
['titanium_rod'] = { label = 'Titanium rod', stack = false, weight = 450, buttons = {{ label = 'Throw the bait', action = function(slot) TriggerServerEvent('prp_fishing:startFishing', slot) end }}},

['basic_fishing_hook'] = { label = 'Basic fishing hook', stack = true, weight = 500 },

['fish_cooler_box_small'] = { label = 'Small cooler box', description = 'A cooler box to storage some fish.', weight = 300, stack = false },

['small_fishing_net'] = { label = 'Small fishing net', weight = 200, stack = true },

['worms'] = { label = 'Worms', weight = 10 },
['artificial_bait'] = { label = 'Artificial bait', weight = 30 },

['anchovy'] = { label = 'Anchovy', stack = false, weight = 20 },
['grouper'] = { label = 'Grouper', stack = false, weight = 3500 },
['haddock'] = { label = 'Haddock', stack = false, weight = 500 },
['mahi_mahi'] = { label = 'Mahi Mahi', stack = false, weight = 3500 },
['piranha'] = { label = 'Piranha', stack = false, weight = 1500 },
['red_snapper'] = { label = 'Red Snapper', stack = false, weight = 2500 },
['salmon'] = { label = 'Salmon', stack = false, weight = 1000 },
['shark'] = { label = 'Shark', stack = false, weight = 7500 },
['trout'] = { label = 'Trout', stack = false, weight = 750 },
['tuna'] = { label = 'Tuna', stack = false, weight = 10000 },
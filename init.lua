local function smoke_pos(user)
	local pos = user:get_pos()
	local look = user:get_look_horizontal()
	pos.y = pos.y + 1.4
	pos.x = pos.x - math.sin(look)*0.3
	pos.z = pos.z + math.cos(look)*0.3
	return pos
end

playereffects.register_effect_type("blunt_high", "you feel high", nil, {"gravity"},
	function(player)
		player:set_physics_override({gravity=0.2})
	end,
	function(effect,player)
		player:set_physics_override({gravity=1})
	end
)

minetest.register_tool("blunt:blunt", {
	description = "Blunt",
	inventory_image = "blunt.png",
	wield_image = "blunt.png^[transformR180",
	groups = {tool = 1},
	on_use = function(itemstack, user, pointed_thing)
		minetest.add_particle({
			pos = smoke_pos(user),
			velocity = {x= 0, y= 0.4, z= 0},
			expirationtime = 4,
			size = 5,
			texture = "fake_fire_particle_anim_smoke.png",
			animation = {type="vertical_frames", aspect_w=16, aspect_h=16, length = 0.9,},
		})
		playereffects.apply_effect_type("blunt_high", 10, user)
		itemstack:add_wear_by_uses(21)
		return itemstack
	end,
})

minetest.register_craft({
	output = "blunt:blunt",
	recipe = {
		{"","default:paper","default:paper"},
		{"default:paper", "farming:hemp_leaf", "farming:hemp_leaf"},
		{"","default:paper","default:paper"}
	}
})

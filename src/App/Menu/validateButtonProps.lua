local Menu = script.Parent
local App = Menu.Parent
local UIBlox = App.Parent
local Packages = UIBlox.Parent

local t = require(Packages.t)

return t.array(t.strictInterface({
	-- Icon can either be an Image in a ImageSet or a regular image asset
	icon = t.optional(t.union(t.table, t.string)),
	text = t.string,
	onActivated = t.callback,
	disabled = t.optional(t.boolean),

	-- Input binding key for gamepad support
	inputBindingKey = t.optional(t.string),

	-- A KeyCode to display a keycode hint for, the display string based on
	-- the users keyboard or gamepad button is displayed.
	keyCodeLabel = t.optional(t.union(
		t.enum(Enum.KeyCode),
		t.strictInterface({
			key = t.enum(Enum.KeyCode),
			axis = t.optional(t.string),
		})
	)),
	selected = t.optional(t.boolean),
	stayOnActivated = t.optional(t.boolean),

	renderRightSideGadget = t.optional(t.callback),
	rightSideGadgetSize = t.optional(t.Vector2),

	iconColorOverride = t.optional(t.Color3),
	textColorOverride = t.optional(t.Color3),
}))

local ValidatorRoot = script.Parent
local StyleRoot = ValidatorRoot.Parent
local UIBloxRoot = StyleRoot.Parent
local t = require(UIBloxRoot.Parent.t)

local Color = require(ValidatorRoot.validateColorInfo)
local SelectionCursorType = require(ValidatorRoot.validateSelectionCursorInfo)
local ThemedBackgroundImage = require(ValidatorRoot.validateThemedBackgroundImageInfo)

local ThemePalette = t.strictInterface({
	BackgroundDefault = Color,
	BackgroundContrast = Color,
	BackgroundMuted = Color,
	BackgroundUIDefault = Color,
	BackgroundUIContrast = Color,
	BackgroundOnHover = Color,
	BackgroundOnPress = Color,

	UIDefault = Color,
	UIMuted = Color,
	UIEmphasis = Color,

	ContextualPrimaryDefault = Color,
	ContextualPrimaryOnHover = Color,
	ContextualPrimaryContent = Color,

	SystemPrimaryDefault = Color,
	SystemPrimaryOnHover = Color,
	SystemPrimaryContent = Color,

	SecondaryDefault = Color,
	SecondaryOnHover = Color,
	SecondaryContent = Color,

	IconDefault = Color,
	IconEmphasis = Color,
	IconOnHover = Color,

	TextEmphasis = Color,
	TextDefault = Color,
	TextMuted = Color,
	TextLink = Color,

	Divider = Color,
	Overlay = Color,
	DropShadow = Color,
	NavigationBar = Color,
	PlaceHolder = Color,

	OnlineStatus = Color,
	OfflineStatus = Color,
	Success = Color,
	Alert = Color,

	Badge = Color,
	BadgeContent = Color,

	SelectionCursor = SelectionCursorType,
	PlayerBackgroundDefault = ThemedBackgroundImage,
	ItemBackgroundDefault = ThemedBackgroundImage,
})

return ThemePalette

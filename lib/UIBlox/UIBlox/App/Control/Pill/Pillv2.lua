--!strict
--[[
	Button-like component that is used for filtering.

	When selected, the background is filled and an X icon is
	shown to the right of the text. Otherwise, the button uses
	a pill outline only.

	Pills can be used directly or via a PillGroup.
]]
local TextService = game:GetService("TextService")

local Control = script.Parent.Parent
local App = Control.Parent
local UIBlox = App.Parent
local Packages = UIBlox.Parent
local Core = UIBlox.Core

local Cryo = require(Packages.Cryo)
local React = require(Packages.React)

local Images = require(App.ImageSet.Images)
local IconSize = require(App.ImageSet.Enum.IconSize)
local getIconSize = require(App.ImageSet.getIconSize)
local useSelectionCursor = require(App.SelectionImage.useSelectionCursor)
local CursorKind = require(App.SelectionImage.CursorKind)
local useStyle = require(Core.Style.useStyle)
local ControlState = require(Core.Control.Enum.ControlState)
local Interactable = require(Core.Control.Interactable)
local useControlState = require(Core.Control.useControlState)
local getContentStyle = require(Core.Button.getContentStyle)

local GenericTextLabel = require(Core.Text.GenericTextLabel.GenericTextLabel)
local ImageSetComponent = require(UIBlox.Core.ImageSet.ImageSetComponent)
local ShimmerPanel = require(UIBlox.App.Loading.ShimmerPanel)

local INNER_PADDING = 12
local LIST_PADDING = 4
local BUTTON_HEIGHT = 28
local MIN_BUTTON_WIDTH = 28
local MAX_BUTTON_WIDTH = 240

export type Props = {
	-- Position in an ordered layout
	layoutOrder: number?,
	-- Text shown in the Pill
	text: string?,
	-- Flag that indicates that the Pill is selected (background is filled)
	isSelected: boolean?,
	-- Flag that indicates that the Pill is still loading
	isLoading: boolean?,
	-- Flag that indicates that the Pill is disabled
	isDisabled: boolean?,
	-- Callback function when the Pill is clicked
	onActivated: (() -> ())?,

	-- optional parameters for RoactGamepad
	NextSelectionLeft: any,
	NextSelectionRight: any,
	NextSelectionUp: any,
	NextSelectionDown: any,
	controlRef: any,
}

local CLOSE_ICON = "icons/navigation/close_small"

local SELECTED_ICON_STATE_COLOR = {
	[ControlState.Default] = "SystemPrimaryContent",
	[ControlState.Hover] = "SystemPrimaryContent",
}

local TEXT_STATE_COLOR = {
	[ControlState.Default] = "TextDefault",
	[ControlState.Hover] = "TextEmphasis",
}

local SELECTED_TEXT_STATE_COLOR = {
	[ControlState.Default] = "SystemPrimaryContent",
	[ControlState.Hover] = "SystemPrimaryContent",
}

local BUTTON_STATE_COLOR = {
	[ControlState.Default] = "BackgroundUIDefault",
	[ControlState.Hover] = "BackgroundUIDefault",
}

local SELECTED_BUTTON_STATE_COLOR = {
	[ControlState.Default] = "SystemPrimaryDefault",
	[ControlState.Hover] = "SystemPrimaryOnHover",
}

local BUTTON_STATE_COLOR_LAYER2 = {
	[ControlState.Default] = "BackgroundOnHover", -- unused
	[ControlState.Hover] = "BackgroundOnHover",
}

local function Pillv2(props: Props)
	local controlState, onStateChanged = useControlState()
	local style = useStyle()
	local font = style.Font

	local layoutOrder = props.layoutOrder or 1
	local isSelected = props.isSelected or false
	local isDisabled = props.isDisabled or false
	local isLoading = props.isLoading or false
	local text = props.text or ""
	local onActivated = props.onActivated

	local selectionCursor = useSelectionCursor(CursorKind.SmallPill)

	local textStateColorMap = if isSelected then SELECTED_TEXT_STATE_COLOR else TEXT_STATE_COLOR
	local buttonStateColorMap = if isSelected then SELECTED_BUTTON_STATE_COLOR else BUTTON_STATE_COLOR

	local iconStyle = getContentStyle(SELECTED_ICON_STATE_COLOR, controlState, style)
	local textStyle = getContentStyle(textStateColorMap, controlState, style)
	local buttonStyle = getContentStyle(buttonStateColorMap, controlState, style)
	local buttonStyleLayer2 = getContentStyle(BUTTON_STATE_COLOR_LAYER2, controlState, style)

	local iconSize = getIconSize(IconSize.Small)
	local baseSize = font.BaseSize
	local fontSize = font.CaptionHeader.RelativeSize * baseSize
	local textBounds = TextService:GetTextSize(text, fontSize, font.CaptionHeader.Font, Vector2.new(10000, 10000)).X

	local pillWidth = textBounds + (INNER_PADDING * 2)
	local textAreaSize = MAX_BUTTON_WIDTH - (INNER_PADDING * 2)
	if isSelected then
		local closeIconSpace = LIST_PADDING + iconSize
		pillWidth += closeIconSpace
		textAreaSize -= closeIconSpace
	end

	if isLoading then
		return React.createElement(ShimmerPanel, {
			LayoutOrder = layoutOrder,
			Size = UDim2.new(0, pillWidth, 0, BUTTON_HEIGHT),
			cornerRadius = UDim.new(1, 0),
		})
	end

	local showSecondLayerBackgrounod = not isSelected and controlState == ControlState.Hover

	return React.createElement(Interactable, {
		Size = UDim2.new(0, pillWidth, 0, BUTTON_HEIGHT),
		BackgroundColor3 = buttonStyle.Color,
		BackgroundTransparency = buttonStyle.Transparency,
		ImageColor3 = buttonStyle.Color,
		ImageTransparency = buttonStyle.Transparency,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		LayoutOrder = layoutOrder,
		ScaleType = Enum.ScaleType.Slice,
		isDisabled = isDisabled,

		SelectionImageObject = selectionCursor,
		[React.Event.Activated] = if not isLoading then onActivated else nil,
		onStateChanged = onStateChanged,

		ref = props.controlRef,
		NextSelectionLeft = props.NextSelectionLeft,
		NextSelectionRight = props.NextSelectionRight,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown,
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(1, 0),
		}),
		UISizeConstraint = React.createElement("UISizeConstraint", {
			MinSize = Vector2.new(MIN_BUTTON_WIDTH, BUTTON_HEIGHT),
			MaxSize = Vector2.new(MAX_BUTTON_WIDTH, BUTTON_HEIGHT),
		}),
		BackgroundLayer2 = React.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BorderSizePixel = 0,
			BackgroundColor3 = buttonStyleLayer2.Color,
			BackgroundTransparency = if showSecondLayerBackgrounod then buttonStyleLayer2.Transparency else 1,
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),
			Content = React.createElement("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(0, textBounds + LIST_PADDING + iconSize, 1, 0),
				ClipsDescendants = true,
				BackgroundTransparency = 1,
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					Padding = UDim.new(0, LIST_PADDING),
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				}),
				TextArea = string.len(text) > 0 and React.createElement("Frame", {
					Size = UDim2.fromOffset(textBounds, fontSize),
					LayoutOrder = 1,
					BackgroundTransparency = 1,
				}, {
					PillText = React.createElement(GenericTextLabel, {
						Text = text,
						BackgroundTransparency = 1,
						fontStyle = font.CaptionHeader,
						colorStyle = textStyle,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Size = UDim2.fromOffset(textAreaSize, fontSize),
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
					}),
					React.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(textAreaSize, BUTTON_HEIGHT),
					}),
				}),
				CloseIcon = isSelected and React.createElement(ImageSetComponent.Label, {
					LayoutOrder = 2,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.fromOffset(iconSize, iconSize),
					BackgroundTransparency = 1,
					Image = Images[CLOSE_ICON],
					ImageColor3 = iconStyle.Color,
					ImageTransparency = iconStyle.Transparency,
				}),
				UISizeConstraint = React.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(MAX_BUTTON_WIDTH - (INNER_PADDING * 2), BUTTON_HEIGHT),
				}),
			}),
		}),
	})
end

return React.forwardRef(function(props, ref)
	return React.createElement(Pillv2, Cryo.Dictionary.join(props, { controlRef = ref }))
end)
